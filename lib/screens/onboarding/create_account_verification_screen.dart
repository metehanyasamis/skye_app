import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skye_app/screens/onboarding/personal_information_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/widgets/otp_input_field.dart';
import 'package:skye_app/widgets/primary_button.dart';
import 'package:skye_app/widgets/skye_background.dart';
import 'package:skye_app/widgets/skye_logo.dart';

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
  void initState() {
    super.initState();
    debugPrint('✅ [CreateAccountVerificationScreen] initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('🧩 [CreateAccountVerificationScreen] didChangeDependencies');

    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    _phoneNumber = args?['phone'] as String?;
    debugPrint('📞 [CreateAccountVerificationScreen] phone=$_phoneNumber');
  }

  @override
  void dispose() {
    debugPrint('🧹 [CreateAccountVerificationScreen] dispose');
    _smsController.dispose();
    _smsFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    debugPrint('⌨️ [CreateAccountVerificationScreen] dismissKeyboard');
    FocusScope.of(context).unfocus();
  }

  void _onOtpChanged(String code) {
    debugPrint('🔢 [CreateAccountVerificationScreen] OTP changed: "$code"');
    setState(() {
      _otpCode = code;
      _hasError = false;
    });
  }

  void _onOtpCompleted() {
    debugPrint('✅ [CreateAccountVerificationScreen] OTP completed: "$_otpCode"');
    if (_otpCode.length == 4) {
      _verifyCode();
    }
  }

  Future<void> _verifyCode() async {
    debugPrint('🚀 [CreateAccountVerificationScreen] verify pressed, otp="$_otpCode"');

    if (_otpCode.length != 4) {
      debugPrint('⛔ [CreateAccountVerificationScreen] otp length invalid');
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
      debugPrint('⚠️ [CreateAccountVerificationScreen] not mounted after delay');
      return;
    }

    final isValid = _otpCode == '1234';
    debugPrint('🧪 [CreateAccountVerificationScreen] mock isValid=$isValid');

    if (isValid) {
      debugPrint('🏁 [CreateAccountVerificationScreen] success -> PersonalInformation');

      Navigator.of(context).pushReplacementNamed(
        PersonalInformationScreen.routeName,
        arguments: {
          'phone': _phoneNumber ?? '',
        },
      );
      return;
    }

    debugPrint('❌ [CreateAccountVerificationScreen] invalid code -> error UI');
    HapticFeedback.mediumImpact();

    _otpInputKey.currentState?.setOtpCode('');

    setState(() {
      _isVerifying = false;
      _hasError = true;
      _otpCode = '';
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      debugPrint('🔁 [CreateAccountVerificationScreen] reset error state');
      setState(() {
        _hasError = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧱 [CreateAccountVerificationScreen] build');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.opaque,
        child: SkyeBackground(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Header
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                debugPrint('⬅️ [CreateAccountVerificationScreen] back pressed');
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.white,
                              ),
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
                            'Create An Account',
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

                        // OTP
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            onChanged: (value) {
                              debugPrint(
                                '📩 [CreateAccountVerificationScreen] sms changed: "$value"',
                              );
                              if (value.length == 4) {
                                debugPrint(
                                  '📩 [CreateAccountVerificationScreen] sms 4 digits -> fill otp',
                                );
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

                        // Button
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
                              '🔁 [CreateAccountVerificationScreen] error cleared by tap',
                            );
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
