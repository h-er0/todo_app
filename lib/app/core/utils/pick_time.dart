import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/app/shared/globals.dart';

Future<TimeOfDay?> pickTime(BuildContext context) async {
  // Check if the platform is iOS or macOS
  if (isIOS) {
    return _showCupertinoTimePicker(context);
  } else {
    // Default to Material TimePicker for Android and other platforms
    return showTimePicker(context: context, initialTime: TimeOfDay.now());
  }
}

// Function to show Cupertino Time Picker
Future<TimeOfDay?> _showCupertinoTimePicker(BuildContext context) async {
  TimeOfDay? selectedTime;

  // Show the Cupertino timer picker in a modal bottom sheet
  await showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 300,
        color: CupertinoColors.white,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms, // Hour, minute, second

                  onTimerDurationChanged: (Duration newDuration) {
                    selectedTime = TimeOfDay(
                      hour: newDuration.inHours % 24,
                      minute: newDuration.inMinutes % 60,
                    );
                  },
                ),
              ),
              // Optional: Add a "Done" button to close the picker
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );

  return selectedTime;
}
