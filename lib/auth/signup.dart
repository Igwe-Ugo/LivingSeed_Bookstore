import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final bool _obscureText = true;
  bool agreeToTerms = false;
  bool male = false;
  bool female = false;
  bool isLoading = false;
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final telephoneController = TextEditingController();

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    telephoneController.dispose();
    super.dispose();
  }

  void _signUpUser() async {
    // 1. --- Input Validation (All checks must pass before proceeding) ---
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");

    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all available input spaces', context);
    }
    if (passwordController.text != confirmPasswordController.text) {
      return showMessage(
          'Password must be the same as your confirmed password', context);
    }
    if (!emailRegExp.hasMatch(emailController.text)) {
      return showMessage('Please put in a correct email Address', context);
    }
    if (!agreeToTerms) {
      return showMessage(
          'You must agree to the Terms and Conditions to proceed.', context);
    }
    if (!male && !female) {
      return showMessage('Please select your gender', context);
    }

    setState(() {
      isLoading = true;
    });

    final Users newUser = Users(
      fullname: fullnameController.text,
      emailAddress: emailController.text,
      password: passwordController.text,
      telephone: telephoneController.text,
      userImage: 'assets/images/avatar.png',
      gender: male ? 'Male' : 'Female',
      dateOfBirth: '',
      role: 'Regular',
      cart: [],
      bookPurchased: [],
      transactionHistory: [],
    );

    try {
      // 2. --- Call Auth Service to Register User ---
      // NOTE: Using the 'signUp' function structure you provided
      final Map<String, dynamic> result =
          await Provider.of<UsersAuthProvider>(context, listen: false)
              .signUp(newUser: newUser);

      // 3. --- Handle Result and Navigate ---
      if (result['success'] == true) {
        showMessage('Account created. Please verify your email.', context);
        // NAVIGATE to OTP verification screen, passing ALL required data
        GoRouter.of(context).push(
            '${LivingSeedMediaRouter.signupPath}/${LivingSeedMediaRouter.signupVerificationPath}',
            extra: {
              'email': newUser.emailAddress,
              'fullname': newUser.fullname,
            });
      } else {
        showMessage(
            'Sign up failed: ${result['error'] ?? 'Unknown error'}', context);
      }
    } catch (e) {
      showMessage('Sign up failed: ${e.toString()}', context);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
            child: Form(
              key: _formKey,
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
                            minimumSize: WidgetStatePropertyAll(Size(7, 50)),
                            elevation: WidgetStatePropertyAll(0.0),
                            iconColor: WidgetStatePropertyAll(Colors.black),
                            backgroundColor: WidgetStatePropertyAll(
                                Colors.white.withOpacity(0.95))),
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
                      'Welcome!',
                      style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.95)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create an account with us to have access to our bookstore.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                            label: 'Fullname',
                            validator: () {},
                            textColor: Colors.black,
                            controller: fullnameController,
                            icon: Icons.person_outline),
                        CustomTextInput(
                            label: 'Email',
                            validator: () {},
                            textColor: Colors.black,
                            controller: emailController,
                            icon: Icons.email_outlined,
                            isEmail: true),
                        CustomTextInput(
                            label: 'Password',
                            validator: () {},
                            controller: passwordController,
                            icon: Iconsax.password_check,
                            maxLine: 1,
                            textColor: Colors.black,
                            isPassword: true),
                        CustomTextInput(
                            label: 'Confirm Password',
                            validator: () {},
                            maxLine: 1,
                            controller: confirmPasswordController,
                            icon: Iconsax.password_check,
                            obscureText: _obscureText,
                            textColor: Colors.black,
                            isPassword: true),
                        CustomTextInput(
                            label: 'Telephone',
                            validator: () {},
                            textColor: Colors.black,
                            controller: telephoneController,
                            icon: Icons.phone_android_outlined,
                            isPhone: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Gender Selection
                  _buildGenderSelection(),
                  const SizedBox(
                    height: 20,
                  ),
                  // Terms and Conditions
                  _buildTermsAndConditions(),

                  const SizedBox(height: 15),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: _signUpUser,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(10, 50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: isLoading
                            ? LoadingAnimationWidget.halfTriangleDot(
                                color: Colors.white, size: 20)
                            : const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
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
                          color: Colors.white.withOpacity(0.95),
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
                          SvgPicture.asset('assets/icons/devicon_google.svg'),
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
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                      TextButton(
                        onPressed: () => GoRouter.of(context)
                            .go(LivingSeedMediaRouter.signinPath),
                        child: Text('Sign In',
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
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Select Gender:    ',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white.withOpacity(0.95))),
        Checkbox(
          activeColor: Theme.of(context).primaryColor,
          value: male,
          onChanged: (value) {
            setState(() {
              male = value!;
              female = !value;
            });
          },
        ),
        Text(
          'Male',
          style: TextStyle(color: Colors.white.withOpacity(0.95)),
        ),
        Checkbox(
          activeColor: Theme.of(context).primaryColor,
          value: female,
          onChanged: (value) {
            setState(() {
              female = value!;
              male = !value;
            });
          },
        ),
        Text(
          'Female',
          style: TextStyle(color: Colors.white.withOpacity(0.95)),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(
          activeColor: Theme.of(context).primaryColor,
          value: agreeToTerms,
          onChanged: (value) {
            setState(() {
              agreeToTerms = value!;
            });
          },
        ),
        Text(
          'I agree to the Terms and Conditions',
          style: TextStyle(color: Colors.white.withOpacity(0.95)),
        ),
      ],
    );
  }
}
