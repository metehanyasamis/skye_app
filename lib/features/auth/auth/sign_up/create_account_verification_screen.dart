// lib/screens/onboarding/create_account_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:skye_app/features/auth/auth/sign_up/personal_information_screen.dart';
import 'package:skye_app/shared/services/auth_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/widgets/app_back_button.dart';
import 'package:skye_app/shared/widgets/base_scaffold.dart';
import 'package:skye_app/shared/widgets/otp_input_field.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/shared/widgets/skye_background.dart';
import 'package:skye_app/shared/widgets/skye_logo.dart';

class CreateAccountVerificationScreen extends StatefulWidget {
  const CreateAccountVerificationScreen({super.key});

  static const routeName = '/create-account-verification';

  @override
  State<CreateAccountVerificationScreen> createState() =>
      _CreateAccountVerificationScreenState();
}

class _CreateAccountVerificationScreenState
    extends State<CreateAccountVerificationScreen> {
  final GlobalKey<OtpInputFieldState> _otpInputKey =
  GlobalKey<OtpInputFieldState>();

  final TextEditingController _smsController = TextEditingController();
  final FocusNode _smsFocusNode = FocusNode();

  String _otpCode = '';
  bool _isVerifying = false;
  bool _hasError = false;
  String? _phoneNumber;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _phoneNumber = args?['phone'] as String?;
  }

  @override
  void dispose() {
    _smsController.dispose();
    _smsFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() => FocusScope.of(context).unfocus();

  void _onOtpChanged(String code) => setState(() {
    _otpCode = code;
    _hasError = false;
  });

  void _onOtpCompleted() {
    if (_otpCode.length == 6) _verifyCode();
  }

  Future<void> _verifyCode() async {
    if (_otpCode.length != 6) return;
    
    if (_phoneNumber == null || _phoneNumber!.isEmpty) {
      debugPrint('⛔ [CreateAccountVerificationScreen] phone number missing');
      return;
    }

    setState(() {
      _isVerifying = true;
      _hasError = false;
    });

    _dismissKeyboard();

    try {
      debugPrint('🌐 [CreateAccountVerificationScreen] verifying OTP: phone=$_phoneNumber, code=$_otpCode');
      
      // Verify OTP with backend
      final response = await AuthApiService.instance.verifyOtp(
        phone: _phoneNumber!,
        code: _otpCode,
      );

      if (!mounted) return;

      if (response.success) {
        debugPrint('✅ [CreateAccountVerificationScreen] OTP verified successfully');
        
        // Navigate to personal information screen
        Navigator.of(context).pushReplacementNamed(
          PersonalInformationScreen.routeName,
          arguments: {'phone': _phoneNumber ?? ''},
        );
        return;
      }

      // Verification failed
      debugPrint('❌ [CreateAccountVerificationScreen] OTP verification failed');
      HapticFeedback.mediumImpact();
      _otpInputKey.currentState?.setOtpCode('');

      setState(() {
        _isVerifying = false;
        _hasError = true;
        _otpCode = '';
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        setState(() => _hasError = false);
      });
      
    } catch (e) {
      debugPrint('❌ [CreateAccountVerificationScreen] verification error: $e');
      
      if (!mounted) return;
      
      HapticFeedback.mediumImpact();
      _otpInputKey.currentState?.setOtpCode('');

      setState(() {
        _isVerifying = false;
        _hasError = true;
        _otpCode = '';
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        setState(() => _hasError = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return BaseScaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      setDarkStatusBar: true,

      // ✅ footer baseScaffold
      bottom: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 65),
        child: PrimaryButton(
          label: _isVerifying
              ? ''
              : (_hasError ? 'Code is incorrect, please try again' : 'Verify'),
          onPressed: _isVerifying
              ? null
              : _hasError
              ? () => setState(() => _hasError = false)
              : (_otpCode.length == 6 ? _verifyCode : null),
          child: _isVerifying
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          )
              : null,
        ),
      ),
      keyboardAwareBottom: true,

      child: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.opaque,
        child: SkyeBackground(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, topInset + 10, 24, 170),
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
                const Text(
                  'Verification Code',
                  style: TextStyle(color: AppColors.white, fontSize: 18),
                ),
                const SizedBox(height: 16),

                OtpInputField(
                  key: _otpInputKey,
                  length: 6,
                  onChanged: _onOtpChanged,
                  onCompleted: _onOtpCompleted,
                ),
                const SizedBox(height: 16),

                // Hidden SMS autofill
                SizedBox(
                  height: 0,
                  child: TextField(
                    controller: _smsController,
                    focusNode: _smsFocusNode,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    textInputAction: TextInputAction.done,
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    onChanged: (value) {
                      if (value.length == 6) {
                        _otpInputKey.currentState?.setOtpCode(value);
                        setState(() {
                          _otpCode = value;
                          _hasError = false;
                        });
                        _onOtpCompleted();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
