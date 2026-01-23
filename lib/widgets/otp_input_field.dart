import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skye_app/theme/app_colors.dart';

class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    required this.length,
    required this.onChanged,
    this.onCompleted,
    this.focusNode,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final VoidCallback? onCompleted;
  final FocusNode? focusNode;

  @override
  OtpInputFieldState createState() => OtpInputFieldState();
}

class OtpInputFieldState extends State<OtpInputField> {

  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _otpCode = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(),
    );
    
    // Listen to focus changes
    for (int i = 0; i < widget.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus && _controllers[i].text.isEmpty) {
          _controllers[i].selection = TextSelection.collapsed(offset: 0);
        }
        setState(() {}); // Rebuild when focus changes
      });
      _controllers[i].addListener(() {
        setState(() {}); // Rebuild when text changes
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    // Only allow single digit
    if (value.length > 1) {
      value = value.substring(value.length - 1);
    }
    
    // Only allow digits
    if (value.isNotEmpty && !RegExp(r'^[0-9]$').hasMatch(value)) {
      _controllers[index].clear();
      return;
    }

    _controllers[index].text = value;
    
    // Update OTP code
    _otpCode = _controllers.map((c) => c.text).join();
    widget.onChanged(_otpCode);

    // Move to next field if digit entered
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // Check if all fields are filled
    if (_otpCode.length == widget.length) {
      widget.onCompleted?.call();
    }
  }

  void setOtpCode(String code) {
    if (code.length > widget.length) {
      code = code.substring(0, widget.length);
    }
    
    for (int i = 0; i < widget.length; i++) {
      if (i < code.length) {
        _controllers[i].text = code[i];
      } else {
        _controllers[i].clear();
      }
    }
    
    _otpCode = code;
    widget.onChanged(_otpCode);
    
    if (_otpCode.length == widget.length) {
      widget.onCompleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        final hasValue = _controllers[index].text.isNotEmpty;
        final isFocused = _focusNodes[index].hasFocus;
        
        return Container(
          width: 56,
          height: 56,
          margin: EdgeInsets.only(
            right: index < widget.length - 1 ? 12 : 0,
          ),
          decoration: BoxDecoration(
            color: hasValue ? AppColors.white : AppColors.fieldFill,
            shape: BoxShape.circle,
            border: isFocused
                ? Border.all(
                    color: AppColors.white,
                    width: 2,
                  )
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                cursorColor: hasValue ? AppColors.navy900 : AppColors.white,
                style: TextStyle(
                  color: hasValue ? AppColors.navy900 : AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  height: 1.0, // Better vertical centering
                ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.transparent, // Transparent to show container color
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              onChanged: (value) => _onChanged(index, value),
              onTap: () {
                _focusNodes[index].requestFocus();
              },
              onSubmitted: (value) {
                if (index < widget.length - 1) {
                  _focusNodes[index + 1].requestFocus();
                }
              },
              onEditingComplete: () {
                if (index < widget.length - 1) {
                  _focusNodes[index + 1].requestFocus();
                }
              },
              buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
              ),
            ),
        ),
        );
      }),
    );
  }
}
