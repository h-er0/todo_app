import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo_app/app/features/setting/presentation/notifiers/setting_notifier.dart';
import 'package:todo_app/app/shared/globals.dart';

import '../../../../../shared/widgets/app_button.dart';

/// A reusable warning dialog widget.
///
/// Displays a dialog with a title, optional content, and "Continue" / "Cancel" buttons.
/// Returns `true` if the user confirms the action, `false` otherwise.
class WarningDialog {
  static Future<bool> show({
    required BuildContext context,
    String title = 'Warning',
    String? content = 'Are you sure that you want to continue this action ?',
  }) async {
    logger.d(
      "ask before action ${container.read(settingNotifierProvider).value?.askBeforeAction}",
    );
    // Skip dialog and return true if askBeforeAction is disable

    if (container.read(settingNotifierProvider).value?.askBeforeAction ==
        false) {
      return true;
    } else {
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: true, // Allow tapping outside to dismiss

        builder: (dialogContext) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(dialogContext).pop(false),
                    child: const Icon(Icons.close, color: Colors.grey),
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Gap(12),
                Text(
                  content!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                Gap(30),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: "Continue",
                    onTap: () {
                      Navigator.of(dialogContext).pop(true);
                    },
                  ),
                ),
                Gap(10),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ),
      );
      return result ?? false;
    }
  }
}
