import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
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
  ]; // initial textfield

  // --- File Handling State ---
  XFile? _coverImage;
  PlatformFile? _bookFile;

  // --- Methods ---

  void updateTextFields(int count) {
    setState(() {
      selectedChapterNum = count;
      // Re-initialize controllers, retaining old data where possible is recommended for production
      _bookChapterController =
          List.generate(count, (index) => TextEditingController());
    });
  }

  // Pick Cover Image (Mobile uses ImagePicker, Desktop/Web use FilePicker)
  Future<void> _pickCoverImage() async {
    try {
      if (kIsWeb ||
          (!kIsWeb &&
              (defaultTargetPlatform != TargetPlatform.android &&
                  defaultTargetPlatform != TargetPlatform.iOS))) {
        // Use FilePicker for Web/Desktop
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png'],
          withData: kIsWeb, // Get bytes directly for web uploads
        );

        if (result != null && result.files.single.name != null) {
          final file = result.files.single;
          setState(() {
            // FIX: Create XFile using path (desktop) or name (web/desktop).
            // XFile requires a path/name reference.
            // On web, XFile(file.name) is often enough for display purposes.
            _coverImage = XFile(file.path ?? file.name);
          });
        }
      } else {
        // Use ImagePicker for traditional mobile flow
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _coverImage = pickedFile;
          });
        }
      }
    } catch (e) {
      debugPrint('Failed to pick cover image: $e');
      showMessage(
          'Failed to pick cover image. Check permissions or platform compatibility.',
          context);
    }
  }

  // Pick Book File (PDF)
  Future<void> _pickBookFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _bookFile = result.files.single;
        });
      }
    } catch (e) {
      debugPrint('Failed to pick book file: $e');
      showMessage(
          'Failed to pick book file. Check permissions or platform compatibility.',
          context);
    }
  }

  void _uploadBookToJson() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all required fields', context);
    }

    // Validate file paths
    if (_coverImage == null) {
      return showMessage('Please select a cover image', context);
    }
    if (_bookFile == null) {
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
        // Use path for mobile/desktop, use name for web (path is null)
        coverImage: _coverImage!.path.isNotEmpty
            ? _coverImage!.path
            : _coverImage!.name,
        bookTitle: _titleController.text,
        author: _authorController.text,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        aboutAuthor: _aboutAuthorController.text,
        aboutBook: _descriptionController.text,
        chapterNum: _bookChapterController.length,
        pdfLink: _bookFile!.path ?? _bookFile!.name,
        chapters: chapters,
        ratingReviews: []);

    bool success = await Provider.of<BookProvider>(context, listen: false)
        .uploadBook(newUpload);

    if (success) {
      showMessage('Book uploaded successfully!', context);
      // GoRouter.of(context).pop();
    } else {
      showMessage('Book already exists, please upload a new book', context);
    }
  }

  // --- UI Widgets ---

  // Refactored file picker UI into a reusable component
  Widget _buildFilePickerDropZone({
    required String title,
    required IconData icon,
    required String? fileName,
    required VoidCallback onTap,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: fileName != null ? color : theme.dividerColor,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 40,
                color: fileName != null ? color : theme.disabledColor),
            const SizedBox(height: 8),
            Text(
              fileName != null
                  ? 'Selected: ${fileName.split('/').last}' // Show only the filename
                  : title,
              style: TextStyle(
                color:
                    fileName != null ? color : theme.textTheme.bodyLarge?.color,
                fontWeight:
                    fileName != null ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Tap or Drag & Drop (Desktop)',
              style: theme.textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChapterInput(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: _bookChapterController[index],
        decoration: InputDecoration(
          labelText: 'Chapter ${index + 1} Content',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        maxLines: 4,
        minLines: 1,
      ),
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

    // Determine the name of the selected files for display
    // Use path if available, otherwise use name.
    final coverImageName = _coverImage?.path.isNotEmpty == true
        ? _coverImage!.path
        : _coverImage?.name;
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

              // Cover Image Picker
              _buildFilePickerDropZone(
                title: 'Upload Book Cover (Image)',
                icon: Iconsax.image,
                fileName: coverImageName,
                onTap: _pickCoverImage,
                color: theme.colorScheme.primary,
              ),

              // Book PDF Picker
              _buildFilePickerDropZone(
                title: 'Upload Book File (PDF)',
                icon: Iconsax.document_upload,
                fileName: bookFileName,
                onTap: _pickBookFile,
                color: theme.colorScheme.tertiary,
              ),

              const SizedBox(height: 20),

              // --- 2. Text Inputs ---
              _buildTextFormField(_titleController, 'Book Title', Iconsax.book,
                  required: true),
              _buildTextFormField(
                  _authorController, 'Author Name', Iconsax.user_tag,
                  required: true),
              _buildTextFormField(
                  _amountController, 'Amount (\$)', Iconsax.dollar_circle,
                  keyboardType: TextInputType.number, required: true),
              _buildTextFormField(
                  _descriptionController, 'Book Description', Iconsax.note_text,
                  maxLines: 3, required: true),
              _buildTextFormField(
                  _aboutAuthorController, 'About Author', Iconsax.info_circle,
                  maxLines: 3, required: true),

              const SizedBox(height: 20),

              // --- 3. Chapters Input ---
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
                    items: List.generate(10, (i) => i + 1)
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

  // Reusable text form field builder
  Widget _buildTextFormField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text,
      int maxLines = 1,
      bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return '$label is required.';
                }
                if (keyboardType == TextInputType.number &&
                    double.tryParse(value) == null) {
                  return 'Please enter a valid number for $label.';
                }
                return null;
              }
            : null,
      ),
    );
  }
}
