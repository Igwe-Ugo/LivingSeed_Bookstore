import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import '../../common/widget.dart';

class UploadBibleStudy extends StatefulWidget {
  const UploadBibleStudy({super.key});

  @override
  State<UploadBibleStudy> createState() => _UploadBibleStudyState();
}

class _UploadBibleStudyState extends State<UploadBibleStudy> {
  final Uuid _uuid = const Uuid();
  int selectedChapterNum = 1;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  List<TextEditingController> _bibleStudyChapterController = [
    TextEditingController()
  ];

  // --- File Handling State ---
  // NEW: State to store files returned from the reusable component
  XFile? _coverImage;
  PlatformFile? _bookFile;
  // REMOVED: All manual file picking methods (_pickCoverImage, _pickBibleStudyFile)

  void updateTextFields(int count) {
    setState(() {
      selectedChapterNum = count;
      _bibleStudyChapterController =
          List.generate(count, (index) => TextEditingController());
    });
  }

  void _uploadBibleStudy() {
    if (_formKey.currentState!.validate() &&
        _coverImage != null &&
        _bookFile != null) {
      _uploadBibleStudyToJson();
      _clearFields();
      _formKey.currentState!.reset();
      setState(() {
        _coverImage = null;
        _bookFile = null;
      });
    } else {
      showMessage('Please fill all fields and upload files!', context);
    }
  }

  void _clearFields() {
    _titleController.clear();
    _subtitleController.clear();
    _amountController.clear();
    for (var controller in _bibleStudyChapterController) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookFileName = _bookFile?.path ?? _bookFile?.name;

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
          'Upload Bible Study Material',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover Image Picker - USING REUSABLE WIDGET
                ImagePickerDropZone(
                  title: 'Upload Cover Image',
                  icon: Iconsax.image,
                  color: Colors.green, // Kept original color
                  onFilePicked: (file) {
                    setState(() {
                      _coverImage = file as XFile;
                    });
                  },
                ),

                const SizedBox(height: 16),
                // PDF File Picker - USING REUSABLE WIDGET
                PdfFilePickerDropZone(
                  title: 'Upload Bible Study File (PDF)',
                  icon: Iconsax.document_1,
                  color: Colors.red, // Kept original color
                  onFilePicked: (file) {
                    setState(() {
                      _bookFile = file as PlatformFile;
                    });
                  },
                  initialFileName: bookFileName,
                ),

                const SizedBox(height: 16),
                CustomTextInput(
                  label: 'BibleStudy Title',
                  controller: _titleController,
                  icon: Iconsax.book,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please write the book title';
                    }
                    return null;
                  },
                ),
                CustomTextInput(
                    label: 'BibleStudy Subtitle',
                    controller: _subtitleController,
                    icon: Icons.subtitles,
                    validator: (value) {
                      return null;
                    }), // Fixed validator
                CustomTextInput(
                  label: 'BibleStudy Price ... (#)',
                  controller: _amountController,
                  icon: Iconsax.money,
                  isNumber: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please what is the price of the biblestudy?';
                    }
                    return null;
                  },
                ),
                DropdownButton(
                  value: selectedChapterNum,
                  items: List.generate(
                    20,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text(
                          'Contents of bible study?... ${index + 1} Fields'), // Updated text
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      updateTextFields(value);
                    }
                  },
                ),

                // display text field based on selected chapter numbers
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedChapterNum,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CustomTextInput(
                          label:
                              'Content Title... ${index + 1} field', // Updated label
                          controller: _bibleStudyChapterController[index],
                          isTitleNotNecessary: true,
                          isIcon: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the title for content ${index + 1}';
                            }
                            return null;
                          },
                        );
                      }),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _uploadBibleStudy,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(10, 50),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Center(
                          child: Text('Upload Bible Study',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17.0,
                                  color: Colors.white))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _uploadBibleStudyToJson() async {
    // ... (unchanged upload logic) ...
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all available input spaces', context);
    }

    List<Chapter> contents = [];

    for (int i = 0; i < _bibleStudyChapterController.length; i++) {
      String text = _bibleStudyChapterController[i].text.trim();
      if (text.isNotEmpty) {
        contents.add(Chapter(chapterNum: i + 1, chapterTitle: text));
      }
    }

    BibleStudyMaterial newUpload = BibleStudyMaterial(
      coverImage: _coverImage!.path.toString(),
      title: _titleController.text,
      subTitle: _subtitleController.text,
      amount: double.tryParse(_amountController.text) ?? 0.0,
      chapterNum: _bibleStudyChapterController.length,
      pdfLink: _bookFile!.path.toString(),
      contents: contents,
    );

    AdminActivity newActivity = AdminActivity(
      id: _uuid.v4(),
      action: 'BibleStudy uploaded',
      details:
          'Title: ${_titleController.text}, subtitle: ${_subtitleController.text}',
      timestamp: DateTime.now(),
      icon: Iconsax.message,
    );

    bool success = await Provider.of<BibleStudyProvider>(context, listen: false)
        .uploadBibleStudy(newUpload);
    if (success) {
      showMessage('Bible Study uploaded successfully!', context);
      Provider.of<AdminActivityService>(context, listen: false)
                        .logActivity(newActivity.action, newActivity.details,
                            newActivity.icon);
      GoRouter.of(context).pop();
    } else {
      showMessage(
          'Bible Study already exists, please upload a new book', context);
      return;
    }
  }
}
