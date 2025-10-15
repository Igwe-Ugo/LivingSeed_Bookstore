import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';

class EditJournal extends StatefulWidget {
  final JournalPost journals;
  const EditJournal({super.key, required this.journals});

  @override
  State<EditJournal> createState() => _EditJournalState();
}

class _EditJournalState extends State<EditJournal> {
  int selectedChapterNum = 1;
  final TextEditingController _editBookTitleController =
      TextEditingController();
  final TextEditingController _editBookAuthorController =
      TextEditingController();
  final TextEditingController _editAboutBookController =
      TextEditingController();

  XFile? _journalImage;

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _journalImage = pickedImage;
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
            'Edit Journal',
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
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(widget.journals.imageUrl),
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
                      const Text("Edit Journal Title",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      CustomTextInput(
                          isTitleNotNecessary: true,
                          showEnter: false,
                          label: widget.journals.title,
                          controller: _editBookTitleController,
                          icon: Icons.title,
                          validator: () {}),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("Edit Journal Author",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      CustomTextInput(
                          isTitleNotNecessary: true,
                          label: widget.journals.authorName,
                          showEnter: false,
                          controller: _editBookAuthorController,
                          icon: Icons.title,
                          validator: () {}),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("Edit Journal Writeup",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      CustomTextInput(
                        isIcon: false,
                        showEnter: false,
                        label: widget.journals.journalWriteup,
                        controller: _editAboutBookController,
                        isTitleNotNecessary: true,
                        validator: () {},
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
                                  'Edit journal content',
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
