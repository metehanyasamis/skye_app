import 'package:flutter/material.dart';
import 'package:skye_app/utils/system_ui_helper.dart';

import 'package:skye_app/screens/home/home_screen.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/widgets/primary_button.dart';

class CfiInReviewScreen extends StatelessWidget {
  const CfiInReviewScreen({super.key});

  static const routeName = '/cfi/in-review';

  @override
  Widget build(BuildContext context) {
    debugPrint('🧩 [CfiInReviewScreen] build()');

    SystemUIHelper.setLightStatusBar();
    debugPrint('✅ [CfiInReviewScreen] SystemChrome.setSystemUIOverlayStyle applied');

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.labelBlack),
          onPressed: () {
            debugPrint('⬅️ [CfiInReviewScreen] Back pressed -> pop()');
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Title with search icon
            Builder(
              builder: (context) {
                debugPrint('🧾 [CfiInReviewScreen] Title row built');
                return Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'In review',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.labelBlack,
                          height: 32 / 28,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: AppColors.labelBlack,
                        size: 34,
                      ),
                      onPressed: () {
                        debugPrint('🔎 [CfiInReviewScreen] Search pressed');
                        // TODO: Implement search functionality
                      },
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Your application has been received',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: AppColors.labelBlack60,
                height: 16 / 12,
              ),
            ),

            const SizedBox(height: 40),

            // Central icon
            Builder(
              builder: (context) {
                debugPrint('💎 [CfiInReviewScreen] Center icon built');
                return Center(
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.sky100,
                    ),
                    child: const Icon(
                      Icons.diamond,
                      size: 42,
                      color: AppColors.labelBlack,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Description text
            Builder(
              builder: (context) {
                debugPrint('📝 [CfiInReviewScreen] Description built');
                return Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: AppColors.labelBlack60,
                        height: 26 / 16,
                      ),
                      children: [
                        TextSpan(
                          text:
                          'At this stage, your identity and license information will be verified. Once your application is approved, you\'ll receive a ',
                        ),
                        TextSpan(
                          text: 'notification',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.labelBlack,
                          ),
                        ),
                        TextSpan(
                          text: ', and you can then purchase your ',
                        ),
                        TextSpan(
                          text: 'premium package',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.labelBlack,
                          ),
                        ),
                        TextSpan(
                          text: ' and begin listing.',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 60),

            // Go To Homepage button
            Builder(
              builder: (context) {
                debugPrint('🏠 [CfiInReviewScreen] Go To Homepage button built');
                return PrimaryButton(
                  label: 'Go To Homepage',
                  onPressed: () {
                    debugPrint('🏠 [CfiInReviewScreen] Go To Homepage pressed');
                    Navigator.of(context).pushReplacementNamed(
                      HomeScreen.routeName,
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
