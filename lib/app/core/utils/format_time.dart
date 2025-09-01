import 'package:flutter/material.dart';

//Format time of day function
String formatTime(BuildContext context, TimeOfDay? time) {
  return time != null ? time.format(context) : "Select Time";
}
