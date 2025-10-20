import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import '../../common/widget.dart';
import 'package:uuid/uuid.dart';

class UploadMagazineScreen extends StatefulWidget {
  const UploadMagazineScreen({super.key});

  @override
  State<UploadMagazineScreen> createState() => _UploadMagazineScreenState();
}

class _UploadMagazineScreenState extends State<UploadMagazineScreen> {
  final _formKey = GlobalKey<FormState>();
  final Uuid _uuid = const Uuid();
  XFile? _coverImage;
  PlatformFile? _magazineFile;

  // Primary Magazine Details
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

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
  // List of controllers for all chapter fields (Title, Author, Page)
  List<TextEditingController> _chapterTitleControllers = [
    TextEditingController()
  ];
  List<TextEditingController> _chapterAuthorControllers = [
    TextEditingController()
  ];
  List<TextEditingController> _chapterPageControllers = [
    TextEditingController()
  ];

  @override
  void initState() {
    super.initState();

    _loadMagazineData();
  }

  void _loadMagazineData([MagazineModel? magazine]) {
    if (magazine == null) return;

    _titleController.text = magazine.magazineTitle;
    _issueController.text = magazine.issue;
    _subTitleController.text = magazine.subTitle;
    _priceController.text = magazine.price.toString();

    _editorsDeskTitleController.text = magazine.editorsDesk.title;
    _editorsDeskEditorController.text = magazine.editorsDesk.editor;
    _editorsDeskPageController.text =
        magazine.editorsDesk.pageNumber.toString();

    _bsTitleController.text = magazine.bibleStudy.title;
    _bsKeyVersesController.text = magazine.bibleStudy.keyVerses.join(', ');

    updateChapterControllers(magazine.contents.length);
    for (int i = 0; i < magazine.contents.length; i++) {
      _chapterTitleControllers[i].text = magazine.contents[i].chapterTitle;
      _chapterAuthorControllers[i].text = magazine.contents[i].chapterAuthor;
      _chapterPageControllers[i].text =
          magazine.contents[i].pageNumber.toString();
    }
  }

  void updateChapterControllers(int count) {
    setState(() {
      selectedChapterNum = count;
      _chapterTitleControllers = List.generate(
          count,
          (index) => index < _chapterTitleControllers.length
              ? _chapterTitleControllers[index]
              : TextEditingController());
      _chapterAuthorControllers = List.generate(
          count,
          (index) => index < _chapterAuthorControllers.length
              ? _chapterAuthorControllers[index]
              : TextEditingController());
      _chapterPageControllers = List.generate(
          count,
          (index) => index < _chapterPageControllers.length
              ? _chapterPageControllers[index]
              : TextEditingController());
    });
  }

