import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditBiblestudy extends StatefulWidget {
  final BibleStudyMaterial bibleStudy;
  const EditBiblestudy({super.key, required this.bibleStudy});

  @override
  State<EditBiblestudy> createState() => _EditBiblestudyState();
}

class _EditBiblestudyState extends State<EditBiblestudy> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Primary Details Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // Dynamic Chapters Controllers
  int _selectedChapterNum = 1;
  late List<TextEditingController> _chapterTitleControllers;

  XFile? _studyImage;
  PlatformFile? _studyPdf;

  @override
  void initState() {
    super.initState();
    _loadBibleStudyData(widget.bibleStudy);
  }

  void _loadBibleStudyData(BibleStudyMaterial study) {
    // Basic Details
    _titleController.text = study.title;
    _subTitleController.text = study.subTitle;
    _amountController.text = study.amount.toString();

    // Chapters Initialization
    final int contentCount = study.contents.length;
    _selectedChapterNum = contentCount > 0 ? contentCount : 1;

    // Initialize list of controllers with existing chapter titles
    _chapterTitleControllers = List.generate(_selectedChapterNum, (i) {
      if (i < study.contents.length) {
        // Find the chapter title based on its index (which corresponds to chapterNum - 1)
        final chapter = study.contents.firstWhere(
          (c) => c.chapterNum == i + 1,
          orElse: () => Chapter(chapterNum: i + 1, chapterTitle: ''),
        );
        return TextEditingController(text: chapter.chapterTitle);
      }
      return TextEditingController();
    });

    // If the study had no chapters loaded, ensure we have at least one empty controller
    if (contentCount == 0) {
      _chapterTitleControllers = [TextEditingController()];
    }
  }

  void _updateChapterControllers(int newCount) {
    setState(() {
      final oldCount = _selectedChapterNum;
      _selectedChapterNum = newCount;

      // Preserve existing controllers and add new empty ones if count increases
      _chapterTitleControllers = List.generate(newCount, (index) {
        if (index < oldCount) {
          return _chapterTitleControllers[index];
        }
        return TextEditingController();
      });
    });
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _studyImage = pickedFile;
    });
  }

  Future<void> _pickStudyFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _studyPdf = result.files.first;
      });
    }
  }

  void _submitChanges() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all required fields', context);
    }

    setState(() => _isSaving = true);

    try {
      // 1. Construct Chapter Models
      final List<Chapter> contents = [];
      int actualChapterCount = 0;

      for (int i = 0; i < _selectedChapterNum; i++) {
        final title = _chapterTitleControllers[i].text.trim();

        // Only include chapters with non-empty titles
        if (title.isNotEmpty) {
          actualChapterCount++;
          contents.add(Chapter(
            chapterNum: i + 1, // Chapter numbers start at 1
            chapterTitle: title,
          ));
        }
      }

      // 2. Handle File Updates (Mocked - replace with actual upload logic)
      final String finalCoverImagePath =
          _studyImage?.path ?? widget.bibleStudy.coverImage;
      final String finalPdfLink = _studyPdf?.path ?? widget.bibleStudy.pdfLink;

      // 3. Create the Updated BibleStudyMaterial Model
      final BibleStudyMaterial updatedStudy = BibleStudyMaterial(
        bibleStudyId:
            widget.bibleStudy.bibleStudyId, // CRITICAL: Keep the original ID
        title: _titleController.text,
        subTitle: _subTitleController.text,
        amount: double.parse(_amountController.text),
        coverImage: finalCoverImagePath,
        pdfLink: finalPdfLink,
        contents: contents,
        chapterNum: actualChapterCount, // Use the count of non-empty chapters
      );
      AdminActivity newActivity = AdminActivity(
        id: Uuid().v4(),
        action: 'Bible Study Edited',
        details:
            'Title: ${updatedStudy.title}, subtitle: ${updatedStudy.subTitle}',
        timestamp: DateTime.now(),
        icon: Iconsax.edit,
      );

      // notifying the populace about the update
      NotificationItems newNotification = NotificationItems(
      notificationImage: updatedStudy.coverImage,
      notificationTitle: "${updatedStudy.title} Bible Study Updated",
      notificationMessage: 'The Bible Study material ${updatedStudy.title} has been updated successfully. You can check it out now!',
      notificationDate:
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
      notificationTime:
          "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
    );

    NotificationDropDownServices notificationId =
        NotificationDropDownServices();

      await Provider.of<NotificationProvider>(context, listen: false)
            .sendGeneralNotification(newNotification);
      NotificationDropDownServices.showNotification(
          id: notificationId.getNextId(),
          title: "${updatedStudy.title} Bible Study Updated",
          body: 'The Bible Study ${updatedStudy.title} has been updated successfully.');
      // 4. Call Service Provider and Log Activity
      final studyProvider =
          Provider.of<BibleStudyProvider>(context, listen: false);
      studyProvider.updateBibleStudy(updatedStudy);
      await Provider.of<AdminActivityService>(context, listen: false)
          .logActivity(
              newActivity.action, newActivity.details, newActivity.icon);
      showMessage(
        'Bible Study content updated successfully!',
        context,
      );
      context.pop(); // Go back after successful submission
    } catch (e) {
      showMessage('An error occurred during save: ${e.toString()}', context);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Widget _buildChapterInput(int index) {
    // Ensure the controller list is initialized and the index is safe
    if (index >= _chapterTitleControllers.length) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chapter Number Display
          Container(
            width: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Ch. ${index + 1}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(width: 5),
          // Chapter Title Input
          Expanded(
            child: CustomTextInput(
              controller: _chapterTitleControllers[index],
              label: 'Chapter Title / Topic',
              isIcon: false,
              validator: (value) {
                // Only require validation if the user starts typing
                if (value!.isEmpty && index < _selectedChapterNum - 1) {
                  return 'Required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(
              Iconsax.arrow_left_2,
              size: 17,
            )),
        title: Text(
          'Editing: ${widget.bibleStudy.title}',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Basic Study Details ---
              const SectionTitle(title: 'Basic Study Details'),
              CustomTextInput(
                controller: _titleController,
                label: 'Study Title',
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _subTitleController,
                label: 'Study Subtitle',
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _amountController,
                label: 'Price (e.g., 500.00)',
                isNumber: true,
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),

              // --- 2. Study Chapters (Dynamic Sections) ---
              const SectionTitle(title: 'Study Chapters'),
              Row(
                children: [
                  const Text('Number of Chapters:',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 20),
                  DropdownButton<int>(
                    value: _selectedChapterNum,
                    items: List.generate(20, (index) => index + 1)
                        .map((e) =>
                            DropdownMenuItem<int>(value: e, child: Text('$e')))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        _updateChapterControllers(val);
                      }
                    },
                  ),
                ],
              ),
              // Dynamic Chapter TextFields
              ...List.generate(
                  _selectedChapterNum, (index) => _buildChapterInput(index)),
              // --- 3. File Update Options (Optional) ---
              const SectionTitle(title: 'Update Cover Image / PDF (Optional)'),
              _buildFilePicker(
                context,
                title: 'Current Cover: ${widget.bibleStudy.coverImage}',
                file: _studyImage?.name ?? 'Tap to select new image',
                onPressed: _pickCoverImage,
                icon: Iconsax.image,
              ),
              const SizedBox(height: 10),
              _buildFilePicker(
                context,
                title: 'Current PDF: ${widget.bibleStudy.pdfLink}',
                file: _studyPdf?.name ?? 'Tap to select new PDF file',
                onPressed: _pickStudyFile,
                icon: Iconsax.document_upload,
              ),

              const SizedBox(height: 30),

              // --- 4. Submit Button ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submitChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Iconsax.save_2, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        _isSaving ? 'Saving Changes...' : 'Save Study Content',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilePicker(
    BuildContext context, {
    required String title,
    required String file,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 5),
                  Text(
                    file,
                    style: TextStyle(
                        fontSize: 12,
                        color: file.contains('Tap to select')
                            ? Colors.red.shade400
                            : Colors.green.shade600,
                        fontStyle: FontStyle.italic),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Iconsax.arrow_right_3),
          ],
        ),
      ),
    );
  }
}
