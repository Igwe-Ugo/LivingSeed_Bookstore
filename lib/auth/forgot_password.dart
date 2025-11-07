import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emaillAddressController = TextEditingController();
  final forgotPasswordKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    emaillAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/crop_germinating.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: forgotPasswordKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => GoRouter.of(context)
                            .go(LivingSeedRouter.signinPath),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            child: Icon(
                              Iconsax.arrow_left_2,
                              size: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Recover Account',
                          style: TextStyle(
                              fontFamily: 'Playfair',
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Recover account password so that you can access all the features.\n\nInput the email address you know is already registered with us. The email address will receive an OTP code',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
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
                            color: Colors.white.withOpacity(0.95),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        child: Column(
                          children: [
                            CustomTextInput(
                              label: 'Email Address',
                              controller: emaillAddressController,
                              icon: Icons.email_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please provide user's email address";
                                }
                                return null;
                              },
                              isEmail: true,
                              textColor: Colors.black,
                              maxLine: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ElevatedButton(
                          onPressed: () => _recoverAccountPassword(),
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
                                      'Send OTP',
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _recoverAccountPassword() {
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");

    if (!forgotPasswordKey.currentState!.validate()) {
      return showMessage('Please fill the email required field', context);
    }
    if (!emailRegExp.hasMatch(emaillAddressController.text)) {
      return showMessage('Please put in a correct email Address', context);
    }
    setState(() {
      isLoading = true;
    });
    GoRouter.of(context).go(
        "${LivingSeedRouter.forgotPasswordPath}/${LivingSeedRouter.forgotPasswordVerificationPath}",
        extra: {
          'email': emaillAddressController.text,
        });
    setState(() {
      isLoading = false;
    });
  }
}
