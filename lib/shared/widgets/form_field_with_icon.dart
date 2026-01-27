import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/app_text_field.dart';

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
    this.fillColor,
    this.isRequired = false,
    this.minLines,
    this.maxLines,
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
  final Color? fillColor; // Optional fill color override
  final bool isRequired; // Show asterisk if required
  final int? minLines; // For multi-line fields
  final int? maxLines; // For multi-line fields

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: isRequired ? '$label *' : label,
      hint: hint,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      fillColor: fillColor,
      minLines: minLines,
      maxLines: maxLines,
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
