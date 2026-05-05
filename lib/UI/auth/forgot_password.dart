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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool emailSent = false;

  static bool _looksLikeEmail(String value) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim());
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FB),
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
                child: emailSent ? buildSentView(height) : buildFormView(height, width),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFormView(double height, double width) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppAssets.overLayImage, width: width * 0.2),
          SizedBox(height: height * 0.02),
          Text('Forgot Password', style: AppStyles.bold30Black),
          SizedBox(height: height * 0.01),
          Text(
            'Enter your email and we will send you a link to reset your password.',
            textAlign: TextAlign.center,
            style: AppStyles.medium14Gray,
          ),
          SizedBox(height: height * 0.04),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Email Address', style: AppStyles.bold14black),
          ),
          CustomTextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (text) {
              if (text == null || text.trim().isEmpty) {
                return 'Please Enter an Email';
              }
              if (!_looksLikeEmail(text)) {
                return 'Please Enter a valid Email';
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
          isLoading
              ? SizedBox(
            height: height * 0.075,
            child: const Center(child: CircularProgressIndicator()),
          )
              : CustomElevatedButton(
            text: 'Send reset link',
            onPressed: () async {
              if (formKey.currentState?.validate() != true) return;
              await sendResetEmail();
            },
          ),
          SizedBox(height: height * 0.02),
          CustomTextButton(
            text: 'Back to Log in',
            alignment: Alignment.center,
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.loginRouteName);
            },
          ),
        ],
      ),
    );
  }

  Widget buildSentView(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.mark_email_read_outlined, size: height * 0.08, color: AppColors.primaryLight),
        SizedBox(height: height * 0.02),
        Text('Check your email', style: AppStyles.bold30Black.copyWith(fontSize: 22)),
        SizedBox(height: height * 0.01),
        Text(
          'We sent a password reset link to\n${emailController.text.trim()}',
          textAlign: TextAlign.center,
          style: AppStyles.medium14Gray,
        ),
        SizedBox(height: height * 0.01),
        Text(
          'Open the email and tap the link to choose a new password.',
          textAlign: TextAlign.center,
          style: AppStyles.regular14Gray,
        ),
        SizedBox(height: height * 0.04),
        isLoading
            ? SizedBox(
          height: height * 0.075,
          child: const Center(child: CircularProgressIndicator()),
        )
            : CustomElevatedButton(
          text: 'Resend email',
          onPressed: () async {
            await sendResetEmail();
          },
        ),
        SizedBox(height: height * 0.02),
        CustomTextButton(
          text: 'Back to Log in',
          alignment: Alignment.center,
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.loginRouteName);
          },
        ),
      ],
    );
  }

  Future<void> sendResetEmail() async {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    setState(() {
      isLoading = true;
    });
    try {
      await authService.value.resetPassword(email: emailController.text.trim());
      if (!mounted) return;
      setState(() {
        emailSent = true;
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = 'Could not send reset email';
      if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      } else if (e.code == 'user-not-found') {
        message = 'No account found for this email';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many attempts. Try again later';
      } else {
        message = e.message ?? message;
      }
      showErrorBanner(message);
    } catch (e) {
      if (!mounted) return;
      showErrorBanner('Something went wrong. Please try again.');
    } finally {          /// finally runs no matter what (success or error)
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
