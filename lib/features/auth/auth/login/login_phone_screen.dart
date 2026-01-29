// lib/screens/login/login_phone_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:skye_app/features/auth/auth/sign_up/create_account_phone_screen.dart';
import 'package:skye_app/features/home/home/home_screen.dart';
import 'package:skye_app/shared/services/auth_api_service.dart';
import 'package:skye_app/shared/services/auth_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/phone_number_formatter.dart';
import 'package:skye_app/shared/widgets/app_text_field.dart';
import 'package:skye_app/shared/widgets/base_scaffold.dart';
import 'package:skye_app/shared/widgets/country_code_picker.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/shared/widgets/skye_background.dart';
import 'package:skye_app/shared/widgets/skye_logo.dart';


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

    try {
      // Build full phone number with country code
      final fullPhone = '$_countryCode$digits';
      
      debugPrint('🌐 [LoginPhoneScreen] calling API: phone=$fullPhone');
      
      // Call backend API
      final response = await AuthApiService.instance.login(
        phone: fullPhone,
        password: pass,
      );

      if (!mounted) {
        debugPrint('⚠️ [LoginPhoneScreen] not mounted after API call');
        return;
      }

      debugPrint('✅ [LoginPhoneScreen] login success: token=${response.token != null}');
      
      // Save login state
      await AuthService.instance.setLoggedIn(true);
      
      // Navigate to home
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      
    } catch (e) {
      debugPrint('❌ [LoginPhoneScreen] login error: $e');
      
      if (!mounted) return;
      
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
  }

  bool get _canSubmit {
    final digits = PhoneNumberFormatter.getDigitsOnly(_phoneController.text);
    return digits.length >= 10 && _passwordController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧱 [LoginPhoneScreen] build');

    final topInset = MediaQuery.of(context).padding.top;

    return BaseScaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      setDarkStatusBar: true,

      // ✅ Bottom CTA artık BaseScaffold yönetiyor
      keyboardAwareBottom: true,
      bottomOffset: 24,
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: PrimaryButton(
              label: _isLoggingIn
                  ? ''
                  : (_hasError
                  ? 'Incorrect password, please try again'
                  : 'Log In'),
              onPressed: _isLoggingIn
                  ? null
                  : _hasError
                  ? () {
                debugPrint(
                  '🔁 [LoginPhoneScreen] error state cleared by tap',
                );
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
          ),
          const SizedBox(height: 12),

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
        ],
      ),

      child: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.opaque,
        child: SkyeBackground(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  24,
                  topInset + 10,
                  24,
                  24, // ✅ footer space BaseScaffold hallediyor
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
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

                      const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                          height: 32 / 28,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Phone
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CountryCodePicker(
                            initialCountryCode: _countryCode,
                            darkStyle: true,
                            onChanged: (dialCode) {
                              debugPrint(
                                '🌍 [LoginPhoneScreen] countryCode changed: $dialCode',
                              );
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
                              style: const TextStyle(color: AppColors.white, fontSize: 16),
                              labelStyle: const TextStyle(color: AppColors.white, fontSize: 16),
                              hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.6), fontSize: 16),
                              fillColor: AppColors.white.withValues(alpha: 0.12),
                              onChanged: (value) {
                                debugPrint(
                                  '📞 [LoginPhoneScreen] phone changed: $value',
                                );
                                setState(() {
                                  _hasError = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Password
                      AppTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        label: 'Password',
                        hint: 'Enter your password',
                        obscureText: _obscurePassword,
                        keyboardType: TextInputType.visiblePassword,
                        style: const TextStyle(color: AppColors.white, fontSize: 16),
                        labelStyle: const TextStyle(color: AppColors.white, fontSize: 16),
                        hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.6), fontSize: 16),
                        fillColor: AppColors.white.withValues(alpha: 0.12),
                        onChanged: (value) {
                          debugPrint(
                            '🔑 [LoginPhoneScreen] password changed: len=${value.length}',
                          );
                          setState(() {
                            _hasError = false;
                          });
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.white,
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
                            debugPrint(
                              '🧩 [LoginPhoneScreen] forgot password tapped (TODO)',
                            );
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

                      // ✅ burada Spacer yok, çünkü CTA BaseScaffold’ta
                      const SizedBox(height: 12),
                    ],
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
