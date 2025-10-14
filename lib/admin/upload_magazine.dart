import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../common/widget.dart';

class UploadMagazineScreen extends StatefulWidget {
  const UploadMagazineScreen({super.key});

  @override
  State<UploadMagazineScreen> createState() => _UploadMagazineScreenState();
}

class _UploadMagazineScreenState extends State<UploadMagazineScreen> {
  int selectedChapterNum = 1;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _aboutAuthorController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  List<TextEditingController> _magazineContentController = [
    TextEditingController()
  ];

  XFile? _coverImage;
  PlatformFile? _bookFile;

  void updateTextFields(int count) {
    setState(() {
      selectedChapterNum = count;
      _magazineContentController =
          List.generate(count, (index) => TextEditingController());
    });
  }

  void _uploadBookToJson() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all required fields', context);
    }

    // Validate file paths
    if (_coverImage == null) {
      // Check against state updated by callback
      return showMessage('Please select a cover image', context);
    }
    if (_bookFile == null) {
      // Check against state updated by callback
      return showMessage('Please select the PDF book file', context);
    }

    // Process chapters
    List<Map<String, String>> content = [];
    for (int i = 0; i < _magazineContentController.length; i++) {
      String text = _magazineContentController[i].text.trim();
      if (text.isNotEmpty) {
        content.add({"Content ${i + 1}": text});
      }
    }

    /* bool success = await Provider.of<MagazineProvider>(context, listen: false)
        .uploadMagazine(newUpload);

    if (success) {
      showMessage('Magazine uploaded successfully!', context);
    } else {
      showMessage('Magazine already exists, please upload a new magazine', context);
    } */
  }

  // REMOVED: Widget _buildFilePickerDropZone - replaced by MediaFilePicker

  Widget _buildChapterInput(int index) {
    // ... (unchanged) ...
    return CustomTextInput(
      label: 'Content ${index + 1} title',
      controller: _magazineContentController[index],
      isIcon: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please add content for chapter ${index + 1}';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _aboutAuthorController.dispose();
    _amountController.dispose();
    for (var controller in _magazineContentController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          'Upload Magazine',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. File Uploads (Cover Image & PDF) ---
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

              // Book PDF Picker - USING REUSABLE WIDGET
              PdfFilePickerDropZone(
                title: 'Upload Magazine File (PDF)',
                icon: Iconsax.document_upload,
                color: theme.colorScheme.tertiary,
                onFilePicked: (file) {
                  setState(() {
                    _bookFile = file as PlatformFile;
                  });
                },
                initialFileName: bookFileName,
              ),

              const SizedBox(height: 20),

              // --- 2. Text Inputs ---
              CustomTextInput(
                label: 'Book title',
                controller: _titleController,
                icon: Iconsax.book,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add a title for this article';
                  }
                  return null;
                },
              ),
              CustomTextInput(
                label: 'Author Name',
                controller: _authorController,
                icon: Iconsax.user_tag,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add the name of the author of this book';
                  }
                  return null;
                },
              ),
              CustomTextInput(
                label: 'Amount (\$)',
                controller: _authorController,
                icon: Iconsax.dollar_circle,
                isNumber: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add the amount for this book';
                  }
                  return null;
                },
              ),
              CustomTextInput(
                label: "Book Description",
                controller: _descriptionController,
                isIcon: false,
                maxLine: 10,
                maxLength: 700,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add a description for this book';
                  }
                  return null;
                },
              ),
              CustomTextInput(
                label: "About Author",
                controller: _aboutAuthorController,
                isIcon: false,
                maxLine: 10,
                maxLength: 1000,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add about the author of this book';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Book Chapters Content',
                style: theme.textTheme.titleMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Number of Chapters: $selectedChapterNum'),
                  DropdownButton<int>(
                    value: selectedChapterNum,
                    items: List.generate(20, (i) => i + 1)
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text('$e')))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        updateTextFields(val);
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

              // --- 4. Submit Button ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _uploadBookToJson,
                  icon: const Icon(Iconsax.send_sqaure_2, color: Colors.white),
                  label: Text(
                    'Upload Book',
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
