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
    this.headerBackgroundColor,
    this.headerImagePath,
    this.bottomNavigationBar,
  });

  final String title;
  final String? subtitle;
  final int? currentStep;
  final int? totalSteps;
  final List<Widget> children;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  /// When set, the top section (back button, progress, title, subtitle) uses this background.
  final Color? headerBackgroundColor;
  /// Optional image to show to the right of the title (e.g. cfi_headPic.png). Zero spacing.
  final String? headerImagePath;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('BaseFormScreen', 'build', {'title': title});

    final useDarkHeader = headerBackgroundColor != null;
    if (useDarkHeader) {
      SystemUIHelper.setDarkStatusBar();
    } else {
      SystemUIHelper.setLightStatusBar();
    }
    final _buildHeaderContentNoProgress = () => Stack(
      clipBehavior: Clip.none,
      children: [
        // 🔵 Watermark image (background hissi)
        if (headerImagePath != null && useDarkHeader)
          Positioned(
            right: -60,   // daha sağa yasla
            top: -50,     // daha yukarı taşı
            child: IgnorePointer(
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  AppColors.offWhite,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  headerImagePath!,
                  width: 200,   // daha büyük
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

        // 🔵 Text block
        Padding(
          padding: EdgeInsets.only(
            right: headerImagePath != null && useDarkHeader ? 140 : 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: useDarkHeader
                      ? AppColors.white
                      : AppColors.labelBlack,
                  height: 32 / 28,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: useDarkHeader
                        ? AppColors.white.withValues(alpha: 0.8)
                        : AppColors.labelBlack60,
                    height: 16 / 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );


    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.cfiBackground,
      appBar: useDarkHeader
          ? null
          : AppBar(
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
      body: useDarkHeader
          ? GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    color: headerBackgroundColor,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 14,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 48,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                                  Positioned(
                                    left: 32,
                                    top: 0,
                                    bottom: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        DebugLogger.log('BaseFormScreen', 'back pressed');
                                        if (onBack != null) {
                                          onBack!();
                                        } else {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          color: AppColors.white,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (currentStep != null && totalSteps != null)
                                    SizedBox(
                                      width: double.infinity,
                                      child: Center(
                                        child: ProgressIndicator(
                                          currentStep: currentStep!,
                                          totalSteps: totalSteps!,
                                          activeColor: AppColors.white,
                                          inactiveColor: AppColors.white.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32),
                          child: _buildHeaderContentNoProgress(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: backgroundColor ?? AppColors.cfiBackground,
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
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: children,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
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
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        if (currentStep != null && totalSteps != null)
                          SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: ProgressIndicator(
                                currentStep: currentStep!,
                                totalSteps: totalSteps!,
                              ),
                            ),
                          ),
                        if (currentStep != null && totalSteps != null)
                          const SizedBox(height: 20),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.labelBlack,
                            height: 32 / 28,
                          ),
                        ),
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
