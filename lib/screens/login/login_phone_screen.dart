import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skye_app/screens/home/home_screen.dart';
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
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Future<void> _login() async {
    if (PhoneNumberFormatter.getDigitsOnly(_phoneController.text).length < 10 ||
        _passwordController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isLoggingIn = true;
      _hasError = false;
    });

    _dismissKeyboard();

    // TODO: Replace with actual API call
    // Example:
    // try {
    //   final response = await http.post(
    //     Uri.parse('https://api.skye.app/auth/login'),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode({
    //       'phone': '$_countryCode${PhoneNumberFormatter.getDigitsOnly(_phoneController.text)}',
    //       'password': _passwordController.text.trim(),
    //     }),
    //   );
    //   if (response.statusCode == 200) {
    //     // Success - navigate to home
    //   } else {
    //     // Handle error
    //   }
    // } catch (e) {
    //   // Handle error
    // }

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Mock login - Replace with actual API call
    final phoneDigits = PhoneNumberFormatter.getDigitsOnly(_phoneController.text);
    final isValid = phoneDigits == '5555555555' && _passwordController.text == '1234';

    if (isValid) {
      // Success - Navigate to home
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Error - Show vibration and error message
      HapticFeedback.mediumImpact();
      setState(() {
        _isLoggingIn = false;
        _hasError = true;
        _passwordController.clear();
      });

      // After 1.5 seconds, revert button
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _hasError = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.opaque,
        child: SkyeBackground(
          child: SafeArea(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.arrow_back,
                                    color: AppColors.white),
                              ),
                              const Spacer(),
                              const SkyeLogo(),
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
                          // Phone Number Input with Country Code
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CountryCodePicker(
                                initialCountryCode: _countryCode,
                                onChanged: (dialCode) {
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
                                    setState(() {
                                      _hasError = false; // Clear error when user types
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Password Input
                          AppTextField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            label: 'Password',
                            hint: 'Enter your password',
                            obscureText: _obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (value) {
                              setState(() {
                                _hasError = false; // Clear error when user types
                              });
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // TODO: Implement forgot password flow when endpoint is ready
                                // Navigator.of(context).pushNamed(ForgotPasswordScreen.routeName);
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: AppColors.textSecondary ,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          
                          const Spacer(),
                          SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 24 : 0),
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
                                        setState(() {
                                          _hasError = false;
                                        });
                                      }
                                    : (PhoneNumberFormatter.getDigitsOnly(_phoneController.text).length >= 10 &&
                                            _passwordController.text.trim().isNotEmpty
                                        ? _login
                                        : null),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                              GestureDetector(
                                onTap: () {
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
      ),
    );
  }
}
