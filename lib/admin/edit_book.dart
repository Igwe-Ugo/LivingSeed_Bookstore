import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditBook extends StatefulWidget {
  final AboutBooks aboutBooks;
  const EditBook({super.key, required this.aboutBooks});

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Primary Book Details Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _aboutBookController = TextEditingController();
  final TextEditingController _aboutAuthorController = TextEditingController();

  // Dynamic Chapters Controllers
  int _selectedChapterNum = 1;
  late List<TextEditingController> _chapterTitleControllers = [
    TextEditingController()
  ];

  XFile? _bookImage;
  PlatformFile? _bookPdf;

  @override
  void initState() {
    super.initState();
    _loadBookData(widget.aboutBooks);
  }

  // Parses the complex List<Map<String, String>> chapters structure
  void _loadBookData(AboutBooks book) {
    // Basic Details
    _titleController.text = book.bookTitle;
    _authorController.text = book.author;
    _amountController.text = book.amount.toString();
    _aboutBookController.text = book.aboutBook;
    _aboutAuthorController.text = book.aboutAuthor;

    // Chapters Initialization
    final List<String> chapterTitles = [];
    int maxChapterNumber = 0;

    // Extract titles and find the highest chapter number to set the size of the dynamic list
    for (var chapterMap in book.chapters) {
      chapterMap.forEach((key, value) {
        // Example key: "chapter 5"
        final parts = key.split(' ');
        if (parts.length == 2 && parts[0] == 'chapter') {
          final chapterNumber = int.tryParse(parts[1]) ?? 0;
          if (chapterNumber > maxChapterNumber) {
            maxChapterNumber = chapterNumber;
          }
          // Pad the list with nulls or empty strings to ensure the title lands at the correct index (chapterNumber - 1)
          while (chapterTitles.length < chapterNumber) {
            chapterTitles.add(''); // Placeholder for skipped chapters
          }
          if (chapterTitles.length == chapterNumber) {
            chapterTitles[chapterNumber - 1] = value;
          }
        }
      });
    }

    // Set the initial number of chapters (at least 1)
    _selectedChapterNum = maxChapterNumber > 0 ? maxChapterNumber : 1;

    // Initialize list of controllers with extracted chapter titles
    _chapterTitleControllers = List.generate(_selectedChapterNum, (i) {
      if (i < chapterTitles.length) {
        return TextEditingController(text: chapterTitles[i]);
      }
      return TextEditingController();
    });

    // If no chapters were found, ensure at least one empty controller is ready
    if (maxChapterNumber == 0) {
      _chapterTitleControllers = [TextEditingController()];
    }
  }

  void _updateChapterControllers(int newCount) {
    setState(() {
      final oldCount = _selectedChapterNum;
      _selectedChapterNum = newCount;

      // Ensure that existing controllers are preserved, and new ones are added
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
      _bookImage = pickedFile;
    });
  }

  Future<void> _pickBookFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _bookPdf = result.files.first;
      });
    }
  }

  void _submitChanges() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all required fields', context);
    }

    setState(() => _isSaving = true);

    try {
      final List<Map<String, String>> chapters = [];
      int actualChapterCount = 0;

      for (int i = 0; i < _selectedChapterNum; i++) {
        final title = _chapterTitleControllers[i].text.trim();

        // Only include chapters with non-empty titles for clean data
        if (title.isNotEmpty) {
          actualChapterCount++;
          chapters.add({'chapter ${i + 1}': title});
        }
      }

      // If the entire chapter list is empty, add a placeholder map to match the original structure,
      // though typically a book should have at least one chapter.
      if (chapters.isEmpty) {
        // This is a safety measure; usually the length of the list determines chapterNum.
      }

      // 2. Handle File Updates (Mocked)
      // In a real app, you would upload _bookImage and _bookPdf to storage
      final String finalCoverImagePath =
          _bookImage?.path ?? widget.aboutBooks.coverImage;
      final String finalPdfLink = _bookPdf?.path ?? widget.aboutBooks.pdfLink;

      final AboutBooks updatedBook = AboutBooks(
        bookId: widget.aboutBooks.bookId, // CRITICAL: Keep the original ID
        bookTitle: _titleController.text,
        author: _authorController.text,
        amount: double.parse(_amountController.text),
        aboutBook: _aboutBookController.text,
        aboutAuthor: _aboutAuthorController.text,
        coverImage: finalCoverImagePath,
        pdfLink: finalPdfLink,
        chapters: chapters,
        chapterNum: actualChapterCount,
        ratingReviews:
            widget.aboutBooks.ratingReviews, // Preserve existing reviews
      );
      AdminActivity newActivity = AdminActivity(
        id: Uuid().v4(),
        action: 'Book Edited',
        details:
            'Title: ${updatedBook.bookTitle}, Author: ${updatedBook.author}',
        timestamp: DateTime.now(),
        icon: Iconsax.edit,
      );

      NotificationItems newNotification = NotificationItems(
        notificationImage: updatedBook.coverImage,
        notificationTitle: "${updatedBook.bookTitle} Book Updated",
        notificationMessage:
            'The book ${updatedBook.bookTitle} has been updated successfully. You can check it out now!',
        notificationDate:
            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
        notificationTime:
            "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
      );

      NotificationDropDownServices notificationId =
          NotificationDropDownServices();

      // 4. Call Service Provider and Log Activity
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      await bookProvider.updateBook(updatedBook);
      await Provider.of<NotificationProvider>(context, listen: false)
          .sendGeneralNotification(newNotification);
      NotificationDropDownServices.showNotification(
          id: notificationId.getNextId(),
          title: "${updatedBook.bookTitle} Book Updated",
          body:
              'The book ${updatedBook.bookTitle} has been updated successfully.');
      await Provider.of<AdminActivityService>(context, listen: false)
          .logActivity(
              newActivity.action, newActivity.details, newActivity.icon);
      showMessage('Book content updated successfully!', context);
      context.pop(); // Go back after successful submission
    } catch (e) {
      showMessage('An error occurred during save: ${e.toString()}', context);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Widget _buildChapterInput(int index) {
    if (index >= _chapterTitleControllers.length) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
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
          const SizedBox(width: 10),
          // Chapter Title Input
          Expanded(
            child: CustomTextInput(
              isIcon: false,
              controller: _chapterTitleControllers[index],
              label: 'Chapter Title / Topic',
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
  void dispose() {
    // Dispose all controllers to free resources
    _titleController.dispose();
    _authorController.dispose();
    _amountController.dispose();
    _aboutBookController.dispose();
    _aboutAuthorController.dispose();
    for (var controller in _chapterTitleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // NEW: Widget to display the currently selected image
  Widget _buildCoverImageDisplay(BuildContext context) {
    final theme = Theme.of(context);

    Widget imageWidget;

    if (_bookImage != null) {
      // **FIX HERE:** Use Image.file() for the temporary path from ImagePicker
      imageWidget = Image.file(
        File(_bookImage!.path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.broken_image, size: 50));
        },
      );
    } else if (widget.aboutBooks.coverImage.isNotEmpty) {
      if (widget.aboutBooks.coverImage.startsWith('assets/')) {
        imageWidget =
            Image.asset(widget.aboutBooks.coverImage, fit: BoxFit.cover);
      } else {
        imageWidget = Image.network(
          widget.aboutBooks.coverImage,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.danger,
                      size: 40, color: theme.colorScheme.error),
                  const Text('Error loading image URL'),
                ],
              ),
            );
          },
        );
      }
    } else {
      imageWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.image, size: 40, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          const Text('No image set'),
        ],
      );
    }

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias, // Clip the image to the rounded border
      child: imageWidget,
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
          'Editing Book: ${widget.aboutBooks.bookTitle}',
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
              const Text(
                'Book Cover Image',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              _buildCoverImageDisplay(context),
              const SizedBox(height: 10),
              // --- 1. File Update Options (Optional) ---
              const SectionTitle(title: 'Update Cover Image / File (Optional)'),
              _buildFilePicker(
                context,
                title: 'Current Cover: ${widget.aboutBooks.coverImage}',
                file: _bookImage?.name ?? 'Tap to select new image',
                onPressed: _pickCoverImage,
                icon: Iconsax.image,
              ),
              const SizedBox(height: 10),
              _buildFilePicker(
                context,
                title: 'Current PDF: ${widget.aboutBooks.pdfLink}',
                file: _bookPdf?.name ?? 'Tap to select new PDF file',
                onPressed: _pickBookFile,
                icon: Iconsax.document_upload,
              ),
              // --- 2. Basic Book Details ---
              const SectionTitle(title: 'Basic Book Details'),
              CustomTextInput(
                controller: _titleController,
                label: 'Book Title',
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _authorController,
                label: 'Author Name',
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _amountController,
                label: '(#) Price (e.g., 1000.00)',
                isNumber: true,
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),

              // --- 3. About Book & Author ---
              const SectionTitle(title: 'Book Descriptions'),
              CustomTextInput(
                controller: _aboutBookController,
                label: 'About Book',
                maxLine: 27,
                maxLength: 5000,
                isIcon: false,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextInput(
                controller: _aboutAuthorController,
                label: 'About Author (Bio)',
                isIcon: false,
                maxLine: 15,
                maxLength: 2000,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),

              // --- 4. Book Chapters (Dynamic Sections) ---
              const SectionTitle(title: 'Book Chapters'),
              Row(
                children: [
                  const Text('Number of Chapters:',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
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
              const SizedBox(height: 10),

              // Dynamic Chapter TextFields
              ...List.generate(
                  _selectedChapterNum, (index) => _buildChapterInput(index)),
              const SizedBox(height: 30),

              // --- 5. Submit Button ---
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
                              child: LoadingAnimationWidget.halfTriangleDot(
                                  color: Colors.white, size: 20),
                            )
                          : const Icon(Iconsax.save_2, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        _isSaving ? 'Saving Changes...' : 'Save Book Content',
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
