import 'package:flutter/material.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    required this.child,
    this.bottom,
    this.keyboardAwareBottom = false,
    this.resizeToAvoidBottomInset = false,
    this.extendBodyBehindAppBar = true,
    this.extendBody = true,
    this.backgroundColor,
    this.setDarkStatusBar = false,
    this.bottomOffset = 0,
  });

  final Widget child;

  /// ✅ Optional fixed bottom CTA area
  final Widget? bottom;

  /// ✅ If true => bottom moves up when keyboard opens
  final bool keyboardAwareBottom;

  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final Color? backgroundColor;
  final bool setDarkStatusBar;

  /// ✅ Extra spacing above bottom (button’u yukarı almak için)
  final double bottomOffset;

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('BaseScaffold', 'build');

    if (setDarkStatusBar) {
      SystemUIHelper.setDarkStatusBar();
    } else {
      SystemUIHelper.setLightStatusBar();
    }

    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    final effectiveBottomPadding =
        (keyboardAwareBottom ? (keyboard + bottomInset) : bottomInset) +
            bottomOffset;

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      backgroundColor: backgroundColor ?? Colors.transparent,
      body: bottom == null
          ? child
          : Stack(
        fit: StackFit.expand,
        children: [
          // MAIN CONTENT
          Positioned.fill(child: child),

          // BOTTOM CTA
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: effectiveBottomPadding),
              child: bottom!,
            ),
          ),
        ],
      ),
    );
  }
}
