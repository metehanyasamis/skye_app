// lib/screens/onboarding/create_account_phone_screen.dart
import 'package:flutter/material.dart';

import 'package:skye_app/screens/onboarding/create_account_verification_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/phone_number_formatter.dart';
import 'package:skye_app/widgets/app_back_button.dart';
import 'package:skye_app/widgets/app_text_field.dart';
import 'package:skye_app/widgets/base_scaffold.dart';
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
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() => FocusScope.of(context).unfocus();

  void _onContinue() {
    _dismissKeyboard();

    final phoneDigits = PhoneNumberFormatter.getDigitsOnly(_phoneController.text);
    final fullPhone = '$_countryCode$phoneDigits';

    Navigator.of(context).pushNamed(
      CreateAccountVerificationScreen.routeName,
      arguments: {'phone': fullPhone},
    );
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
              label: 'Continue',
              onPressed: canContinue ? _onContinue : null,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                GestureDetector(
                  onTap: () {
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
                      height: 50,
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
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                const Text(
                  'We will send you verification code.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
