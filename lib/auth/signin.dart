// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../common/widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final bool _obscureText = true;
  final loginFormField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

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
                key: loginFormField,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
                            style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                minimumSize:
                                    WidgetStatePropertyAll(Size(7, 50)),
                                elevation: WidgetStatePropertyAll(0.0),
                                iconColor: WidgetStatePropertyAll(Colors.black),
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.white)),
                            onPressed: () => GoRouter.of(context)
                                .go(LivingSeedMediaRouter.landingPagePath),
                            label: Icon(
                              Icons.arrow_back_ios_outlined,
                              size: 18,
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign In',
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
                          'Please fill up your email address and password to log in to your account',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.95),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
                                controller: emailController,
                                icon: Icons.email_outlined,
                                textColor: Colors.black,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please input user's email address";
                                  }
                                  return null;
                                },
                                isEmail: true),
                            CustomTextInput(
                                label: 'Password',
                                controller: passwordController,
                                icon: Iconsax.password_check,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please add user's password";
                                  }
                                  return null;
                                },
                                textColor: Colors.black,
                                obscureText: _obscureText,
                                maxLine: 1,
                                isPassword: true),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => GoRouter.of(context)
                              .go(LivingSeedMediaRouter.forgotPasswordPath),
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          RegExp regExp = RegExp(
                              "^[a-zA-Z0-9.a-zA-Z0-9.!#%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (!regExp.hasMatch(emailController.text)) {
                            showMessage('Please put in a correct email Address',
                                context);
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }
                          Users? authenticatedUser =
                              await Provider.of<UsersAuthProvider>(context,
                                      listen: false)
                                  .signIn(emailController.text,
                                      passwordController.text);
                          if (authenticatedUser != null) {
                            GoRouter.of(context)
                                .go(LivingSeedMediaRouter.homePath);
                          } else {
                            setState(() {
                              errorMessage = 'Invalid EmailAddress or password';
                              showMessage(errorMessage, context);
                            });
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
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
                                    'Sign In',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontFamily: 'Playfair'),
                                  )
                                : LoadingAnimationWidget.halfTriangleDot(
                                    color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Theme.of(context).dividerColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(10, 50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/icons/devicon_google.svg'),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Google',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0,
                                    color: Theme.of(context).primaryColorDark),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                            onPressed: () => GoRouter.of(context)
                                .go(LivingSeedMediaRouter.signupPath),
                            child: Text('Sign up',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
}
