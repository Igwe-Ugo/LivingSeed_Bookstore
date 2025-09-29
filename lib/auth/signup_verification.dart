// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart'; // Assuming showMessage is here
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class SignupVerification extends StatefulWidget {
  final String fullname;
  final String email;

  const SignupVerification({
    super.key,
    required this.email,
    required this.fullname,
  });

  @override
  State<SignupVerification> createState() => _SignupVerificationState();
}

class _SignupVerificationState extends State<SignupVerification> {
  // Use a simple string to store the final 6-digit code submitted by OtpTextField
  String _enteredOtpCode = '';
  //final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Note: TextEditingController is no longer strictly needed for validation
  // if we rely entirely on the onSubmit callback, but we use _enteredOtpCode.

  /* void _verifyOtpAndAuthenticate() async {
    if (_enteredOtpCode.length != 6) {
      // Manual check since OtpTextField doesn't integrate with GlobalKey<FormState> easily
      showMessage('Please enter the full 6-digit code.', context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 1. --- OTP Verification ---
      
      // In a real application, replace the placeholder check with your backend call:
      // bool isCodeValid = await Provider.of<Auth>(context, listen: false).verifyOtp(widget.email, _enteredOtpCode);
      bool isCodeValid = _enteredOtpCode == '123456' || _enteredOtpCode == widget.codeSent; // Placeholder

      if (!isCodeValid) {
        showMessage('Invalid verification code. Please try again.', context);
        return;
      }

      // 2. --- Final Login (SmartAuth + Backend Login) ---
      
      // Perform the final sign-in via your backend service
      await Provider.of<Auth>(context, listen: false).signInUser(
        email: widget.email,
        password: widget.password,
      );

      // 3. --- SmartAuth Credential Saving ---
      // After successful authentication, use SmartAuth to save the credentials.
      final credential = SmartAuthCredential(
        email: widget.email,
        password: widget.password,
      );
      
      final smartAuthResult = await SmartAuth().signOn(credential: credential);

      if (smartAuthResult.success) {
        debugPrint('SmartAuth: Credentials successfully saved.');
      } else {
        debugPrint('SmartAuth: User declined to save credentials or failed. Error: ${smartAuthResult.error}');
      }
      
      // 4. Navigation
      showMessage('Verification successful! You are now logged in.', context);
      GoRouter.of(context).go('/'); // Navigate to the home screen
      
    } catch (e) {
      showMessage('Authentication failed: ${e.toString()}', context);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  } */

  // Helper widget using the requested OtpTextField
  Widget _buildOtpInput() {
    return OtpTextField(
      numberOfFields: 6, // Changed to 6 as it's standard for OTP
      borderColor: Theme.of(context).primaryColor, // Use theme color
      showFieldAsBox: true,
      fieldWidth: 40, // Set a standard width for better alignment
      // Use InputDecoration to style the boxes nicely
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      // Runs when a code is typed in (optional, mainly for continuous state tracking)
      onCodeChanged: (String code) {
        // Can be used to update a state variable if needed
      },
      // Runs when every text field is filled. This is what we use for the final code.
      onSubmit: (String verificationCode) {
        setState(() {
          _enteredOtpCode = verificationCode; // Store the 6-digit code
        });
        // Removed the showDialog logic as the main button press handles verification
      }, // end onSubmit
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // Form is not strictly needed since OtpTextField doesn't use it
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            Theme.of(context).dividerColor.withOpacity(0.45))),
                    onPressed: () => GoRouter.of(context)
                        .go(LivingSeedMediaRouter.landingPagePath),
                    label: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 18,
                    )),
              ),
              SizedBox(
                height: 70,
              ),
              const Icon(Iconsax.security_user,
                  size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              Text(
                'User Verification',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Playfair',
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                ' ${widget.fullname} is trying to verify account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Enter the 6-digit code sent to ${widget.email}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 70),
              _buildOtpInput(),
              const SizedBox(height: 70),
              ElevatedButton.icon(
                // Use _enteredOtpCode length check to enable/disable button
                onPressed:
                    null, //isLoading || _enteredOtpCode.length != 6 ? null : _verifyOtpAndAuthenticate,
                icon: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Icon(Iconsax.verify, color: Colors.white),
                label: Text(
                  isLoading ? 'Verifying...' : 'Verify & Complete Sign Up',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        // Logic to resend the code (calls the Auth service again)
                        showMessage(
                            'Resending code to ${widget.email}...', context);
                      },
                child: const Text('Resend Code'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.18),
            ],
          ),
        ),
      ),
    );
  }
}
