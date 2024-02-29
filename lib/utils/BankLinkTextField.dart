import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this line

class BankLinkTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String labelText;
  final IconData icon;
  final String? errorText; // Add this line
  final List<TextInputFormatter>? inputFormatters; // Add this line

  const BankLinkTextField({
    Key? key,
    required this.onChanged,
    required this.labelText,
    required this.icon,
    this.errorText, // Add this line
    this.inputFormatters, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      inputFormatters: inputFormatters, // Add this line
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorText: errorText, // Add this line
      ),
    );
  }
}
// Custom formatter to add spaces after every four digits
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.baseOffset;
    int usedSubstringIndex = 0;
    StringBuffer newText = StringBuffer();

    for (int i = 0; i < newTextLength; i++) {
      if (i == 4 || i == 8 || i == 12) {
        newText.write(' '); // Add a space after every four digits
      }
      if (usedSubstringIndex < newValue.selection.extentOffset &&
          i >= newValue.selection.extentOffset) {
        selectionIndex = newText.length;
        usedSubstringIndex = newTextLength + 1;
      }
      if (i < newTextLength) {
        newText.write(newValue.text[i]);
      }
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}