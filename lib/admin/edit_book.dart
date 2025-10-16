import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';

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

  int selectedChapterNum = 1;
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

  @override
  Widget build(BuildContext context) {
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
                  TextButton(
                      onPressed: () => _pickProfileImage(),
                      child: Text(
                        'Change Book Image',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                  const SizedBox(height: 30),
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
                              widget.aboutBooks.bookTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 17),
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
                              widget.aboutBooks.author,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 17),
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
                              '₦ ${widget.aboutBooks.amount.toStringAsFixed(1)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 17),
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
                              widget.aboutBooks.aboutBook,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 14),
                              textAlign: TextAlign.justify,
                            ),
                      Text(
                        'Have ${widget.aboutBooks.chapterNum} Chapters',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                            NeverScrollableScrollPhysics(), // Prevents scrolling conflicts
                        itemCount: widget.aboutBooks.chapters
                            .length, // Loops through list of maps
                        itemBuilder: (context, index) {
                          Map<String, String> chapterMap =
                              widget.aboutBooks.chapters[index]; // Get Map

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: chapterMap.entries.map((entry) {
                              return CustomTextInput(
                                  isTitleNotNecessary: true,
                                  label: "${entry.key}: ${entry.value}",
                                  showEnter: false,
                                  isIcon: false,
                                  controller: _editBookTitleController,
                                  validator: () {});
                            }).toList(),
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
                              widget.aboutBooks.aboutAuthor,
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
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Iconsax.edit_2, color: Colors.white),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Edit book content',
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
