import 'package:flutter/material.dart';

// EDIT FIX Enhancement 1: This file previously contained a duplicate copy of
// custom_dialogs.dart (customDialog / customShowImageDialog) instead of the
// CustomTextFormField widget that signin_screen.dart needs to render the
// username/password fields used to authenticate the user against
// https://dummyjson.com/docs/users. Rebuilt as the actual reusable text
// field widget below.
class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String hintText;
  final double fontSize;
  final Color fontColor;
  final double height;
  final double width;
  final bool obscureText;
  final bool hasToggle;
  final VoidCallback? onToggle;
  final TextInputType keyboardType;

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.onSaved,
    required this.hintText,
    required this.fontSize,
    required this.fontColor,
    required this.height,
    required this.width,
    this.obscureText = false,
    this.hasToggle = false,
    this.onToggle,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: fontSize,
        color: fontColor,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: fontSize,
          color: fontColor.withOpacity(0.5),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: width,
          vertical: height,
        ),
        border: const OutlineInputBorder(),
        suffixIcon: hasToggle
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: fontColor,
                ),
                onPressed: onToggle,
              )
            : null,
      ),
    );
  }
}
