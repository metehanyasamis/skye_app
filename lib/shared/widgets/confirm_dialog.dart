import 'package:flutter/material.dart';

import 'package:skye_app/shared/theme/app_colors.dart';

/// Çıkış yap, hesabı sil vb. işlemler için ortak onay diyaloğu.
///
/// Örnek:
/// ```dart
/// await ConfirmDialog.show(
///   context,
///   title: 'Çıkış yap',
///   message: 'Çıkış yapmak istediğinize emin misiniz?',
///   confirmLabel: 'Çıkış yap',
///   onConfirm: () async {
///     await AuthService.instance.logout();
///     if (context.mounted) Navigator.pushNamedAndRemoveUntil(...);
///   },
/// );
/// ```
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelLabel = 'İptal',
    required this.confirmLabel,
    this.confirmIsDestructive = false,
    required this.onConfirm,
  });

  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final bool confirmIsDestructive;
  final VoidCallback onConfirm;

  /// Diyaloğu gösterir. [onConfirm] sonrası pop yapılmaz; çağıran yapabilir.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String cancelLabel = 'İptal',
    required String confirmLabel,
    bool confirmIsDestructive = false,
    required VoidCallback onConfirm,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        confirmIsDestructive: confirmIsDestructive,
        onConfirm: () {
          Navigator.of(context).pop();
          onConfirm();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.labelBlack,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.grayDark,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            cancelLabel,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.grayPrimary,
            ),
          ),
        ),
        FilledButton(
          onPressed: onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: confirmIsDestructive ? Colors.red : AppColors.navy800,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
