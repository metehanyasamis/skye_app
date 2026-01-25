// lib/screens/onboarding/usage_details_screen.dart
import 'package:flutter/material.dart';

import 'package:skye_app/features/home/home/home_screen.dart';
import 'package:skye_app/shared/services/auth_service.dart';
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

  Future<void> _onContinue() async {
    _dismissKeyboard();

    final signupData = {
      'phone': _userData?['phone'] ?? '',
      'firstName': _userData?['firstName'] ?? '',
      'lastName': _userData?['lastName'] ?? '',
      'dateOfBirth': _userData?['dateOfBirth'] ?? '',
      'email': _userData?['email'] ?? '',
      'planToUse': _planToUseController.text.trim(),
      'position': _positionController.text.trim(),
      'goals': _goalsController.text.trim(),
    };

    debugPrint('🧾 signupData: $signupData');

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    await AuthService.instance.setLoggedIn(true);
    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      HomeScreen.routeName,
      (route) => false,
    );
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
              label: 'Continue',
              onPressed: _onContinue,
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
                    height: 150,
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
                ),
                const SizedBox(height: 24),

                AppTextField(
                  controller: _positionController,
                  label: 'What best defines your position in aviation?',
                  hint: 'Enter your answer',
                  minLines: 2,
                  maxLines: null,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),

                AppTextField(
                  controller: _goalsController,
                  label: 'How can Skye help you reach your flying goals?',
                  hint: 'Enter your answer',
                  minLines: 2,
                  maxLines: null,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
