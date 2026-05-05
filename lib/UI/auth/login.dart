import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/UI/custom_widgets/elevated_button.dart';
import 'package:smart_home/UI/custom_widgets/text_button.dart';
import 'package:smart_home/UI/custom_widgets/text_form_field.dart';
import 'package:smart_home/services/auth_services.dart';
import 'package:smart_home/utils/app_assets.dart';
import 'package:smart_home/utils/app_colors.dart';
import 'package:smart_home/utils/app_routes.dart';
import 'package:smart_home/utils/app_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.iceBlueColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.03,
                horizontal: width * 0.03,
              ),
              child: Container(

                padding: EdgeInsets.symmetric(
                  vertical: height * 0.05,
                  horizontal: width * 0.06,
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                width: width * 0.9,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.overLayImage, width: width * 0.2),
                      SizedBox(height: height * 0.02),
                      Text('Smart Home', style: AppStyles.bold30Black),
                      SizedBox(height: height * 0.01),
                      Text(
                        'Manage Your Living Space With Ease',
                        style: AppStyles.medium14Gray,
                      ),
                      SizedBox(height: height * 0.04),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email Address',
                          style: AppStyles.bold14black,
                        ),
                      ),
                      CustomTextField(
                        controller: emailController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please Enter an Email';
                          }
                          return null;
                        },
                        hintText: 'name@example.com',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.lightGrayColor,
                        ),
                      ),
                      SizedBox(height: height * 0.03),
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
                          return null;
                        },
                        isPassword: true,
                        hintText: 'Enter Your Password',
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.lightGrayColor,
                        ),
                        suffixIcon: Icon(Icons.visibility_off),
                      ),
                      CustomTextButton(
                        text: 'Forgot Password?',
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(AppRoutes.forgotPassRouteName);
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      CustomElevatedButton(
                        text: 'Log in',
                        onPressed: () async {
                          if (formKey.currentState?.validate() == true) {
                            await login();
                          }
                        },
                      ),
                      SizedBox(height: height * 0.04),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              indent: width * 0.02,
                              endIndent: width * 0.03,
                              color: AppColors.grayColor,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'New user?',
                              style: AppStyles.regular14Gray,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              indent: width * 0.03,
                              endIndent: width * 0.02,
                              color: AppColors.grayColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.04),
                      CustomElevatedButton(
                        text: 'Create Account',
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.registerRouteName);
                        },
                        shadow: false,
                        backgroundColor: AppColors.offWhiteColor,
                        foregroundColor: AppColors.primaryLight,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    try {
      await authService.value.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.of(context).pushReplacementNamed(AppRoutes.homeRouteName);
      if (!mounted) return;

      /// means that if the user exit from the page, break the code
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No account found';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect Password';
      } else if (e.code == 'invalid-credential') {
        message = 'Invalid email or password';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid Email';
      } else {
        message = e.message ?? 'Login failed';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearMaterialBanners();
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          padding: EdgeInsets.all(12),
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(message, style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: Text("DISMISS", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
    if (!mounted) return;
  }
}
