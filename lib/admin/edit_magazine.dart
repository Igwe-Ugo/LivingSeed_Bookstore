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

class EditMagazine extends StatefulWidget {
  final MagazineModel magazine;
  const EditMagazine({super.key, required this.magazine});

  @override
  State<EditMagazine> createState() => _EditMagazineState();
}

class _EditMagazineState extends State<EditMagazine> {
  final _formKey = GlobalKey<FormState>();

  bool _isSaving = false;

  // Primary Magazine Details
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _publisherController =
      TextEditingController(); // Added

  // Editors Desk
  final TextEditingController _editorsDeskTitleController =
      TextEditingController();
  final TextEditingController _editorsDeskEditorController =
      TextEditingController();
  final TextEditingController _editorsDeskPageController =
      TextEditingController();

  // Bible Study
  final TextEditingController _bsTitleController = TextEditingController();
  final TextEditingController _bsKeyVersesController =
      TextEditingController(); // Comma separated

  // Contents/Sections
  int selectedChapterNum = 1;
  List<TextEditingController> _chapterTitleControllers = [];
  List<TextEditingController> _chapterAuthorControllers = [];
  List<TextEditingController> _chapterPageControllers = [];

  XFile? _coverImage;
  PlatformFile? _magazineFile; // Optional: To update the PDF/Epub file

  @override
  void initState() {
    super.initState();
    _loadMagazineData(widget.magazine);
  }

  void _loadMagazineData(MagazineModel magazine) {
    // Basic Details
    _titleController.text = magazine.magazineTitle;
    _issueController.text = magazine.issue;
    _subTitleController.text = magazine.subTitle;
    _priceController.text = magazine.price.toString();
    _publisherController.text = magazine.publisher;

    // Editors Desk
    _editorsDeskTitleController.text = magazine.editorsDesk.title;
    _editorsDeskEditorController.text = magazine.editorsDesk.editor;
    _editorsDeskPageController.text =
        magazine.editorsDesk.pageNumber.toString();

    // Bible Study
    _bsTitleController.text = magazine.bibleStudy.title;
    _bsKeyVersesController.text = magazine.bibleStudy.keyVerses.join(', ');

    // Contents/Sections Initialization
    final int contentCount = magazine.contents.length;
    selectedChapterNum = contentCount;

    // Initialize lists with existing data
    _chapterTitleControllers = List.generate(contentCount,
        (i) => TextEditingController(text: magazine.contents[i].chapterTitle));
    _chapterAuthorControllers = List.generate(contentCount,
        (i) => TextEditingController(text: magazine.contents[i].chapterAuthor));
    _chapterPageControllers = List.generate(
        contentCount,
        (i) => TextEditingController(
            text: magazine.contents[i].pageNumber.toString()));
  }

