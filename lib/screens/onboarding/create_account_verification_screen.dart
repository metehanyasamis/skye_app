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
  State<CreateAccountVerificationScreen> createState() => _CreateAccountVerificationScreenState();
}

class _CreateAccountVerificationScreenState extends State<CreateAccountVerificationScreen> {
  final GlobalKey<OtpInputFieldState> _otpInputKey = GlobalKey<OtpInputFieldState>();
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

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _onOtpChanged(String code) {
    setState(() {
      _otpCode = code;
      _hasError = false; // Clear error when user types
    });
  }

  void _onOtpCompleted() {
    if (_otpCode.length == 4) {
      _verifyCode();
    }
  }

  Future<void> _verifyCode() async {
    if (_otpCode.length != 4) return;

    setState(() {
      _isVerifying = true;
      _hasError = false;
    });

    _dismissKeyboard();

    // Simulate API call - Replace with actual verification logic
    await Future.delayed(const Duration(seconds: 1));

    // Mock verification - Replace with actual API call
    final isValid = _otpCode == '1234'; // Example: correct code is 1234

    if (!mounted) return;

    if (isValid) {
      // Success - Navigate to personal information screen
      Navigator.of(context).pushReplacementNamed(
        PersonalInformationScreen.routeName,
        arguments: {
          'phone': _phoneNumber ?? '',
        },
      );
    } else {
      // Error - Show vibration and error message
      HapticFeedback.mediumImpact();
      // Clear OTP fields first
      _otpInputKey.currentState?.setOtpCode('');
      setState(() {
        _isVerifying = false;
        _hasError = true; // Show error on button
        _otpCode = '';
      });
      
      // After 1.5 seconds, revert to "Verify" button
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
                          // Title - Left aligned
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Create An Account',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Verification Code Label
                          const Text(
                            'Verification Code',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // OTP Input Field
                          OtpInputField(
                            key: _otpInputKey,
                            length: 4,
                            onChanged: _onOtpChanged,
                            onCompleted: _onOtpCompleted,
                          ),
                          
                          // Hidden SMS autofill TextField for SMS code detection
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
                                if (value.length == 4) {
                                  // SMS code received, fill OTP fields
                                  _otpInputKey.currentState?.setOtpCode(value);
                                  _onOtpCompleted();
                                }
                              },
                            ),
                          ),
                          
                          const Spacer(),
                          
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom > 0 ? 24 : 0,
                          ),
                          
                          // Verify Button
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
      ),
    );
  }
}
