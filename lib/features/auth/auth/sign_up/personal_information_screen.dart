import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:skye_app/features/auth/auth/sign_up/usage_details_screen.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/widgets/app_text_field.dart';
import 'package:skye_app/shared/widgets/base_scaffold.dart';
import 'package:skye_app/shared/widgets/date_picker_field.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/shared/widgets/skye_background.dart';
import 'package:skye_app/shared/widgets/skye_logo.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  DateTime? _selectedDate;
  String? _phoneNumber;
  String? _verificationCode;

  String? _firstNameError;
  String? _lastNameError;
  String? _dateError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('🧩 [PersonalInformationScreen] didChangeDependencies');

    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _phoneNumber = args?['phone'] as String?;
    _verificationCode = args?['verification_code'] as String?;
    debugPrint('📞 [PersonalInformationScreen] phone=$_phoneNumber verification_code=${_verificationCode != null ? "***" : "null"}');
  }

  @override
  void dispose() {
    debugPrint('🧹 [PersonalInformationScreen] dispose');
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    debugPrint('⌨️ [PersonalInformationScreen] dismissKeyboard');
    FocusScope.of(context).unfocus();
  }

  bool _validateAndSetErrors() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    _firstNameError = first.isEmpty ? 'İsim girin' : null;
    _lastNameError = last.isEmpty ? 'Soyisim girin' : null;
    _dateError = null;

    if (email.isEmpty) {
      _emailError = 'Email girin';
    } else if (!email.contains('@') || !RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(email)) {
      _emailError = 'Email doğru formatta girin';
    } else {
      _emailError = null;
    }

    if (pass.isEmpty || pass.length < 6) {
      _passwordError = 'Şifre en az 6 karakter olmalı';
    } else {
      _passwordError = null;
    }

    if (confirm.isEmpty) {
      _confirmError = 'Şifre tekrarı girin';
    } else if (pass != confirm) {
      _confirmError = 'Şifreler eşleşmiyor';
    } else {
      _confirmError = null;
    }

    return _firstNameError == null &&
        _lastNameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmError == null;
  }

  void _clearFieldError(String which) {
    switch (which) {
      case 'first':
        _firstNameError = null;
        break;
      case 'last':
        _lastNameError = null;
        break;
      case 'date':
        _dateError = null;
        break;
      case 'email':
        _emailError = null;
        break;
      case 'password':
        _passwordError = null;
        break;
      case 'confirm':
        _confirmError = null;
        break;
    }
  }

  void _onContinue() {
    debugPrint('➡️ [PersonalInformationScreen] Continue tapped');
    if (!_validateAndSetErrors()) {
      setState(() {});
      debugPrint('⛔ [PersonalInformationScreen] form invalid -> errors shown');
      return;
    }
    _dismissKeyboard();
    debugPrint('🧾 [PersonalInformationScreen] navigating -> UsageDetails');
    Navigator.of(context).pushNamed(
      UsageDetailsScreen.routeName,
      arguments: {
        'phone': _phoneNumber ?? '',
        'verification_code': _verificationCode ?? '',
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
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      extendBody: false,
      backgroundColor: Colors.transparent,
      setDarkStatusBar: true,

      keyboardAwareBottom: true,
      bottom: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
        child: PrimaryButton(
          label: 'Continue',
          onPressed: _onContinue,
        ),
      ),

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
                      height: 36,
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
                  errorText: _firstNameError,
                  onChanged: (_) {
                    _clearFieldError('first');
                    setState(() {});
                  },
                  style: const TextStyle(color: AppColors.white, fontSize: 16),
                  labelStyle: const TextStyle(color: AppColors.white, fontSize: 16),
                  hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.6), fontSize: 16),
                  fillColor: AppColors.white.withValues(alpha: 0.12),
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: _lastNameController,
                  label: 'Last Name *',
                  hint: 'Enter your last name',
                  errorText: _lastNameError,
                  onChanged: (_) {
                    _clearFieldError('last');
                    setState(() {});
                  },
                  style: const TextStyle(color: AppColors.white, fontSize: 16),
                  labelStyle: const TextStyle(color: AppColors.white, fontSize: 16),
                  hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.6), fontSize: 16),
                  fillColor: AppColors.white.withValues(alpha: 0.12),
                ),

                const SizedBox(height: 16),

                DatePickerField(
                  style: DatePickerFieldStyle.textField,
                  label: 'Date of Birth',
                  hint: 'MM/DD/YYYY',
                  initialDate:
                      DateTime.now().subtract(const Duration(days: 365 * 18)),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  prefillFromInitialDate: false,
                  onDateChanged: (d) {
                    _dateError = null;
                    setState(() => _selectedDate = d);
                  },
                  darkStyle: true,
                  errorText: _dateError,
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: _emailController,
                  label: 'Email *',
                  hint: 'Enter your email',
                  errorText: _emailError,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) {
                    _clearFieldError('email');
                    setState(() {});
                  },
                  style: const TextStyle(color: AppColors.white, fontSize: 16),
                  labelStyle: const TextStyle(color: AppColors.white, fontSize: 16),
                  hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.6), fontSize: 16),
                  fillColor: AppColors.white.withValues(alpha: 0.12),
                ),

                const SizedBox(height: 16),

                AppTextField(
                  controller: _passwordController,
                  label: 'Password * (minimum 6 characters)',
                  hint: 'Enter your password',
                  errorText: _passwordError,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (_) {
                    _clearFieldError('password');
                    setState(() {});
                  },
                  style: const TextStyle(color: AppColors.white, fontSize: 16),
                  labelStyle: const TextStyle(color: AppColors.white, fontSize: 16),
                  hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.6), fontSize: 16),
                  fillColor: AppColors.white.withValues(alpha: 0.12),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.white,
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
                  errorText: _confirmError,
                  obscureText: _obscureConfirmPassword,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (_) {
                    _clearFieldError('confirm');
                    setState(() {});
                  },
                  style: const TextStyle(color: AppColors.white, fontSize: 16),
                  labelStyle: const TextStyle(color: AppColors.white, fontSize: 16),
                  hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.6), fontSize: 16),
                  fillColor: AppColors.white.withValues(alpha: 0.12),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.white,
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
