import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
// import the reusable file
// import 'reusable_media_picker.dart'; // Assume this file is accessible
// The MediaFilePicker class is assumed to be defined and accessible.
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';
import '../../common/widget.dart';

class UploadBookScreen extends StatefulWidget {
  const UploadBookScreen({super.key});

  @override
  State<UploadBookScreen> createState() => _UploadBookScreenState();
}

class _UploadBookScreenState extends State<UploadBookScreen> {
  int selectedChapterNum = 1;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _aboutAuthorController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  List<TextEditingController> _bookChapterController = [
    TextEditingController()
  ];

  // --- File Handling State ---
  // NEW: State to store files returned from the reusable component
  XFile? _coverImage;
  PlatformFile? _bookFile;
  // REMOVED: All manual file picking methods (_pickCoverImage, _pickBookFile)

  void updateTextFields(int count) {
    setState(() {
      selectedChapterNum = count;
      _bookChapterController =
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
    List<Map<String, String>> chapters = [];
    for (int i = 0; i < _bookChapterController.length; i++) {
      String text = _bookChapterController[i].text.trim();
      if (text.isNotEmpty) {
        chapters.add({"chapter ${i + 1}": text});
      }
    }

    AboutBooks newUpload = AboutBooks(
        // Use XFile path/name
        coverImage: _coverImage!.path.isNotEmpty
            ? _coverImage!.path
            : _coverImage!.name,
        bookTitle: _titleController.text,
        author: _authorController.text,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        aboutAuthor: _aboutAuthorController.text,
        aboutBook: _descriptionController.text,
        chapterNum: _bookChapterController.length,
        // Use PlatformFile path/name
        pdfLink: _bookFile!.path ?? _bookFile!.name,
        chapters: chapters,
        ratingReviews: []);

    bool success = await Provider.of<BookProvider>(context, listen: false)
        .uploadBook(newUpload);

    if (success) {
      showMessage('Book uploaded successfully!', context);
    } else {
      showMessage('Book already exists, please upload a new book', context);
    }
  }

  // REMOVED: Widget _buildFilePickerDropZone - replaced by MediaFilePicker

  Widget _buildChapterInput(int index) {
    // ... (unchanged) ...
    return CustomTextInput(
      label: 'Chapter ${index + 1} title',
      controller: _bookChapterController[index],
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
    for (var controller in _bookChapterController) {
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
          'Upload New Book',
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
                title: 'Upload Book Cover (Image)',
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
                title: 'Upload Book File (PDF)',
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
