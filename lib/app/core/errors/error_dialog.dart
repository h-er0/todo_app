import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../shared/widgets/app_button.dart';

//Use this to display error to user
class ErrorDialog {
  static Future<void> show({
    required BuildContext context,
    String title = 'Error',
    String? content = 'An unexpected error occurred. Please try again.',
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Allow tapping outside to dismiss
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(dialogContext).pop(),
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
                  onTap: () async {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
