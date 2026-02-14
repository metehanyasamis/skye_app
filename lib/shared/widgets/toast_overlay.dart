import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Toast overlay: 2 second display, dismiss on tap outside.
/// Use instead of ScaffoldMessenger.showSnackBar for error/feedback messages.
class ToastOverlay {
  ToastOverlay._();

  static OverlayEntry? _currentEntry;
  static Timer? _timer;

  /// Show a toast message. Auto-dismisses after 2 seconds or on tap outside.
  static void show(BuildContext context, String message, {bool isError = true}) {
    debugPrint('🍞 [ToastOverlay] show: $message');

    _timer?.cancel();
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    void dismiss() {
      _timer?.cancel();
      _timer = null;
      entry.remove();
      _currentEntry = null;
      debugPrint('🍞 [ToastOverlay] dismissed');
    }

    entry = OverlayEntry(
      builder: (ctx) => GestureDetector(
        onTap: dismiss,
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(ctx).padding.bottom + 80,
          ),
          child: IgnorePointer(
            child: Material(
              color: isError
                  ? AppColors.labelBlack.withValues(alpha: 0.92)
                  : AppColors.navy800.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(12),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    _timer = Timer(const Duration(seconds: 2), () {
      if (_currentEntry == entry) {
        dismiss();
      }
    });
  }
}
