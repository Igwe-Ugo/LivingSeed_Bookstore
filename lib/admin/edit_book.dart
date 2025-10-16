import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:provider/provider.dart'; // REQUIRED: Import provider
import 'package:livingseed_media/services/books_services.dart'; // Assuming the BookProvider is here

class EditBook extends StatefulWidget {
  final AboutBooks aboutBooks;
  const EditBook({super.key, required this.aboutBooks});

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  bool _showTitleInput = false;
  bool _showAuthorInput = false;
  bool _showAmountInput = false;
  bool _showAboutInput = false;
  bool _showWhoseInput = false;
  
  bool _isSaving = false; // State for loading indicator

  final TextEditingController _editBookTitleController =
      TextEditingController();
  final TextEditingController _editBookAuthorController =
      TextEditingController();
  final TextEditingController _editBookAmountController =
      TextEditingController();
  final TextEditingController _editAboutBookController =
      TextEditingController();
  final TextEditingController _editWhoAuthorController =
      TextEditingController();

  XFile? _bookImage;
  PlatformFile? _bookPdf;

  late List<MapEntry<String, String>> _chapterEntries;
  late List<TextEditingController> _chapterControllers;
  late List<bool> _isChapterEditing;
  // ----------------------------------------

  @override
  void initState() {
    super.initState();
    _editBookTitleController.text = widget.aboutBooks.bookTitle;
    _editBookAuthorController.text = widget.aboutBooks.author;
    _editBookAmountController.text = widget.aboutBooks.amount.toString();
    _editAboutBookController.text = widget.aboutBooks.aboutBook;
    _editWhoAuthorController.text = widget.aboutBooks.aboutAuthor;

    _chapterEntries = widget.aboutBooks.chapters.isNotEmpty
        ? widget.aboutBooks.chapters.first.entries.toList()
        : [];
    
    final int chapterCount = _chapterEntries.length;

    // 3. Initialize chapter-specific state
    _chapterControllers = List.generate(chapterCount, (index) {
      String chapterTitle = _chapterEntries[index].value;
      return TextEditingController(text: chapterTitle);
    });

    _isChapterEditing = List.generate(chapterCount, (_) => false);
  }

