// lib/screens/onboarding/personal_information_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:skye_app/screens/onboarding/usage_details_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/date_picker_helper.dart';
import 'package:skye_app/widgets/app_text_field.dart';
import 'package:skye_app/widgets/base_scaffold.dart';
import 'package:skye_app/widgets/primary_button.dart';
import 'package:skye_app/widgets/skye_background.dart';
import 'package:skye_app/widgets/skye_logo.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  static const routeName = '/personal-information';

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  DateTime? _selectedDate;
  String? _phoneNumber;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('🧩 [PersonalInformationScreen] didChangeDependencies');

    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _phoneNumber = args?['phone'] as String?;
    debugPrint('📞 [PersonalInformationScreen] phone=$_phoneNumber');
  }

  @override
  void dispose() {
    debugPrint('🧹 [PersonalInformationScreen] dispose');
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    debugPrint('⌨️ [PersonalInformationScreen] dismissKeyboard');
    FocusScope.of(context).unfocus();
  }

  Future<void> _selectDate() async {
    debugPrint('📅 [PersonalInformationScreen] selectDate opened');

    final DateTime? picked = await DatePickerHelper.showThemedDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      debugPrint('✅ [PersonalInformationScreen] date picked: $picked');
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
      return;
    }

    debugPrint('⚠️ [PersonalInformationScreen] date picking cancelled');
  }

  bool _isFormValid() {
    final firstNameValid = _firstNameController.text.trim().isNotEmpty;
    final lastNameValid = _lastNameController.text.trim().isNotEmpty;

    final emailValid = _emailController.text.trim().isNotEmpty &&
        _emailController.text.contains('@');

    final passwordValid = _passwordController.text.trim().isNotEmpty &&
        _passwordController.text.length >= 6;

    final confirmPasswordValid =
        _confirmPasswordController.text.trim().isNotEmpty &&
            _passwordController.text == _confirmPasswordController.text;

    final isValid = firstNameValid &&
        lastNameValid &&
        emailValid &&
        passwordValid &&
        confirmPasswordValid;

    debugPrint(
      '🧪 [PersonalInformationScreen] formValid=$isValid '
          '(first=$firstNameValid last=$lastNameValid email=$emailValid pass=$passwordValid confirm=$confirmPasswordValid)',
    );

    return isValid;
  }

  void _onContinue() {
    debugPrint('➡️ [PersonalInformationScreen] Continue tapped');

    if (!_isFormValid()) {
      debugPrint('⛔ [PersonalInformationScreen] form invalid -> blocked');
      return;
    }

    _dismissKeyboard();

    debugPrint('🧾 [PersonalInformationScreen] navigating -> UsageDetails');
    Navigator.of(context).pushNamed(
      UsageDetailsScreen.routeName,
      arguments: {
        'phone': _phoneNumber ?? '',
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'dateOfBirth': _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : '',
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧱 [PersonalInformationScreen] build');

    final topInset = MediaQuery.of(context).padding.top;

    // footer yüksekliği kadar content alt padding bırakıyoruz
    const footerSpace = 180.0;

    return BaseScaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      setDarkStatusBar: true,

      // ✅ FOOTER BaseScaffold'a taşındı
      keyboardAwareBottom: true,
      bottom: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
        child: PrimaryButton(
          label: 'Continue',
          onPressed: _isFormValid() ? _onContinue : null,
        ),
      ),

      // ✅ CONTENT sade: scroll
      child: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.opaque,
        child: SkyeBackground(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, topInset + 10, 24, footerSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        debugPrint('⬅️ [PersonalInformationScreen] back pressed');
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                AppTextField(
                  controller: _firstNameController,
                  label: 'Name *',
                  hint: 'Enter your name',
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: _lastNameController,
                  label: 'Last Name *',
                  hint: 'Enter your last name',
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: _dateOfBirthController,
                      label: 'Date of Birth',
                      hint: 'MM/DD/YYYY',
                      onTap: _selectDate,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: _emailController,
                  label: 'Email *',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: _passwordController,
                  label: 'Password * (minimum 6 characters)',
                  hint: 'Enter your password',
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (_) => setState(() {}),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password *',
                  hint: 'Confirm your password',
                  obscureText: _obscureConfirmPassword,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (_) => setState(() {}),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() =>
                    _obscureConfirmPassword = !_obscureConfirmPassword),
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
