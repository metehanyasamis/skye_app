import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';

/// About App - uygulama versiyonu
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  static const routeName = '/profile/about-app';

  @override
  Widget build(BuildContext context) {
    debugPrint('ℹ️ [AboutAppScreen] build()');
    SystemUIHelper.setLightStatusBar();

    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final appVersion = args?['app_version'] as String?;
    final version = appVersion ?? '1.0.0+1';

    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.labelBlack),
          onPressed: () {
            debugPrint('⬅️ [AboutAppScreen] Back pressed');
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'About App',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.labelBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'App Version',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGray,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                version,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.labelBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
