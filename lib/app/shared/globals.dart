import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';

// Global provider container for dependency injection
final container = ProviderContainer();

// Logger instance for debugging and logging
var logger = Logger();

// UUID generator for unique identifiers
final uuid = Uuid();

// Boolean flag to check if the platform is iOS
final bool isIOS = Platform.isIOS;

// Database instance for Drift (to be initialized later)
late final AppDatabase drift;

// Global navigator keys for routing
final rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
); // Root navigator key
final taskNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'taskTab',
); // Task tab navigator key
final settingNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'settingTab',
); // Settings tab navigator key
