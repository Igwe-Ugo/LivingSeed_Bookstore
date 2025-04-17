import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_bookstore/common/widget.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                          iconColor: WidgetStatePropertyAll(
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black),
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.45))),
                      onPressed: () => GoRouter.of(context)
                          .go(LivingSeedBookStoreRouter.landingPagePath),
                      label: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 18,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome!',
                    style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create an account with us to have access to our bookstore.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                          label: 'Fullname',
                          validator: () {},
                          controller: fullnameController,
                          icon: Icons.person_outline),
                      CustomTextInput(
                          label: 'Email',
                          validator: () {},
                          controller: emailController,
                          icon: Icons.email_outlined,
                          isEmail: true),
                      CustomTextInput(
                          label: 'Password',
                          validator: () {},
                          controller: passwordController,
                          icon: Iconsax.password_check,
                          maxLine: 1,
                          isPassword: true),
                      CustomTextInput(
                          label: 'Confirm Password',
                          validator: () {},
                          maxLine: 1,
                          controller: confirmPasswordController,
                          icon: Iconsax.password_check,
                          obscureText: _obscureText,
                          isPassword: true),
                      CustomTextInput(
                          label: 'Telephone',
                          validator: () {},
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
                          ? CircularProgressIndicator(color: Colors.white)
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
                        color: Theme.of(context).disabledColor,
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
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () => GoRouter.of(context)
                          .go(LivingSeedBookStoreRouter.signinPath),
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
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Select Gender:    ',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
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
        const Text('Male'),
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
        const Text('Female'),
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
        const Text('I agree to the Terms and Conditions'),
      ],
    );
  }

  void _signUpUser() async {
    RegExp regExp = RegExp(
        "^[a-zA-Z0-9.a-zA-Z0-9.!#%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!_formKey.currentState!.validate()) {
      return showMessage('Please fill all available input spaces', context);
    }
    if (passwordController.text != confirmPasswordController.text) {
      showMessage(
          'Password must be the same with your confirmed password', context);
      return;
    }
    if (!regExp.hasMatch(emailController.text)) {
      showMessage('Please put in a correct email Address', context);
      return;
    }
  }
}
