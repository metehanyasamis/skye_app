import 'package:flutter/material.dart';
import 'package:skye_app/screens/home/home_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
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
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _userData = args;
  }

  @override
  void dispose() {
    _planToUseController.dispose();
    _positionController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Future<void> _onContinue() async {

    _dismissKeyboard();

    // Prepare data for backend
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

    // TODO: Send all data to backend endpoint
    // Example endpoint: POST /api/auth/signup
    // Example implementation:
    // try {
    //   final response = await http.post(
    //     Uri.parse('https://api.skye.app/auth/signup'),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode(signupData),
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

    // Navigate to home after successful signup
    Navigator.of(context).pushNamedAndRemoveUntil(
      HomeScreen.routeName,
      (route) => false,
    );
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
                          // Skye Logo (no back button on this screen)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: SkyeLogo(),
                            ),
                          ),
                          const SizedBox(height: 48),
                          
                          // How do you plan to use Skye?
                          AppTextField(
                            controller: _planToUseController,
                            label: 'How do you plan to use Skye?',
                            hint: 'Enter your answer',
                            minLines: 3,
                            maxLines: null,
                            onChanged: (value) {
                              setState(() {}); // Update button state
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // What best defines your position in aviation?
                          AppTextField(
                            controller: _positionController,
                            label: 'What best defines your position in aviation?',
                            hint: 'Enter your answer',
                            minLines: 3,
                            maxLines: null,
                            onChanged: (value) {
                              setState(() {}); // Update button state
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // How can Skye help you reach your flying goals?
                          AppTextField(
                            controller: _goalsController,
                            label: 'How can Skye help you reach your flying goals?',
                            hint: 'Enter your answer',
                            minLines: 3,
                            maxLines: null,
                            onChanged: (value) {
                              setState(() {}); // Update button state
                            },
                          ),
                          
                          const Spacer(),
                          
                          SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 24 : 0),
                          
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
      ),
    );
  }
}
