import 'package:flutter/services.dart';

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Limit to 8 digits (MMDDYYYY)
    if (digitsOnly.length > 8) {
      digitsOnly = digitsOnly.substring(0, 8);
    }

    // Format: MM/DD/YYYY
    String formatted = '';
    if (digitsOnly.isNotEmpty) {
      if (digitsOnly.length <= 2) {
        formatted = digitsOnly;
      } else if (digitsOnly.length <= 4) {
        formatted = '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2)}';
      } else {
        formatted = '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2, 4)}/${digitsOnly.substring(4)}';
      }
    }

    // Calculate cursor position
    int cursorPosition = formatted.length;
    
    // If user is deleting, keep cursor at the end of digits
    if (oldValue.text.length > newValue.text.length) {
      cursorPosition = formatted.length;
    } else {
      // If user is typing, position cursor after the last digit
      cursorPosition = formatted.length;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  // Helper method to get only digits from formatted date
  static String getDigitsOnly(String formattedDate) {
    return formattedDate.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
