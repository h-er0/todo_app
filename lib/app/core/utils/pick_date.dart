import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/app/shared/globals.dart';

Future<DateTime?> pickDate(BuildContext context) async {
  // Check if the platform is iOS or macOS
  if (isIOS) {
    return _showCupertinoDatePicker(context);
  } else {
    // Default to Material DatePicker for Android and other platforms
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
  }
}

// Function to show Cupertino Date Picker
Future<DateTime?> _showCupertinoDatePicker(BuildContext context) async {
  DateTime? selectedDate;

  // Show the Cupertino date picker in a modal bottom sheet
  await showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 250,
        color: CupertinoColors.white,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  minimumYear: 2000,
                  maximumYear: 2101,
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDate = newDate;
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

  return selectedDate;
}