  void updateChapterControllers(int newCount) {
    setState(() {
      final oldCount = selectedChapterNum;
      selectedChapterNum = newCount;

      // Handle Title Controllers
      _chapterTitleControllers = List.generate(newCount, (index) {
        if (index < oldCount) return _chapterTitleControllers[index];
        return TextEditingController();
      });
      // Handle Author Controllers
      _chapterAuthorControllers = List.generate(newCount, (index) {
        if (index < oldCount) return _chapterAuthorControllers[index];
        return TextEditingController();
      });
      // Handle Page Controllers
      _chapterPageControllers = List.generate(newCount, (index) {
        if (index < oldCount) return _chapterPageControllers[index];
        return TextEditingController();
      });
    });
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _coverImage = pickedFile;
    });
  }

  Future<void> _pickMagazineFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _magazineFile = result.files.first;
      });
    }
  }

  void _submitChanges() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all required fields', context);
    }

    setState(() => _isSaving = true);

    try {
      // 1. Construct Nested Models
      final EditorsDesk editorsDesk = EditorsDesk(
        title: _editorsDeskTitleController.text,
        editor: _editorsDeskEditorController.text,
        pageNumber: int.parse(_editorsDeskPageController.text),
      );

      final List<Section> contents = [];
      for (int i = 0; i < selectedChapterNum; i++) {
        contents.add(Section(
          chapterNumber: i + 1,
          chapterTitle: _chapterTitleControllers[i].text,
          chapterAuthor: _chapterAuthorControllers[i].text,
          pageNumber: int.parse(_chapterPageControllers[i].text),
        ));
      }

      final BibleStudyMagazine bibleStudy = BibleStudyMagazine(
        title: _bsTitleController.text,
        keyVerses: _bsKeyVersesController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      );

      // 2. Handle File Updates (if new files were selected)
      // NOTE: In a real app, if _coverImage or _magazineFile is NOT null,
      // you would upload it to storage (like Firebase Storage) here and get the new URL.
      final String finalCoverImagePath =
          _coverImage?.path ?? widget.magazine.coverImage;
      // You would also update the actual magazine file path if _magazineFile is not null.

      // 3. Create the Updated Magazine Model
      final MagazineModel updatedMagazine = MagazineModel(
        magazineId: widget.magazine.magazineId,
        magazineTitle: _titleController.text,
        issue: _issueController.text,
        subTitle: _subTitleController.text,
        price: double.parse(_priceController.text),
        publisher: _publisherController.text,
        coverImage: finalCoverImagePath,
        editorsDesk: editorsDesk,
        contents: contents,
        bibleStudy: bibleStudy,
        pdfLink: widget.magazine.pdfLink,
      );

      AdminActivity newActivity = AdminActivity(
      id: Uuid().v4(),
      action: 'Magazine Edited',
      details: 'Title: ${updatedMagazine.magazineTitle}, Editor: ${updatedMagazine.editorsDesk.editor}',
      timestamp: DateTime.now(),
      icon: Iconsax.edit,
    );
    // notifying the populace about the update
      NotificationItems newNotification = NotificationItems(
      notificationImage: updatedMagazine.coverImage,
      notificationTitle: "${updatedMagazine.magazineTitle} Magazine Updated",
      notificationMessage: 'The Magazine ${updatedMagazine.magazineTitle} has been updated successfully. You can check it out now!',
      notificationDate:
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
      notificationTime:
          "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
    );

    NotificationDropDownServices notificationId =
        NotificationDropDownServices();

      // 4. Call Service Provider
      final magazineProvider =
          Provider.of<MagazineProvider>(context, listen: false);
      await magazineProvider.updateMagazine(updatedMagazine);
      await Provider.of<NotificationProvider>(context, listen: false)
            .sendGeneralNotification(newNotification);
      NotificationDropDownServices.showNotification(
          id: notificationId.getNextId(),
          title: "${updatedMagazine.magazineTitle} magazine Updated",
          body: 'The magazine ${updatedMagazine.magazineTitle} has been updated successfully.');
      await Provider.of<AdminActivityService>(context, listen: false)
          .logActivity(
              newActivity.action,
              newActivity.details,
              newActivity.icon);
      showMessage('Magazine updated successfully!', context);
      context.pop(); // Go back after successful submission
    } catch (e) {
      showMessage('An error occurred during save: ${e.toString()}', context);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Widget _buildChapterInput(int index) {
    // Ensure lists are large enough before accessing index
    if (index >= _chapterTitleControllers.length) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Section ${index + 1}',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
          const SizedBox(height: 10),
          CustomTextInput(
            label: 'Title',
            isIcon: false,
            controller: _chapterTitleControllers[index],
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: CustomTextInput(
                  controller: _chapterPageControllers[index],
                  label: 'Page #',
                  isIcon: false,
                  showEnter: false,
                  isNumber: true,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ),
              Expanded(
                child: CustomTextInput(
                  isIcon: false,
                  controller: _chapterAuthorControllers[index],
                  label: 'Author',
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 10),
            ],
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
          'Edit Magazine',
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
              // --- 1. Basic Magazine Details ---
              const SectionTitle(title: 'Basic Magazine Details'),
              CustomTextInput(
                controller: _titleController,
                label: 'Magazine Title',
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _issueController,
                label: 'Issue (e.g., October 2023)',
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _publisherController,
                isIcon: false,
                label: 'Publisher',
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _subTitleController,
                isIcon: false,
                label: 'Subtitle/Tagline',
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _priceController,
                label: '(#) Price (e.g., 150.00)',
                isIcon: false,
                isNumber: true,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),

              // --- 2. Editors Desk ---
              const SectionTitle(title: 'Editors Desk'),
              CustomTextInput(
                controller: _editorsDeskTitleController,
                label: 'Editors Desk Title',
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _editorsDeskEditorController,
                label: 'Editor Name',
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _editorsDeskPageController,
                label: 'Page Number',
                isNumber: true,
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),

              // --- 3. Bible Study Details ---
              const SectionTitle(
                  title: 'Bible Study Section (BibleStudyMagazine)'),
              CustomTextInput(
                controller: _bsTitleController,
                label: 'Bible Study Title',
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _bsKeyVersesController,
                isIcon: false,
                label:
                    'Key Verses (Comma-separated, e.g., John 3:16, Romans 5:8)',
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),

              // --- 4. Magazine Contents/Sections (Dynamic) ---
              const SectionTitle(title: 'Magazine Contents/Sections'),
              Row(
                children: [
                  const Text('Number of Sections:',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 40),
                  DropdownButton<int>(
                    value: selectedChapterNum,
                    items: List.generate(15, (index) => index + 1)
                        .map((e) =>
                            DropdownMenuItem<int>(value: e, child: Text('$e')))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        updateChapterControllers(val);
                      }
                    },
                  ),
                ],
              ),
              // Dynamic Chapter TextFields
              ...List.generate(
                  selectedChapterNum, (index) => _buildChapterInput(index)),

              // --- 5. File Update Options (Optional) ---
              const SectionTitle(title: 'Update Cover Image / File (Optional)'),
              _buildFilePicker(
                title: 'Current Cover Image: ${widget.magazine.coverImage}',
                file: _coverImage?.name ?? 'Tap to select new image',
                onPressed: _pickCoverImage,
                icon: Iconsax.image,
              ),
              const SizedBox(height: 10),
              _buildFilePicker(
                title: 'Update Magazine File',
                file: _magazineFile?.name ?? 'Tap to select new PDF file',
                onPressed: _pickMagazineFile,
                icon: Iconsax.document_upload,
              ),

              const SizedBox(height: 30),

              // --- 6. Submit Button ---
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
                          ? SizedBox(
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
                        _isSaving
                            ? 'Saving Changes...'
                            : 'Save Magazine Changes',
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

  // Helper widget for file/image picking UI
  Widget _buildFilePicker({
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
