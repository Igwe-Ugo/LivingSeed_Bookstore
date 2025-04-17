import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_bookstore/common/widget.dart';
import 'package:livingseed_bookstore/services/widget.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final bool _obscureText = true;
  final bool _obscureText2 = true;
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  void _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all available input spaces', context);
    } else if (_newPasswordController.text !=
        _confirmNewPasswordController.text) {
      return showMessage(
          'New Password must be matched with confirmed password', context);
    }

    bool success = await Provider.of<UsersAuthProvider>(context, listen: false)
        .changePassword(
            _newPasswordController.text, _oldPasswordController.text);
    if (success) {
      showMessage('Change of password was successful!', context);
      GoRouter.of(context).pop();
    } else {
      showMessage('Old password does not match with database!', context);
      return;
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
          'Change Password',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () => _changePassword,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(10, 50),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Center(
                child: Text('Change Password',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17.0,
                        color: Colors.white))),
          ),
        )
      ],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set the new password for your account so that you can access all features.',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(0.45),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    children: [
                      CustomTextInput(
                          label: 'Old password',
                          controller: _oldPasswordController,
                          icon: Iconsax.password_check,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your old password';
                            }
                            return null;
                          },
                          obscureText: _obscureText,
                          maxLine: 1,
                          isPassword: true),
                      CustomTextInput(
                          label: 'New password',
                          controller: _newPasswordController,
                          icon: Iconsax.password_check,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            if (value.length < 4) {
                              return 'Password must be at least 4 characters long';
                            }
                            return null;
                          },
                          obscureText: _obscureText2,
                          maxLine: 1,
                          isPassword: true),
                      CustomTextInput(
                          label: 'Confirm password',
                          controller: _confirmNewPasswordController,
                          icon: Iconsax.password_check,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your new password';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          obscureText: _obscureText2,
                          maxLine: 1,
                          isPassword: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
