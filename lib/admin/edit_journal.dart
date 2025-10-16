import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';

class EditJournal extends StatefulWidget {
  final JournalPost journals;
  const EditJournal({super.key, required this.journals});

  @override
  State<EditJournal> createState() => _EditJournalState();
}

class _EditJournalState extends State<EditJournal> {
  bool _showTitleInput = false;
  bool _showAuthorInput = false;
  bool _showArticleInput = false;

  String? selectedValue;
  void setSelectedValue(String? value) {
    setState(() => selectedValue = value);
    debugPrint(value);
  }

  List<String> titleChoices = [
    'Gleanings',
    'Review',
    'More Than Rubies',
    'Dear Disciples',
    'Practical Discipleship',
    'Living Ready',
  ];

  int selectedChapterNum = 1;
  final TextEditingController _editJournalTitleController =
      TextEditingController();
  final TextEditingController _editJournalAuthorController =
      TextEditingController();
  final TextEditingController _editArticleController = TextEditingController();

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

  JournalCategory _categoryFromString(String? s) {
    if (s == null || s.isEmpty) {
      // fallback to a default category (first one)
      return JournalCategory.values.first;
    }
    final normalized = s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return JournalCategory.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '') == normalized,
        orElse: () => JournalCategory.values.first);
  }

  void _saveChanges() async {
    if (_journalImage == null) {
      return showMessage('Please select a cover image', context);
    }

    final category = _categoryFromString(selectedValue);

    JournalPost newArticle = JournalPost(
        title: _editJournalTitleController.text,
        authorName: _editJournalAuthorController.text,
        imageUrl: _journalImage!.path.isNotEmpty
            ? _journalImage!.path
            : _journalImage!.name,
        date: DateTime.now(),
        category: category,
        journalWriteup: _editArticleController.text,
        comments: []);

    await Provider.of<JournalProvider>(context, listen: false)
        .updateJournal(newArticle);

    showMessage('Article uploaded successfully!', context);
    GoRouter.of(context).pop();
  }

  @override
  void initState(){
    super.initState();
    _editJournalTitleController.text = widget.journals.title;
    _editJournalAuthorController.text = widget.journals.authorName;
    _editArticleController.text = widget.journals.journalWriteup;
  }

  @override
  void dispose() {
    _editJournalTitleController.dispose();
    _editJournalAuthorController.dispose();
    _editArticleController.dispose();
    super.dispose();
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
                        'Change Journal Image',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Edit Journal Title",
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
                              _showTitleInput == false
                                  ? Iconsax.edit_2
                                  : Icons.cancel_rounded,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      _showTitleInput == true
                          ? CustomTextInput(
                              isTitleNotNecessary: true,
                              showEnter: false,
                              label: widget.journals.title,
                              controller: _editJournalTitleController,
                              icon: Icons.title,
                              validator: () {})
                          : Text(
                              widget.journals.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 14),
                              textAlign: TextAlign.justify,
                            ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Edit Journal Author",
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
                              _showAuthorInput == false
                                  ? Iconsax.edit_2
                                  : Icons.cancel_rounded,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      _showAuthorInput == true
                          ? CustomTextInput(
                              isTitleNotNecessary: true,
                              label: widget.journals.authorName,
                              showEnter: false,
                              controller: _editJournalAuthorController,
                              icon: Icons.title,
                              validator: () {})
                          : Text(
                              widget.journals.authorName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 14),
                              textAlign: TextAlign.justify,
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Select Journal Category",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      InlineChoice<String>.single(
                        clearable: true,
                        value: selectedValue,
                        onChanged: setSelectedValue,
                        itemCount: titleChoices.length,
                        itemBuilder: (state, i) {
                          return ChoiceChip(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.7)),
                            selected: state.selected(titleChoices[i]),
                            onSelected: state.onSelected(titleChoices[i]),
                            label: Text(
                              titleChoices[i],
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          );
                        },
                        listBuilder: ChoiceList.createWrapped(
                          spacing: 5,
                          runSpacing: 5,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 10,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Edit Journal Writeup",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _showArticleInput = !_showArticleInput;
                              });
                            },
                            child: Icon(
                              _showArticleInput == false
                                  ? Iconsax.edit_2
                                  : Icons.cancel_rounded,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      _showArticleInput == true
                          ? CustomTextInput(
                              isIcon: false,
                              showEnter: false,
                              label: widget.journals.journalWriteup,
                              controller: _editArticleController,
                              isTitleNotNecessary: true,
                              validator: () {},
                            )
                          : Text(
                              widget.journals.journalWriteup,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 14),
                              textAlign: TextAlign.justify,
                            ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStatePropertyAll(0),
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).primaryColor)),
                        onPressed: () => _saveChanges,
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
