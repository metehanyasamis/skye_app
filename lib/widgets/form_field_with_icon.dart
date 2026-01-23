import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/debug_logger.dart';
import 'package:skye_app/widgets/app_text_field.dart';

/// Reusable form field with icon widget
/// Combines AppTextField with an icon prefix
class FormFieldWithIcon extends StatelessWidget {
  const FormFieldWithIcon({
    super.key,
    required this.label,
    required this.icon,
    this.hint,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  final String label;
  final IconData icon;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      onChanged: (value) {
        DebugLogger.log('FormFieldWithIcon', 'changed', {
          'label': label,
          'value': value,
        });
        onChanged?.call(value);
      },
      onTap: onTap,
      readOnly: readOnly,
      prefixIcon: Icon(
        icon,
        size: 20,
        color: AppColors.textSecondary,
      ),
    );
  }
}
