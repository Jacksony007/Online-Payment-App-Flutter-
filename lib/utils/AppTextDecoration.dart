import 'package:flutter/material.dart';

class AppTextDecoration {
  static InputDecoration defaultInputDecoration({
    required String labelText,
    IconData? prefixIcon,
    Color? iconColor,
    String? helperText,
    String? hintText,
    String? suffixText, // Add this line to include hintText parameter
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      // Include hintText here
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: iconColor,
            )
          : null,
      helperText: helperText,
      suffixText: suffixText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