  // --- Upload Logic ---
  void _submitMagazine() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all required fields', context);
    }

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

      // In a real app, you would upload _coverImage and _magazineFile to a storage service (like Firebase Storage) here
      // and update coverImagePath and add a new 'magazineFilePath' field to the model.

      // 3. Create Magazine Model
      final MagazineModel newUpload = MagazineModel(
        magazineId: _uuid.v4(),
        magazineTitle: _titleController.text,
        issue: _issueController.text,
        subTitle: _subTitleController.text,
        price: double.parse(_priceController.text),
        coverImage: _coverImage?.path ?? '',
        editorsDesk: editorsDesk,
        contents: contents,
        bibleStudy: bibleStudy,
        publisher: 'Living Seed Publications',
        pdfLink: _magazineFile?.name ?? '',
      );
      AdminActivity newActivity = AdminActivity(
      id: _uuid.v4(),
      action: 'Book Uploaded',
      details: 'Title: ${newUpload.magazineTitle}, Author: ${newUpload.editorsDesk.editor}',
      timestamp: DateTime.now(),
      icon: Iconsax.arrow_up_1,
    );
      NotificationItems newNotification = NotificationItems(
      notificationImage: newUpload.coverImage,
      notificationTitle: "${newUpload.magazineTitle} Book Uploaded",
      notificationMessage: 'A new Book titled ${newUpload.magazineTitle} has been uploaded successfully. You can check it out now!',
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
      await magazineProvider.uploadMagazine(newUpload);
    await Provider.of<AdminActivityService>(context, listen: false)
        .logActivity(newActivity.action, newActivity.details, newActivity.icon);
    await Provider.of<NotificationProvider>(context, listen: false)
            .sendGeneralNotification(newNotification);
      NotificationDropDownServices.showNotification(
          id: notificationId.getNextId(),
          title: "${newUpload.magazineTitle} magazine Uploaded",
          body: 'A new magazine titled ${newUpload.magazineTitle} has been uploaded successfully.');
      showMessage('Magazine uploaded successfully!', context);

      context.pop(); // Go back after successful submission
    } catch (e) {
      showMessage('An error occurred: ${e.toString()}', context);
    }
  }

  Widget _buildChapterInput(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Section ${index + 1}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
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
                  label: 'Title',
                  isIcon: false,
                  controller: _chapterTitleControllers[index],
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          CustomTextInput(
            isIcon: false,
            controller: _chapterAuthorControllers[index],
            label: 'Author',
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final magazineFileName = _magazineFile?.path ?? _magazineFile?.name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(
            Iconsax.arrow_left_2,
            size: 17,
          ),
        ),
        title: const Text(
          'Upload New Magazine',
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
              ImagePickerDropZone(
                title: 'Upload Magazine Cover (Image)',
                icon: Iconsax.image,
                color: Colors.green,
                onFilePicked: (file) {
                  setState(() {
                    _coverImage = file as XFile;
                  });
                },
              ),

              PdfFilePickerDropZone(
                title: 'Upload Magazine File (PDF)',
                icon: Iconsax.document_upload,
                color: theme.colorScheme.tertiary,
                onFilePicked: (file) {
                  setState(() {
                    _magazineFile = file as PlatformFile;
                  });
                },
                initialFileName: magazineFileName,
              ),
              const SizedBox(height: 20),
              // --- 1. Basic Magazine Details ---
              const SectionTitle(title: 'Basic Magazine Details'),
              CustomTextInput(
                isIcon: false,
                controller: _titleController,
                label: 'Magazine Title',
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                isIcon: false,
                controller: _issueController,
                label: 'Issue',
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                isIcon: false,
                controller: _subTitleController,
                label: 'Subtitle/Tagline',
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _priceController,
                label: 'Price',
                isIcon: false,
                isNumber: true,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),

              // --- 2. Editors Desk ---
              const SectionTitle(title: 'Editors Desk'),
              CustomTextInput(
                controller: _editorsDeskTitleController,
                isIcon: false,
                label: 'Editors Desk Title',
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _editorsDeskEditorController,
                isIcon: false,
                label: 'Editor Name',
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _editorsDeskPageController,
                isIcon: false,
                label: 'Page Number',
                isNumber: true,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),

              // --- 3. Bible Study Details ---
              const SectionTitle(title: 'Bible Study Section'),
              CustomTextInput(
                controller: _bsTitleController,
                label: 'Bible Study Title',
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _bsKeyVersesController,
                label: 'Key Verses',
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),

              // --- 4. Magazine Contents/Sections ---
              const SectionTitle(title: 'Magazine Contents/Sections'),
              // Chapter Count Selector
              Row(
                children: [
                  const Text('Number of Sections:',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
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
              const SizedBox(height: 10),

              // Dynamic Chapter TextFields
              ...List.generate(
                  selectedChapterNum, (index) => _buildChapterInput(index)),

              const SizedBox(height: 30),
              // --- 6. Submit Button ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _submitMagazine,
                  icon: Icon(Iconsax.send_sqaure_2, color: Colors.white),
                  label: Text(
                    'Upload Magazine',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
}
