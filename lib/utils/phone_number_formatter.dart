import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Limit to 10 digits
    if (digitsOnly.length > 10) {
      digitsOnly = digitsOnly.substring(0, 10);
    }

    // Format: (XXX) XXX-XXXX
    String formatted = '';
    if (digitsOnly.isNotEmpty) {
      if (digitsOnly.length <= 3) {
        formatted = '($digitsOnly';
      } else if (digitsOnly.length <= 6) {
        formatted = '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3)}';
      } else {
        formatted = '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
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

  // Helper method to get only digits from formatted phone number
  static String getDigitsOnly(String formattedPhone) {
    return formattedPhone.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