  @override
  void dispose() {
    _editBookTitleController.dispose();
    _editBookAuthorController.dispose();
    _editBookAmountController.dispose();
    _editAboutBookController.dispose();
    _editWhoAuthorController.dispose();

    for (var controller in _chapterControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _bookImage = pickedImage;
      });
    }
  }

  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _bookPdf = result.files.first;
      });
    }
  }
  
  void _deleteChapter(int index) {
    _chapterControllers[index].dispose();

    setState(() {
      _chapterEntries.removeAt(index);
      _chapterControllers.removeAt(index);
      _isChapterEditing.removeAt(index);
    });
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return; // Prevent double click

    setState(() {
      _isSaving = true;
    });

    // 1. Reconstruct the chapters Map<String, String>
    // The keys (_chapterEntries.map((e) => e.key)) hold the 'chapter 1', 'chapter 2', etc.
    // The values (_chapterControllers.map((c) => c.text)) hold the edited titles.
    Map<String, String> updatedChapterMap = Map.fromIterables(
      _chapterEntries.map((e) => e.key),
      _chapterControllers.map((c) => c.text),
    );

    // 2. Create the final List<Map<String, String>> structure
    List<Map<String, String>> updatedChaptersList = [updatedChapterMap];

    // 3. Create the new AboutBooks object using the current (edited or original) values
    final updatedBook = AboutBooks(
      bookId: widget.aboutBooks.bookId,
      bookTitle: _editBookTitleController.text,
      author: _editBookAuthorController.text,
      aboutBook: _editAboutBookController.text,
      aboutAuthor: _editWhoAuthorController.text,    
      amount: double.tryParse(_editBookAmountController.text) ?? widget.aboutBooks.amount.toDouble(),
      ratingReviews: widget.aboutBooks.ratingReviews, 
      coverImage: _bookImage?.path ?? widget.aboutBooks.coverImage,
      pdfLink: _bookPdf?.name ?? widget.aboutBooks.pdfLink,
      chapters: updatedChaptersList,
      chapterNum: updatedChapterMap.length,
    );

    try {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      await bookProvider.updateBook(updatedBook);
      showMessage('Success updating book', context);
      GoRouter.of(context).pop(); 
    } catch (e) {
      showMessage('Error updating book: $e', context);
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logic for dynamic PDF status display
    String pdfStatusText;
    IconData pdfIcon;
    Color pdfIconColor;

    if (_bookPdf != null) {
      pdfStatusText = 'New PDF Selected: ${_bookPdf!.name}';
      pdfIcon = Iconsax.document_upload;
      pdfIconColor = Colors.green;
    } else {
      pdfStatusText =
          'Current PDF: ${widget.aboutBooks.pdfLink.split('/').last}';
      pdfIcon = Iconsax.document_1;
      pdfIconColor = Theme.of(context).primaryColor;
    }

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
            'Edit Book',
            style: TextStyle(
              fontFamily: 'Playfair',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 130,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(widget.aboutBooks.coverImage),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: TextButton(
                        onPressed: () => _pickProfileImage(),
                        child: Text(
                          'Change Book Image',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )),
                  ),
                  const SizedBox(height: 30),

                  // --- Dynamic PDF Display Section ---
                  const Text("Book PDF File",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(pdfIcon, color: pdfIconColor),
                      title: Text(
                        pdfStatusText,
                        style: TextStyle(
                            fontWeight: _bookPdf != null
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: pdfIconColor,
                            fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: TextButton(
                        onPressed: _pickPdfFile,
                        child: Text(
                          _bookPdf != null ? 'Replace File' : 'Change File',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      onTap: _pickPdfFile,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // --- End Dynamic PDF Display Section ---

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Edit Book Title",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _showTitleInput = !_showTitleInput;
                              });
                            },
                            child: Icon(
                              Iconsax.edit_2,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      _showTitleInput == true
                          ? CustomTextInput(
                              isTitleNotNecessary: true,
                              showEnter: false,
                              label: widget.aboutBooks.bookTitle,
                              controller: _editBookTitleController,
                              icon: Icons.title,
                              validator: () {})
                          : Text(
                              _editBookTitleController.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 14),
                              textAlign: TextAlign.justify,
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Edit Book Author",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _showAuthorInput = !_showAuthorInput;
                              });
                            },
                            child: Icon(
                              Iconsax.edit_2,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      _showAuthorInput == true
                          ? CustomTextInput(
                              isTitleNotNecessary: true,
                              label: widget.aboutBooks.author,
                              showEnter: false,
                              controller: _editBookAuthorController,
                              icon: Icons.title,
                              validator: () {})
                          : Text(
                              _editBookAuthorController.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 14),
                              textAlign: TextAlign.justify,
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Edit Book Amount",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _showAmountInput = !_showAmountInput;
                              });
                            },
                            child: Icon(
                              Iconsax.edit_2,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      _showAmountInput == true
                          ? CustomTextInput(
                              isNumber: true,
                              showEnter: false,
                              isIcon: false,
                              label: '₦ ${widget.aboutBooks.amount.toString()}',
                              controller: _editBookAmountController,
                              isTitleNotNecessary: true,
                              maxLine: 1,
                              validator: () {},
                            )
                          : Text(
                              '₦ ${_editBookAmountController.text}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 14),
                              textAlign: TextAlign.justify,
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Edit What's it about?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _showAboutInput = !_showAboutInput;
                              });
                            },
                            child: Icon(
                              Iconsax.edit_2,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      _showAboutInput == true
                          ? CustomTextInput(
                              isIcon: false,
                              showEnter: false,
                              label: widget.aboutBooks.aboutBook,
                              controller: _editAboutBookController,
                              isTitleNotNecessary: true,
                              validator: () {},
                            )
                          : Text(
                              _editAboutBookController.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 14),
                              textAlign: TextAlign.justify,
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Have ${_chapterEntries.length} Chapters',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // --- CHAPTER EDITING/DELETING LOGIC ---
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _chapterEntries.length,
                        itemBuilder: (context, index) {
                          MapEntry<String, String> chapterEntry = _chapterEntries[index];
                          String chapterNumber = chapterEntry.key;
                          String currentTitle = _chapterControllers[index].text;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      chapterNumber,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Row(
                                      children: [
                                        // Delete Button
                                        InkWell(
                                          onTap: () => _deleteChapter(index),
                                          child: Icon(Iconsax.trash, size: 20, color: Colors.red),
                                        ),
                                        SizedBox(width: 15),
                                        // Edit Button
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _isChapterEditing[index] =
                                                  !_isChapterEditing[index];
                                            });
                                          },
                                          child: Icon(Iconsax.edit_2, size: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                _isChapterEditing[index]
                                    ? CustomTextInput(
                                        isTitleNotNecessary: true,
                                        label: chapterEntry.value, 
                                        showEnter: false,
                                        isIcon: false,
                                        controller: _chapterControllers[index],
                                        validator: () {},
                                      )
                                    : Text(
                                        currentTitle,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w100,
                                            fontSize: 14),
                                        textAlign: TextAlign.justify,
                                      ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Edit who is the author",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _showWhoseInput = !_showWhoseInput;
                              });
                            },
                            child: Icon(
                              Iconsax.edit_2,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      _showWhoseInput == true
                          ? CustomTextInput(
                              isIcon: false,
                              showEnter: false,
                              label: widget.aboutBooks.aboutAuthor,
                              controller: _editWhoAuthorController,
                              isTitleNotNecessary: true,
                              validator: () {},
                            )
                          : Text(
                              _editWhoAuthorController.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 14),
                              textAlign: TextAlign.justify,
                            ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            elevation: WidgetStatePropertyAll(0),
                            backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColor)),
                        onPressed: _saveChanges,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isSaving
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Icon(Iconsax.save_2, color: Colors.white),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  _isSaving ? 'Saving Changes...' : 'Save Book Content',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )));
  }
}
