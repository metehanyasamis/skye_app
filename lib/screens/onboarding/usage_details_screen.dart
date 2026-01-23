import 'package:flutter/material.dart';
import 'package:skye_app/screens/home/home_screen.dart';
import 'package:skye_app/widgets/app_text_field.dart';
import 'package:skye_app/widgets/primary_button.dart';
import 'package:skye_app/widgets/skye_background.dart';
import 'package:skye_app/widgets/skye_logo.dart';

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
    debugPrint('🧩 [UsageDetailsScreen] didChangeDependencies');

    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _userData = args;

    debugPrint('📦 [UsageDetailsScreen] userData=$_userData');
  }

  @override
  void dispose() {
    debugPrint('🧹 [UsageDetailsScreen] dispose');
    _planToUseController.dispose();
    _positionController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    debugPrint('⌨️ [UsageDetailsScreen] dismissKeyboard');
    FocusScope.of(context).unfocus();
  }

  Future<void> _onContinue() async {
    debugPrint('➡️ [UsageDetailsScreen] Continue tapped');

    _dismissKeyboard();

    // Prepare data for backend
    final _signupData = {
      'phone': _userData?['phone'] ?? '',
      'firstName': _userData?['firstName'] ?? '',
      'lastName': _userData?['lastName'] ?? '',
      'dateOfBirth': _userData?['dateOfBirth'] ?? '',
      'email': _userData?['email'] ?? '',
      'planToUse': _planToUseController.text.trim(),
      'position': _positionController.text.trim(),
      'goals': _goalsController.text.trim(),
    };

    debugPrint('🧾 [UsageDetailsScreen] signupData prepared: $_signupData');

    // Simulate API call
    debugPrint('⏳ [UsageDetailsScreen] simulate API call...');
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) {
      debugPrint('⚠️ [UsageDetailsScreen] not mounted after delay');
      return;
    }

    debugPrint('🏁 [UsageDetailsScreen] success -> navigate Home');
    Navigator.of(context).pushNamedAndRemoveUntil(
      HomeScreen.routeName,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧱 [UsageDetailsScreen] build');

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                        // Skye Logo (no back button on this screen)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: SkyeLogo(
                              type: 'logoText',
                              color: 'white',
                              height: 150,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // How do you plan to use Skye?
                        AppTextField(
                          controller: _planToUseController,
                          label: 'How do you plan to use Skye?',
                          hint: 'Enter your answer',
                          minLines: 2,
                          maxLines: null,
                          onChanged: (value) {
                            debugPrint(
                                '✍️ [UsageDetailsScreen] planToUse changed');
                            setState(() {});
                          },
                        ),

                        const SizedBox(height: 26),

                        // What best defines your position in aviation?
                        AppTextField(
                          controller: _positionController,
                          label:
                          'What best defines your position in aviation?',
                          hint: 'Enter your answer',
                          minLines: 2,
                          maxLines: null,
                          onChanged: (value) {
                            debugPrint(
                                '✍️ [UsageDetailsScreen] position changed');
                            setState(() {});
                          },
                        ),

                        const SizedBox(height: 26),

                        // How can Skye help you reach your flying goals?
                        AppTextField(
                          controller: _goalsController,
                          label:
                          'How can Skye help you reach your flying goals?',
                          hint: 'Enter your answer',
                          minLines: 2,
                          maxLines: null,
                          onChanged: (value) {
                            debugPrint(
                                '✍️ [UsageDetailsScreen] goals changed');
                            setState(() {});
                          },
                        ),

                        const Spacer(),

                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom > 0
                              ? 24
                              : 0,
                        ),

                        PrimaryButton(
                          label: 'Continue',
                          onPressed: _onContinue,
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
    );
  }
}
