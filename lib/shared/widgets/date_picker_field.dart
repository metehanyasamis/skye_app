import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/date_picker_helper.dart';
import 'package:skye_app/shared/widgets/app_text_field.dart';

/// Tarih seçimi için ortak widget.
/// DatePickerHelper + Personal Information ekranındaki takvim yapısı kullanılır.
/// [DatePickerFieldStyle.textField]: AppTextField (label/hint) – örn. Personal Info.
/// [DatePickerFieldStyle.borderedIcon]: ikon + hint, bordered container – örn. Post ekranları.
enum DatePickerFieldStyle {
  textField,
  borderedIcon,
}

class DatePickerField extends StatefulWidget {
  const DatePickerField({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.label,
    this.hint = 'MM/DD/YYYY',
    this.icon,
    this.style = DatePickerFieldStyle.textField,
    this.format = 'MM/dd/yyyy',
    this.onDateChanged,
    this.controller,
    this.iconColor,
    this.hintColor,
    this.prefillFromInitialDate = false,
    this.darkStyle = false,
    this.errorText,
    this.fillColor,
    this.enabledBorderSide,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? label;
  final String hint;
  final IconData? icon;
  final DatePickerFieldStyle style;
  final String format;
  final ValueChanged<DateTime?>? onDateChanged;
  final TextEditingController? controller;
  final Color? iconColor;
  final Color? hintColor;
  /// Alanı [initialDate] ile doldur (örn. Post DoD/DoA bugün). false ise boş bırak (örn. DOB).
  final bool prefillFromInitialDate;
  /// Beyaz metin ve koyu arka plan (örn. Create Account ekranları).
  final bool darkStyle;
  final String? errorText;
  final Color? fillColor;
  final BorderSide? enabledBorderSide;

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _controller;
  DateTime? _value;
  DateFormat? _formatter;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  bool get _ownsController => widget.controller == null;

  @override
  void initState() {
    super.initState();
    if (_ownsController) {
      _controller = TextEditingController();
    } else {
      _controller = widget.controller!;
    }
    _formatter = DateFormat(widget.format);
    _value = widget.prefillFromInitialDate ? widget.initialDate : null;
    if (widget.prefillFromInitialDate) {
      _effectiveController.text = _formatter!.format(widget.initialDate);
    }
  }

  @override
  void didUpdateWidget(DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.format != widget.format ||
        oldWidget.prefillFromInitialDate != widget.prefillFromInitialDate) {
      _formatter = DateFormat(widget.format);
      _value = widget.prefillFromInitialDate ? widget.initialDate : null;
      if (widget.prefillFromInitialDate) {
        _effectiveController.text = _formatter!.format(widget.initialDate);
      } else {
        _effectiveController.clear();
      }
    }
    // initialDate omitted: avoid clearing when parent passes DateTime.now() etc.
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pick() async {
    final picked = await DatePickerHelper.showThemedDatePicker(
      context: context,
      initialDate: _value ?? widget.initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked != null) {
      setState(() {
        _value = picked;
        _effectiveController.text = _formatter!.format(picked);
      });
      widget.onDateChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pick,
      behavior: HitTestBehavior.opaque,
      child: AbsorbPointer(
        child: widget.style == DatePickerFieldStyle.borderedIcon
            ? _buildBorderedIcon()
            : _buildTextField(),
      ),
    );
  }

  Widget _buildTextField() {
    return AppTextField(
      controller: _effectiveController,
      label: widget.label!,
      hint: widget.hint,
      onChanged: (_) {},
      errorText: widget.errorText,
      style: widget.darkStyle
          ? const TextStyle(color: AppColors.white, fontSize: 16)
          : null,
      labelStyle: widget.darkStyle
          ? const TextStyle(color: AppColors.white, fontSize: 16)
          : null,
      hintStyle: widget.darkStyle
          ? TextStyle(color: AppColors.white.withValues(alpha: 0.6), fontSize: 16)
          : null,
      fillColor: widget.fillColor ??
          (widget.darkStyle ? AppColors.white.withValues(alpha: 0.12) : null),
      enabledBorderSide: widget.enabledBorderSide,
    );
  }

  Widget _buildBorderedIcon() {
    final ic = widget.icon ?? Icons.calendar_today;
    final color = widget.iconColor ?? AppColors.navy900;
    final hc = widget.hintColor ?? AppColors.navy900;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.navy900, width: 1),
      ),
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(ic, size: 24, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _effectiveController,
              style: TextStyle(fontSize: 16, color: color),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                hintText: widget.hint,
                hintStyle: TextStyle(fontSize: 16, color: hc),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
