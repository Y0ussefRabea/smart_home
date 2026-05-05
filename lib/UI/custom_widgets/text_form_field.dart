import 'package:flutter/material.dart';
import 'package:smart_home/utils/app_colors.dart';
import 'package:smart_home/utils/app_styles.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? errorText;
  final TextEditingController? controller;

  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.errorText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}
class _CustomTextFieldState extends State<CustomTextField> {
  late bool obscureText;
  @override
  void initState() {
    obscureText = widget.isPassword;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: widget.controller,
        obscureText: obscureText,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        style: AppStyles.regular16Gray,
        decoration: InputDecoration(
          errorText: widget.errorText,
          hintText: widget.hintText,
          hintStyle: AppStyles.regular16Gray,
          filled: true,
          fillColor: AppColors.fillWhiteColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),

          prefixIcon: widget.prefixIcon,

          suffixIcon: widget.isPassword
              ? IconButton(
            onPressed: () {
              obscureText = !obscureText;
              setState((){
              });
            },
            icon: Icon(
              obscureText ? Icons.visibility_off :
              Icons.visibility,
              color: AppColors.lightGrayColor,
            ),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: AppColors.primaryLight,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}