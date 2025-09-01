import 'package:flutter/material.dart';
import 'package:todo_app/app/shared/globals.dart';

//Reusable widget to display loading dialog when completing task
class LoadingDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: isIOS
                  ? EdgeInsets.symmetric(vertical: 50, horizontal: 30)
                  : EdgeInsets.zero,
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
          ),
        ),
      ),
    );
  }
}
