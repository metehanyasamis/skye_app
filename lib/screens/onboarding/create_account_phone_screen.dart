import 'package:flutter/material.dart';
import 'package:skye_app/screens/onboarding/create_account_verification_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/phone_number_formatter.dart';
import 'package:skye_app/widgets/app_text_field.dart';
import 'package:skye_app/widgets/country_code_picker.dart';
import 'package:skye_app/widgets/primary_button.dart';
import 'package:skye_app/widgets/skye_background.dart';
import 'package:skye_app/widgets/skye_logo.dart';

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

  @override
  void initState() {
    super.initState();
    debugPrint('📱 [CreateAccountPhoneScreen] initState');
  }

  @override
  void dispose() {
    debugPrint('📱 [CreateAccountPhoneScreen] dispose');
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    debugPrint('⌨️ [CreateAccountPhoneScreen] dismissKeyboard');
    FocusScope.of(context).unfocus();
  }

  void _onContinue() {
    debugPrint('➡️ [CreateAccountPhoneScreen] Continue pressed');
    _dismissKeyboard();

    final phoneDigits = PhoneNumberFormatter.getDigitsOnly(_phoneController.text);
    final fullPhone = '$_countryCode$phoneDigits';

    debugPrint('📞 [CreateAccountPhoneScreen] fullPhone=$fullPhone');

    Navigator.of(context).pushNamed(
      CreateAccountVerificationScreen.routeName,
      arguments: {
        'phone': fullPhone,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧱 [CreateAccountPhoneScreen] build');

    final phoneDigits = PhoneNumberFormatter.getDigitsOnly(_phoneController.text);
    final canContinue = phoneDigits.length >= 10;

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                debugPrint('⬅️ [CreateAccountPhoneScreen] back pressed');
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

                        const SizedBox(height: 24),

                        // Phone Number Input with Country Code
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CountryCodePicker(
                              initialCountryCode: _countryCode,
                              onChanged: (dialCode) {
                                debugPrint(
                                  '🌍 [CreateAccountPhoneScreen] countryCode changed: $dialCode',
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
                                onChanged: (value) {
                                  debugPrint(
                                    '📞 [CreateAccountPhoneScreen] phone changed: "$value" (digits=${PhoneNumberFormatter.getDigitsOnly(value)})',
                                  );
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'We will send you verification code.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),

                        const Spacer(),

                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom > 0 ? 24 : 0,
                        ),

                        PrimaryButton(
                          label: 'Continue',
                          onPressed: canContinue ? _onContinue : null,
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(color: AppColors.textPrimary),
                            ),
                            GestureDetector(
                              onTap: () {
                                debugPrint('🔁 [CreateAccountPhoneScreen] Log In pressed');
                                _dismissKeyboard();
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Log In',
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
