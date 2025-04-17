import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:livingseed_bookstore/models/widget.dart';
import 'package:livingseed_bookstore/services/widget.dart';
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

  void updateTextFields(int count) {
    setState(() {
      selectedChapterNum = count;
      _bookChapterController =
          List.generate(count, (index) => TextEditingController());
    });
  }

  XFile? _coverImage;
  PlatformFile? _bookFile;

  Future<void> _pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _coverImage = pickedImage;
      });
    }
  }

  Future<void> _pickBookFile() async {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _bookFile = result.files.first;
      });
    }
  }

  void _uploadBook() {
    if (_formKey.currentState!.validate() &&
        _coverImage != null &&
        _bookFile != null) {
      // Perform the upload logic here, e.g., send data to backend or Firebase
      _uploadBookToJson();
      _clearFields();
      // Clear the form
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
    _authorController.clear();
    _amountController.clear();
    _aboutAuthorController.clear();
    for (var controller in _bookChapterController) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                        icon: const Icon(
                          Iconsax.arrow_left_2,
                          size: 17,
                        )),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Upload Book',
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        elevation: WidgetStatePropertyAll(0),
                      ),
                      onPressed: _pickCoverImage,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: const [
                            Icon(
                              Iconsax.image,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              'Upload Cover Image',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (_coverImage != null)
                      Text(
                        'Image Selected',
                        style: TextStyle(color: Colors.green[700]),
                      )
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextInput(
                  label: 'Book Title',
                  controller: _titleController,
                  icon: Iconsax.book,
                  isTitleNotNecessary: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please write the book title';
                    }
                    return null;
                  },
                ),
                CustomTextInput(
                  label: 'Author of book...',
                  controller: _authorController,
                  icon: Icons.person,
                  isTitleNotNecessary: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please who is the author?';
                    }
                    return null;
                  },
                ),
                CustomTextInput(
                  label: 'Book Price ... (#)',
                  controller: _amountController,
                  icon: Iconsax.money,
                  isTitleNotNecessary: true,
                  isNumber: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please what is the price of the book?';
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
                          'How many chapters of book?... ${index + 1} Fields'),
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
                          label: 'Chapter ${index + 1} title',
                          controller: _bookChapterController[index],
                          icon: Iconsax.archive_book,
                          isTitleNotNecessary: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the number of chapters of the book';
                            }
                            return null;
                          },
                        );
                      }),
                ),
                CustomTextInput(
                  label: "What's it about...",
                  controller: _descriptionController,
                  isIcon: false,
                  maxLine: 10,
                  maxLength: 700,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please describe what the book is about!';
                    }
                    return null;
                  },
                ),
                CustomTextInput(
                  label: "About the author...",
                  controller: _aboutAuthorController,
                  isIcon: false,
                  maxLine: 10,
                  maxLength: 700,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please tell us about the author';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(elevation: WidgetStatePropertyAll(0)),
                      onPressed: _pickBookFile,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: const [
                            Icon(
                              Iconsax.document_1,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Upload Book File (PDF)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (_bookFile != null)
                      Text(
                        'File Selected',
                        style: TextStyle(color: Colors.green[700]),
                      )
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _uploadBook,
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
                          child: Text('Upload Book',
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

  void _uploadBookToJson() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all available input spaces', context);
    }

    List<Map<String, String>> chapters = [];

    for (int i = 0; i < _bookChapterController.length; i++) {
      String text = _bookChapterController[i].text.trim();
      if (text.isNotEmpty) {
        chapters.add({"chapter ${i + 1}": text});
      }
    }

    AboutBooks newUpload = AboutBooks(
        coverImage: _coverImage!.path.toString(),
        bookTitle: _titleController.text,
        author: _authorController.text,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        aboutAuthor: _aboutAuthorController.text,
        aboutBook: _descriptionController.text,
        chapterNum: _bookChapterController.length,
        pdfLink: _bookFile!.path.toString(),
        chapters: chapters,
        ratingReviews: []);

    bool success = await Provider.of<BookProvider>(context, listen: false)
        .uploadBook(newUpload);
    if (success) {
      showMessage('Book uploaded successfully!', context);
      GoRouter.of(context).pop();
    } else {
      showMessage('Book already exists, please upload a new book', context);
      return;
    }
  }
}
