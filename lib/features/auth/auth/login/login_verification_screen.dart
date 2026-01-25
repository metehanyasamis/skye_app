import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:skye_app/features/home/home/home_screen.dart';
import 'package:skye_app/shared/services/auth_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/widgets/app_back_button.dart';
import 'package:skye_app/shared/widgets/base_scaffold.dart';
import 'package:skye_app/shared/widgets/otp_input_field.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/shared/widgets/skye_background.dart';
import 'package:skye_app/shared/widgets/skye_logo.dart';


class LoginVerificationScreen extends StatefulWidget {
  const LoginVerificationScreen({super.key});

  static const routeName = '/login-verification';

  @override
  State<LoginVerificationScreen> createState() => _LoginVerificationScreenState();
}

class _LoginVerificationScreenState extends State<LoginVerificationScreen> {
  final GlobalKey<OtpInputFieldState> _otpInputKey =
  GlobalKey<OtpInputFieldState>();

  final TextEditingController _smsController = TextEditingController();
  final FocusNode _smsFocusNode = FocusNode();

  String _otpCode = '';
  bool _isVerifying = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🔐 [LoginVerificationScreen] initState');
  }

  @override
  void dispose() {
    debugPrint('🔐 [LoginVerificationScreen] dispose');
    _smsController.dispose();
    _smsFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    debugPrint('⌨️ [LoginVerificationScreen] dismissKeyboard');
    FocusScope.of(context).unfocus();
  }

  void _onOtpChanged(String code) {
    debugPrint('🔢 [LoginVerificationScreen] OTP changed: "$code"');
    setState(() {
      _otpCode = code;
      _hasError = false;
    });
  }

  void _onOtpCompleted() {
    debugPrint('✅ [LoginVerificationScreen] OTP completed: "$_otpCode"');
    if (_otpCode.length == 4) {
      _verifyCode();
    }
  }

  Future<void> _verifyCode() async {
    debugPrint('🚀 [LoginVerificationScreen] verify pressed, otp="$_otpCode"');

    if (_otpCode.length != 4) {
      debugPrint('⛔ [LoginVerificationScreen] otp length invalid');
      return;
    }

    setState(() {
      _isVerifying = true;
      _hasError = false;
    });

    _dismissKeyboard();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) {
      debugPrint('⚠️ [LoginVerificationScreen] not mounted after delay');
      return;
    }

    final isValid = _otpCode == '1234';
    debugPrint('🧪 [LoginVerificationScreen] mock isValid=$isValid');

    if (isValid) {
      debugPrint('🏁 [LoginVerificationScreen] success -> Home');
      await AuthService.instance.setLoggedIn(true);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      return;
    }

    debugPrint('❌ [LoginVerificationScreen] invalid code -> error UI');
    HapticFeedback.mediumImpact();

    _otpInputKey.currentState?.setOtpCode('');

    setState(() {
      _isVerifying = false;
      _hasError = true;
      _otpCode = '';
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      debugPrint('🔁 [LoginVerificationScreen] reset error state');
      setState(() {
        _hasError = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧱 [LoginVerificationScreen] build');

    return BaseScaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.opaque,
        child: SkyeBackground(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
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
                              height: 50,
                            ),
                            const Spacer(),
                            const SizedBox(width: 48),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Log In',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          'Verification Code',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 16),

                        OtpInputField(
                          key: _otpInputKey,
                          length: 4,
                          onChanged: _onOtpChanged,
                          onCompleted: _onOtpCompleted,
                        ),

                        // Hidden SMS autofill field
                        SizedBox(
                          height: 0,
                          child: TextField(
                            controller: _smsController,
                            focusNode: _smsFocusNode,
                            keyboardType: TextInputType.number,
                            autofillHints: const [AutofillHints.oneTimeCode],
                            textInputAction: TextInputAction.done,
                            maxLength: 4,
                            // ❗ const kaldırıldı (FilteringTextInputFormatter const değil)
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            onChanged: (value) {
                              debugPrint(
                                  '📩 [LoginVerificationScreen] sms changed: "$value"');
                              if (value.length == 4) {
                                debugPrint(
                                    '📩 [LoginVerificationScreen] sms 4 digits -> fill otp');
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

                        const Spacer(),

                        SizedBox(
                          height:
                          MediaQuery.of(context).viewInsets.bottom > 0 ? 24 : 0,
                        ),

                        PrimaryButton(
                          label: _isVerifying
                              ? ''
                              : (_hasError
                              ? 'Code is incorrect, please try again'
                              : 'Verify'),
                          onPressed: _isVerifying
                              ? null
                              : _hasError
                              ? () {
                            debugPrint(
                                '🔁 [LoginVerificationScreen] error cleared by tap');
                            setState(() {
                              _hasError = false;
                            });
                          }
                              : (_otpCode.length == 4 ? _verifyCode : null),
                          child: _isVerifying
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

                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom > 0
                              ? MediaQuery.of(context).viewInsets.bottom
                              : 24,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
