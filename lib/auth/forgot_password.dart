// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../common/widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final bool _obscureText = true;
  final loginFormField = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmrPasswordController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: ElevatedButton(
            onPressed: () async {},
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(10, 50),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                child: isLoading == false
                    ? Text(
                        'Save',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      )
                    : LoadingAnimationWidget.halfTriangleDot(
                        color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: loginFormField,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => GoRouter.of(context)
                          .go(LivingSeedBookStoreRouter.signinPath),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.45),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: Icon(
                            Iconsax.arrow_left_2,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Set a new password for your account so that you can access all the features.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.45),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        children: [
                          CustomTextInput(
                              label: 'New password',
                              controller: newPasswordController,
                              icon: Iconsax.password_check,
                              validator: () {},
                              obscureText: _obscureText,
                              maxLine: 1,
                              isPassword: true),
                          CustomTextInput(
                              label: 'Confirm password',
                              controller: confirmrPasswordController,
                              icon: Iconsax.password_check,
                              validator: () {},
                              obscureText: _obscureText,
                              maxLine: 1,
                              isPassword: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
