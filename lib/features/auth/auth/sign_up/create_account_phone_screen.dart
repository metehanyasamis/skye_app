// lib/screens/onboarding/create_account_phone_screen.dart
import 'package:flutter/material.dart';

import 'package:skye_app/features/auth/auth/sign_up/create_account_verification_screen.dart';
import 'package:skye_app/shared/services/auth_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/app/routes/app_routes.dart';
import 'package:skye_app/shared/utils/phone_number_formatter.dart';
import 'package:skye_app/shared/widgets/app_back_button.dart';
import 'package:skye_app/shared/widgets/app_text_field.dart';
import 'package:skye_app/shared/widgets/base_scaffold.dart';
import 'package:skye_app/shared/widgets/country_code_picker.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/shared/widgets/skye_background.dart';
import 'package:skye_app/shared/widgets/skye_logo.dart';

class CreateAccountPhoneScreen extends StatefulWidget {
  const CreateAccountPhoneScreen({super.key});

  static const routeName = '/create-account-phone';

  @override
  State<CreateAccountPhoneScreen> createState() =>
      _CreateAccountPhoneScreenState();
}

class _CreateAccountPhoneScreenState extends State<CreateAccountPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  String _countryCode = '+1';
  bool _isSending = false;
  bool _hasError = false;
  String _errorMessage = 'Failed to send code. Tap to retry';

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() => FocusScope.of(context).unfocus();

  Future<void> _onContinue() async {
    _dismissKeyboard();

    final phoneDigits = PhoneNumberFormatter.getDigitsOnly(_phoneController.text);
    final fullPhone = '$_countryCode$phoneDigits';

    if (phoneDigits.length < 10) {
      return;
    }

    setState(() {
      _isSending = true;
      _hasError = false;
    });

    try {
      debugPrint('📱 [CreateAccountPhoneScreen] sending OTP to: $fullPhone');
      
      // Send OTP to phone number
      await AuthApiService.instance.sendOtp(phone: fullPhone);
      
      if (!mounted) return;
      
      debugPrint('✅ [CreateAccountPhoneScreen] OTP sent successfully');
      
      // Navigate to verification screen
      Navigator.of(context).pushNamed(
        CreateAccountVerificationScreen.routeName,
        arguments: {'phone': fullPhone},
      );
      
    } catch (e) {
      debugPrint('❌ [CreateAccountPhoneScreen] send OTP error: $e');
      
      if (!mounted) return;
      
      String errorMessage = 'Failed to send code. Tap to retry';
      if (e is ApiError) {
        errorMessage = e.message;
        // If phone is already registered, suggest login
        if (e.message.toLowerCase().contains('already registered')) {
          errorMessage = 'This phone number is already registered. Please log in instead.';
        }
      }
      
      setState(() {
        _isSending = false;
        _hasError = true;
        _errorMessage = errorMessage;
      });
      
      // Auto-reset error after 3 seconds
      Future.delayed(const Duration(milliseconds: 3000), () {
        if (!mounted) return;
        setState(() {
          _hasError = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    final phoneDigits = PhoneNumberFormatter.getDigitsOnly(_phoneController.text);
    final canContinue = phoneDigits.length >= 10;

    return BaseScaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      setDarkStatusBar: true,

      // ✅ footer artık BaseScaffold içinde
      bottom: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              label: _isSending
                  ? ''
                  : (_hasError
                      ? _errorMessage
                      : 'Continue'),
              onPressed: _isSending
                  ? null
                  : (_hasError
                      ? () {
                          // If phone is already registered, navigate to login
                          if (_errorMessage.toLowerCase().contains('already registered')) {
                            Navigator.of(context).pushReplacementNamed(AppRoutes.loginPhone);
                            return;
                          }
                          setState(() {
                            _hasError = false;
                          });
                          _onContinue();
                        }
                      : (canContinue ? _onContinue : null)),
              child: _isSending
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(color: AppColors.white.withValues(alpha: 0.9)),
                ),
                GestureDetector(
                  onTap: () {
                    _dismissKeyboard();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.95),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      keyboardAwareBottom: true,

      // ✅ content sade: sadece scroll
      child: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.opaque,
        child: SkyeBackground(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, topInset + 10, 24, 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppBackButton(
                      color: AppColors.white,
                      icon: Icons.arrow_back,
                    ),
                    const Spacer(),
                    const SkyeLogo(
                      type: 'logoText',
                      color: 'white',
                      height: 36,
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Create An Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 32),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CountryCodePicker(
                      initialCountryCode: _countryCode,
                      onChanged: (dialCode) => setState(() => _countryCode = dialCode),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        controller: _phoneController,
                        focusNode: _phoneFocusNode,
                        label: 'Phone Number',
                        hint: '(000) 000-0000',
                        keyboardType: TextInputType.number,
                        inputFormatters: [PhoneNumberFormatter()],
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(color: AppColors.white, fontSize: 16),
                        labelStyle: const TextStyle(color: AppColors.white, fontSize: 16),
                        hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.6), fontSize: 16),
                        fillColor: AppColors.white.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text(
                  'We will send you verification code.',
                  style: TextStyle(color: AppColors.white.withValues(alpha: 0.85), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
