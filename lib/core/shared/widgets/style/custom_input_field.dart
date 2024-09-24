import 'package:flutter/material.dart';
import 'package:ucourses/core/constants/app_colors.dart';

import '../../../constants/constants_exports.dart';

class CustomInputField extends StatelessWidget {
  final IconData? prefixIcon;
  final IconData? suffixIconData;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final VoidCallback? onClearButtonPressed;
  final TextInputType? numericKeyboardType;
  final ValueChanged<String>? onChanged;
  final String labelText;
  final bool obscureText;

  const CustomInputField({
    super.key,
    this.prefixIcon,
    this.suffixIconData,
    this.validator,
    this.controller,
    this.onClearButtonPressed,
    this.onChanged,
    required this.labelText,
    this.obscureText = false,
    this.numericKeyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: numericKeyboardType ?? TextInputType.text,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Styles.style18.copyWith(color: Colors.grey, fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: AppColors.thirdColor,
              )
            : null,
        suffixIcon: suffixIconData != null
            ? IconButton(
                icon: Icon(
                  suffixIconData,
                  color: Colors.grey,
                ),
                onPressed: onClearButtonPressed)
            : null,
      ),
    );
  }
}
