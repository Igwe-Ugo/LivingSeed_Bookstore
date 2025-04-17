import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingseed_bookstore/models/widget.dart';
import 'package:livingseed_bookstore/services/widget.dart';
import 'package:provider/provider.dart';
import '../../common/widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  XFile? _profileImage;

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Users? user = Provider.of<UsersAuthProvider>(context).userData!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
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
                    'Profile',
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
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      child: _profileImage == null
                          ? Image.asset(user.userImage)
                          : Image.asset(_profileImage!.path.toString()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () => _pickProfileImage(),
                        child: Text(
                          'Change Profile Picture',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Divider(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profile Information',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              ListTile(
                onTap: () => showEditDetails(context, fullnameController,
                    fullname: true),
                title: Text(
                  'Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  user.fullname,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(Iconsax.arrow_right_34),
              ),
              const Divider(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personal Information',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              ListTile(
                onTap: () => showEditDetails(context, fullnameController,
                    emailAddress: true),
                title: Text(
                  'E-mail',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  user.emailAddress,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(Iconsax.arrow_right_34),
              ),
              ListTile(
                title: Text(
                  'Gender',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  user.gender,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                onTap: () => showEditDetails(context, fullnameController,
                    dateOfBirth: true),
                leading: Icon(Iconsax.calendar),
                title: Text(
                  'Date of Birth',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  user.dateOfBirth,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(Iconsax.arrow_right_34),
              ),
              const Divider(),
              const SizedBox(
                height: 16,
              ),
              Center(
                  child: TextButton(
                      onPressed: () => showDeleteDialog(context, user.fullname),
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showDeleteDialog(BuildContext context, String fullname) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text(
        'Delete Account?',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      content: const SizedBox(
        height: 40,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Are you sure you want to delete your account with us?',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Provider.of<UsersAuthProvider>(context, listen: false)
                .deleteUser(fullname);
            Navigator.of(context).pop();
            GoRouter.of(context).go(LivingSeedBookStoreRouter.signupPath);
            showMessage('Account has been deleted!', context);
          },
          child: Text(
            'delete account'.toUpperCase(),
            style: const TextStyle(fontSize: 13, color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'not yet'.toUpperCase(),
            style:
                TextStyle(fontSize: 13, color: Theme.of(context).disabledColor),
          ),
        ),
      ],
    ),
  );
}

Future<void> showEditDetails(
    BuildContext context, TextEditingController controller,
    {bool fullname = false,
    bool emailAddress = false,
    bool dateOfBirth = false}) {
  DateTime selectedDateOfBirth = DateTime.utc(1999, 7, 20);

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) => SimpleDialog(
          title: Text(
            fullname
                ? 'Edit Fullname'
                : emailAddress
                    ? 'Edit Email Address'
                    : 'Edit Date of Birth',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          titlePadding: EdgeInsets.fromLTRB(15, 20, 15, 0),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          children: [
            fullname || emailAddress
                ? CustomTextInput(
                    label: fullname ? 'Fullname' : 'Email Address',
                    controller: controller,
                    isEmail: emailAddress,
                    icon:
                        fullname ? Icons.person_outline : Icons.email_outlined,
                  )
                : ListTile(
                    title: Text(
                      "Date: ${selectedDateOfBirth.toLocal().day}-${selectedDateOfBirth.toLocal().month}-${selectedDateOfBirth.toLocal().year}",
                    ),
                    trailing: const Icon(Iconsax.calendar),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDateOfBirth,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() => selectedDateOfBirth = picked);
                      }
                    },
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (fullname) {
                      Provider.of<UsersAuthProvider>(context, listen: false)
                          .changeFullname(controller.text);
                      showMessage('Fullname has been edited!', context);
                    } else if (emailAddress) {
                      Provider.of<UsersAuthProvider>(context, listen: false)
                          .changeEmail(controller.text);
                      showMessage('Email Address has been edited!', context);
                    } else {
                      Provider.of<UsersAuthProvider>(context, listen: false)
                          .changeDateOfBirth(
                              selectedDateOfBirth.toIso8601String());
                      showMessage('Date of Birth has been edited!', context);
                    }
                  },
                  child: Text(
                    'Apply Change'.toUpperCase(),
                    style: TextStyle(
                        fontSize: 13, color: Theme.of(context).primaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel'.toUpperCase(),
                    style: TextStyle(
                        fontSize: 13, color: Theme.of(context).disabledColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
