// lib/screens/onboarding/usage_details_screen.dart
import 'package:flutter/material.dart';

import 'package:skye_app/features/home/home/home_screen.dart';
import 'package:skye_app/shared/services/auth_api_service.dart';
import 'package:skye_app/shared/services/auth_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/widgets/app_text_field.dart';
import 'package:skye_app/shared/widgets/base_scaffold.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/shared/widgets/skye_background.dart';
import 'package:skye_app/shared/widgets/skye_logo.dart';

class UsageDetailsScreen extends StatefulWidget {
  const UsageDetailsScreen({super.key});

  static const routeName = '/usage-details';

  @override
  State<UsageDetailsScreen> createState() => _UsageDetailsScreenState();
}

class _UsageDetailsScreenState extends State<UsageDetailsScreen> {
  final TextEditingController _planToUseController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _goalsController = TextEditingController();

  Map<String, dynamic>? _userData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _userData = args;
  }

  @override
  void dispose() {
    _planToUseController.dispose();
    _positionController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() => FocusScope.of(context).unfocus();

  bool _isSubmitting = false;

  Future<void> _onContinue() async {
    _dismissKeyboard();

    final phone = _userData?['phone'] ?? '';
    final verificationCode = _userData?['verification_code'] ?? '';
    final firstName = _userData?['firstName'] ?? '';
    final lastName = _userData?['lastName'] ?? '';
    final dateOfBirth = _userData?['dateOfBirth'] ?? '';
    final email = _userData?['email'] ?? '';
    final password = _userData?['password'] ?? '';

    if (phone.isEmpty || verificationCode.isEmpty || firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      debugPrint('❌ [UsageDetailsScreen] missing required fields for completeRegistration');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all required fields in the previous steps')),
        );
      }
      return;
    }

    setState(() => _isSubmitting = true);
    debugPrint('📝 [UsageDetailsScreen] calling completeRegistration: phone=$phone');

    try {
      final result = await AuthApiService.instance.completeRegistration(
        phone: phone,
        verificationCode: verificationCode,
        name: '$firstName $lastName'.trim(),
        email: email,
        password: password,
        passwordConfirmation: password,
        gender: 'other',
        dateOfBirth: dateOfBirth.isNotEmpty ? dateOfBirth : null,
        howPlanToUseSkye: _planToUseController.text.trim().isNotEmpty ? _planToUseController.text.trim() : null,
        aviationPositionDefinition: _positionController.text.trim().isNotEmpty ? _positionController.text.trim() : null,
        howSkyeCanHelp: _goalsController.text.trim().isNotEmpty ? _goalsController.text.trim() : null,
      );

      if (!mounted) return;

      if (result.token != null) {
        debugPrint('✅ [UsageDetailsScreen] registration success, token saved');
        await AuthService.instance.setLoggedIn(true);
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName,
          (route) => false,
        );
      } else {
        debugPrint('⚠️ [UsageDetailsScreen] registration ok but no token');
        await AuthService.instance.setLoggedIn(true);
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName,
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('❌ [UsageDetailsScreen] completeRegistration error: $e');
      if (mounted) {
        final msg = e is ApiError ? e.message : e.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $msg')),
        );
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return BaseScaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      setDarkStatusBar: true,

      // ✅ Footer artık BaseScaffold içinde
      bottom: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              label: _isSubmitting ? 'Creating account...' : 'Continue',
              onPressed: _isSubmitting ? null : _onContinue,
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
      keyboardAwareBottom: true, // ✅ klavye açılırsa footer yukarı çıkar

      // ✅ content sadece içerik (scroll)
      child: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.opaque,
        child: SkyeBackground(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              24,
              topInset + 10,
              24,
              220, // ✅ footer kaplamasın diye sabit alan
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: SkyeLogo(
                    type: 'logoText',
                    color: 'white',
                    height: 36,
                  ),
                ),
                const SizedBox(height: 24),

                AppTextField(
                  controller: _planToUseController,
                  label: 'How do you plan to use Skye?',
                  hint: 'Enter your answer',
                  minLines: 2,
                  maxLines: null,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: AppColors.white, fontSize: 16),
                  labelStyle: const TextStyle(color: AppColors.white, fontSize: 16),
                  hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.6), fontSize: 16),
                  fillColor: AppColors.white.withValues(alpha: 0.12),
                ),
                const SizedBox(height: 24),

                AppTextField(
                  controller: _positionController,
                  label: 'What best defines your position in aviation?',
                  hint: 'Enter your answer',
                  minLines: 2,
                  maxLines: null,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: AppColors.white, fontSize: 16),
                  labelStyle: const TextStyle(color: AppColors.white, fontSize: 16),
                  hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.6), fontSize: 16),
                  fillColor: AppColors.white.withValues(alpha: 0.12),
                ),
                const SizedBox(height: 24),

                AppTextField(
                  controller: _goalsController,
                  label: 'How can Skye help you reach your flying goals?',
                  hint: 'Enter your answer',
                  minLines: 2,
                  maxLines: null,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: AppColors.white, fontSize: 16),
                  labelStyle: const TextStyle(color: AppColors.white, fontSize: 16),
                  hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.6), fontSize: 16),
                  fillColor: AppColors.white.withValues(alpha: 0.12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
