import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skye_app/theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.keyboardType,
    this.controller,
    this.focusNode,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.obscureText,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
  });

  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final bool? obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final hasMultipleLines =
        (minLines != null && minLines! > 1) || (maxLines != null && maxLines! > 1);

    final effectiveKeyboardType =
    hasMultipleLines ? TextInputType.multiline : (keyboardType ?? TextInputType.text);

    // ✅ Multi-line: label üstte ayrı Text widget
    if (hasMultipleLines) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              maxLines: null,
              softWrap: true,
            ),
          ),
          TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: effectiveKeyboardType,
            maxLength: maxLength,
            minLines: minLines,
            maxLines: maxLines ?? (minLines != null ? null : 1),
            obscureText: obscureText ?? false,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            onTap: onTap,
            textInputAction: TextInputAction.newline,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              counterText: '', // Hide character counter
              suffixIcon: suffixIcon,
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      );
    }

    // ✅ Single-line: normal labelText
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: effectiveKeyboardType,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines ?? (minLines != null ? null : 1),
      obscureText: obscureText ?? false,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onTap: onTap,
      textInputAction: TextInputAction.done,
      textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: '', // Hide character counter
        suffixIcon: suffixIcon,
      ),
    );
  }
}
