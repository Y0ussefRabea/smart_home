import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/UI/custom_widgets/elevated_button.dart';
import 'package:smart_home/UI/custom_widgets/text_button.dart';
import 'package:smart_home/services/auth_services.dart';
import 'package:smart_home/utils/app_colors.dart';
import 'package:smart_home/utils/app_routes.dart';
import 'package:smart_home/utils/app_styles.dart';

import '../custom_widgets/text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();

    /// to remove the value of the controller after closing or moving from the screen(for memory saving)
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,   ///to remove the arrow back
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'Create Account',
          style: AppStyles.bold14black.copyWith(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.03,
          horizontal: width * 0.06,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Join SmartHome',
                    style: AppStyles.bold30Black.copyWith(fontSize: 36),
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  'Start managing your devices in minutes.',
                  style: AppStyles.medium14Gray,
                ),
                SizedBox(height: height * 0.03),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Name', style: AppStyles.bold14black),
                ),
                CustomTextField(
                  controller: nameController,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please Enter your Name';
                    }
                    return null;
                  },
                  hintText: 'Enter Your Name',
                ),
                SizedBox(height: height * 0.02),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Email Address', style: AppStyles.bold14black),
                ),
                CustomTextField(
                  controller: emailController,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please Enter an Email'; //email is not valid
                    }
                    final bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(text);
                    if (!emailValid) {
                      return 'Please Enter a Valid Email';
                    }
                    return null;
                  },
                  hintText: 'name@example.com',
                ),
                SizedBox(height: height * 0.02),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password', style: AppStyles.bold14black),
                ),
                CustomTextField(
                  controller: passwordController,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please Enter Password';
                    }
                    if (text.length < 8) {
                      return 'Password Must Be At Least 8 Characters';
                    }
                    return null;
                  },
                  isPassword: true,
                  hintText: 'Create a Password',
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                SizedBox(height: height * 0.02),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Confirm Password', style: AppStyles.bold14black),
                ),
                CustomTextField(
                  controller: confirmPasswordController,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please Repeat the Password';
                    }
                    if (text != passwordController.text) {
                      return 'Passwords Do Not Match';
                    }
                    return null;
                  },
                  isPassword: true,
                  hintText: 'Repeat Your Password',
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                SizedBox(height: height * 0.04),
                CustomElevatedButton(
                  text: 'Sign Up',
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      await register();
                    }
                  },
                ),
                SizedBox(height: height * 0.02),

                Wrap(         ///todo:auto line break
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: AppStyles.medium14Gray,
                    ),
                    CustomTextButton(
                      text: 'Log In',
                      alignment: Alignment.center,
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.loginRouteName);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    try {
      await authService.value.createAccount(
        email: emailController.text,
        password: passwordController.text,
      );
      await FirebaseAuth.instance.currentUser!.updateDisplayName(nameController.text);
      await FirebaseAuth.instance.currentUser!.reload();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.loginRouteName);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = 'Registration failed';
      if (e.code == 'email-already-in-use') {
        message = 'This email is already in use. Try logging in instead.';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak. Use at least 8 characters.';
      } else {
        message = e.message ?? message;
      }
      showErrorBanner(message);
    } catch (_) {
      if (!mounted) return;
      showErrorBanner('Something went wrong. Please try again.');
    }
  }

  void showErrorBanner(String message) {
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsets.all(12),
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('DISMISS', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
