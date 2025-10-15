import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';

class EditBibleStudy extends StatefulWidget {
  final BibleStudyMaterial bibleStudy;
  const EditBibleStudy({super.key, required this.bibleStudy});

  @override
  State<EditBibleStudy> createState() => _EditBibleStudyState();
}

class _EditBibleStudyState extends State<EditBibleStudy> {
  int selectedChapterNum = 1;
  final TextEditingController _editBookTitleController =
      TextEditingController();
  final TextEditingController _editBookAuthorController =
      TextEditingController();
  final TextEditingController _editBookAmountController =
      TextEditingController();

  XFile? _biblestudyImage;

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _biblestudyImage = pickedImage;
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
            'Edit Bible Study',
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
                            image: AssetImage(widget.bibleStudy.coverImage),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () => _pickProfileImage(),
                      child: Text(
                        'Change Bible Study Image',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Edit Bible Study Title",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      CustomTextInput(
                          isTitleNotNecessary: true,
                          showEnter: false,
                          label: widget.bibleStudy.title,
                          controller: _editBookTitleController,
                          icon: Icons.title,
                          validator: () {}),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("Edit Bible Study subtitle",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      CustomTextInput(
                          isTitleNotNecessary: true,
                          label: widget.bibleStudy.subTitle,
                          showEnter: false,
                          controller: _editBookAuthorController,
                          icon: Icons.title,
                          validator: () {}),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("Edit Bible Study Amount",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      CustomTextInput(
                        isNumber: true,
                        showEnter: false,
                        isIcon: false,
                        label: '₦ ${widget.bibleStudy.amount.toString()}',
                        controller: _editBookAmountController,
                        isTitleNotNecessary: true,
                        maxLine: 1,
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
                                  'Edit Bible Study content',
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
