import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/progress_indicator.dart';

/// Base scaffold for form screens with common patterns
/// Includes: AppBar with back button, Progress indicator, Title, Subtitle
class BaseFormScreen extends StatelessWidget {
  const BaseFormScreen({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.currentStep,
    this.totalSteps,
    this.onBack,
    this.backgroundColor,
    this.bottomNavigationBar,
  });

  final String title;
  final String? subtitle;
  final int? currentStep;
  final int? totalSteps;
  final List<Widget> children;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('BaseFormScreen', 'build', {'title': title});

    SystemUIHelper.setLightStatusBar();

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.cfiBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.labelBlack),
          onPressed: () {
            DebugLogger.log('BaseFormScreen', 'back pressed');
            if (onBack != null) {
              onBack!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
          child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 32,
            right: 32,
            bottom: bottomNavigationBar != null
                ? 24 + MediaQuery.of(context).viewPadding.bottom
                : 0,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 600, // Max width for centering on larger screens
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            const SizedBox(height: 10),

            // Progress indicator
            if (currentStep != null && totalSteps != null)
              Padding(
                padding: const EdgeInsets.only(left: 34),
                child: ProgressIndicator(
                  currentStep: currentStep!,
                  totalSteps: totalSteps!,
                ),
              ),

            if (currentStep != null && totalSteps != null)
              const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.labelBlack,
                height: 32 / 28,
              ),
            ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: AppColors.labelBlack60,
                  height: 16 / 12,
                ),
              ),
            ],

            const SizedBox(height: 40),

            // Form fields
            ...children,
          ],
        ),
      ),
      ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
