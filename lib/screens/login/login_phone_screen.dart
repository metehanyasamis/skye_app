import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skye_app/screens/onboarding/create_account_phone_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/phone_number_formatter.dart';
import 'package:skye_app/widgets/app_text_field.dart';
import 'package:skye_app/widgets/country_code_picker.dart';
import 'package:skye_app/widgets/primary_button.dart';
import 'package:skye_app/widgets/skye_background.dart';
import 'package:skye_app/widgets/skye_logo.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});

  static const routeName = '/login-phone';

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String _countryCode = '+1';
  bool _obscurePassword = true;
  bool _isLoggingIn = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🔐 [LoginPhoneScreen] initState');
  }

  @override
  void dispose() {
    debugPrint('🔐 [LoginPhoneScreen] dispose');

    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    debugPrint('⌨️ [LoginPhoneScreen] dismissKeyboard');
    FocusScope.of(context).unfocus();
  }

  Future<void> _login() async {
    debugPrint('🚀 [LoginPhoneScreen] _login() clicked');

    final digits = PhoneNumberFormatter.getDigitsOnly(_phoneController.text);
    final pass = _passwordController.text.trim();

    debugPrint('📞 [LoginPhoneScreen] phoneDigits=$digits country=$_countryCode');
    debugPrint('🔑 [LoginPhoneScreen] passLen=${pass.length}');

    if (digits.length < 10 || pass.isEmpty) {
      debugPrint('⛔ [LoginPhoneScreen] validation failed');
      return;
    }

    setState(() {
      _isLoggingIn = true;
      _hasError = false;
    });

    _dismissKeyboard();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) {
      debugPrint('⚠️ [LoginPhoneScreen] not mounted after delay');
      return;
    }

    // Mock login
    final isValid = digits == '5555555555' && pass == '1234';
    debugPrint('✅ [LoginPhoneScreen] mock isValid=$isValid');

    if (isValid) {
      debugPrint('➡️ [LoginPhoneScreen] navigate /home');
      Navigator.of(context).pushReplacementNamed('/home');
      return;
    }

    debugPrint('❌ [LoginPhoneScreen] invalid login -> error UI');
    HapticFeedback.mediumImpact();

    setState(() {
      _isLoggingIn = false;
      _hasError = true;
      _passwordController.clear();
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      debugPrint('🔁 [LoginPhoneScreen] reset error state');
      setState(() {
        _hasError = false;
      });
    });
  }

  bool get _canSubmit {
    final digits = PhoneNumberFormatter.getDigitsOnly(_phoneController.text);
    return digits.length >= 10 && _passwordController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧱 [LoginPhoneScreen] build');

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
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                debugPrint('⬅️ [LoginPhoneScreen] back pressed');
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

                        Text(
                          'Log In',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),

                        const SizedBox(height: 24),

                        // Phone input + country picker
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CountryCodePicker(
                              initialCountryCode: _countryCode,
                              onChanged: (dialCode) {
                                debugPrint('🌍 [LoginPhoneScreen] countryCode changed: $dialCode');
                                setState(() {
                                  _countryCode = dialCode;
                                });
                              },
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppTextField(
                                controller: _phoneController,
                                focusNode: _phoneFocusNode,
                                label: 'Phone Number',
                                hint: '(000) 000-0000',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  PhoneNumberFormatter(),
                                ],
                                onChanged: (value) {
                                  debugPrint('📞 [LoginPhoneScreen] phone changed: $value');
                                  setState(() {
                                    _hasError = false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Password input
                        AppTextField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          label: 'Password',
                          hint: 'Enter your password',
                          obscureText: _obscurePassword,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (value) {
                            debugPrint('🔑 [LoginPhoneScreen] password changed: len=${value.length}');
                            setState(() {
                              _hasError = false;
                            });
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              debugPrint('👁️ [LoginPhoneScreen] toggle obscure');
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              debugPrint('🧩 [LoginPhoneScreen] forgot password tapped (TODO)');
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom > 0 ? 24 : 0,
                        ),

                        // Login button
                        PrimaryButton(
                          label: _isLoggingIn
                              ? ''
                              : (_hasError
                              ? 'Incorrect password, please try again'
                              : 'Log In'),
                          onPressed: _isLoggingIn
                              ? null
                              : _hasError
                              ? () {
                            debugPrint('🔁 [LoginPhoneScreen] error state cleared by tap');
                            setState(() {
                              _hasError = false;
                            });
                          }
                              : (_canSubmit ? _login : null),
                          child: _isLoggingIn
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

                        const SizedBox(height: 12),

                        // Sign up
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(color: AppColors.textPrimary),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('➡️ [LoginPhoneScreen] Sign Up tapped');
                                _dismissKeyboard();
                                Navigator.of(context).pushReplacementNamed(
                                  CreateAccountPhoneScreen.routeName,
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: AppColors.navy800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom > 0
                              ? MediaQuery.of(context).viewInsets.bottom
                              : 18,
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
