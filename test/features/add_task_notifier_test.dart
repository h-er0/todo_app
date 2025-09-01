import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/app/features/task/data/data_sources/task_local_data_source.dart';
import 'package:todo_app/app/features/task/data/models/task/task_model.dart';
import 'package:todo_app/app/features/task/data/repository/impl/task_repository_impl.dart';
import 'package:todo_app/app/features/task/presentation/notifiers/task_list_notifier.dart';
import 'package:todo_app/app/features/task/presentation/notifiers/add_task_notifier.dart';
import 'package:todo_app/app/shared/enums/task_priority.dart';

// Fake TaskModel for mocktail
class FakeTaskModel extends Fake implements TaskModel {
  @override
  String get id => 'fake-id';
  @override
  String get title => 'fake-title';
  @override
  String get description => 'fake-description';
  @override
  bool get isComplete => false;
  @override
  DateTime get createdAt => DateTime.now();
  @override
  DateTime? get scheduledDate => null;
  @override
  TimeOfDay get scheduledTime => const TimeOfDay(hour: 0, minute: 0);
  @override
  TaskPriority get priority => TaskPriority.low;
}

// Mock TaskLocalDataSource
class MockTaskLocalDataSource extends Mock implements TaskLocalDataSource {}

// Mock TableManager for drift.managers.tasks
class MockTasksManager extends Mock {
  Future<void> create(Function(dynamic) updates);
}

// Mock TaskListNotifier
class MockTaskListNotifier extends TaskListNotifier {
  int _buildCallCount = 0;

  @override
  FutureOr<List<TaskModel>> build() async {
    _buildCallCount++;
    log('MockTaskListNotifier.build called: $_buildCallCount');
    return [];
  }

  int get buildCallCount => _buildCallCount;
}

void main() {
  late MockTaskLocalDataSource mockLocalDataSource;
  late MockTasksManager mockTasksManager;
  late ProviderContainer container;

  setUpAll(() {
    // Register fallback value for TaskModel
    registerFallbackValue(FakeTaskModel());
  });

  setUp(() {
    // Initialize mocks
    mockLocalDataSource = MockTaskLocalDataSource();
    mockTasksManager = MockTasksManager();

    // Setup drift.managers.tasks as the mock
    drift = MockDriftManagers(tasks: mockTasksManager);

    // Mock successful task creation
    when(() => mockTasksManager.create(any())).thenAnswer((_) async {});

    // Mock TaskLocalDataSource behavior
    when(() => mockLocalDataSource.addTask(any())).thenAnswer((_) async {});

    // Create a ProviderContainer with overridden providers
    container = ProviderContainer(
      overrides: [
        taskRepositoryProvider.overrideWithValue(
          TaskRepositoryImpl(localDataSource: mockLocalDataSource),
        ),
        taskListNotifierProvider.overrideWith(() => MockTaskListNotifier()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AddTaskNotifier', () {
    test('adds a task and updates state correctly', () async {
      final notifier = container.read(addTaskNotifierProvider.notifier);
      const title = 'Test Task';
      const description = 'Test Description';
      final priority = TaskPriority.high;
      final scheduledDate = DateTime(2025, 9, 1);
      const scheduledTime = TimeOfDay(hour: 14, minute: 30);

      // Call addTask
      await notifier.addTask(
        title,
        description,
        priority,
        scheduledDate,
        scheduledTime,
      );

      // Verify state
      expect(
        container.read(addTaskNotifierProvider),
        const AsyncData<void>(null),
      );

      // Verify TaskLocalDataSource.addTask was called with correct TaskModel
      verify(
        () => mockLocalDataSource.addTask(
          any<TaskModel>(
            that: isA<TaskModel>()
                .having((t) => t.title, 'title', title)
                .having((t) => t.description, 'description', description)
                .having((t) => t.priority, 'priority', priority)
                .having(
                  (t) => t.scheduledDate,
                  'scheduledDate',
                  scheduledDate.toUtc(),
                )
                .having((t) => t.scheduledTime, 'scheduledTime', scheduledTime)
                .having((t) => t.isComplete, 'isComplete', false)
                .having((t) => t.createdAt, 'createdAt', isNotNull)
                .having((t) => t.id, 'id', isNotEmpty),
          ),
        ),
      ).called(1);
    });

    test('handles errors when adding a task', () async {
      // Simulate a database error
      when(
        () => mockTasksManager.create(any()),
      ).thenThrow('Failed to add task');
      when(
        () => mockLocalDataSource.addTask(any()),
      ).thenThrow('Failed to add task');

      final notifier = container.read(addTaskNotifierProvider.notifier);

      // Call addTask
      await notifier.addTask(
        'Test Task',
        'Test Description',
        TaskPriority.medium,
        null,
        const TimeOfDay(hour: 10, minute: 0),
      );

      // Verify state is AsyncError
      expect(
        container.read(addTaskNotifierProvider),
        isA<AsyncError<void>>().having(
          (e) => e.error,
          'error',
          'Failed to add task',
        ),
      );
    });

    test('invalidates taskListNotifierProvider after adding task', () async {
      final notifier = container.read(addTaskNotifierProvider.notifier);
      final taskListNotifier =
          container.read(taskListNotifierProvider.notifier)
              as MockTaskListNotifier;

      // Trigger initial build
      final initialBuildCount = taskListNotifier.buildCallCount;
      await container.read(taskListNotifierProvider.future);

      // Call addTask
      await notifier.addTask(
        'Test Task',
        'Test Description',
        TaskPriority.low,
        null,
        const TimeOfDay(hour: 9, minute: 0),
      );

      // Wait for invalidation to trigger rebuild
      await container.read(taskListNotifierProvider.future);

      // Verify taskListNotifierProvider was invalidated (build called again)
      expect(
        taskListNotifier.buildCallCount,
        greaterThan(initialBuildCount),
        reason: 'taskListNotifierProvider should rebuild after invalidation',
      );

      // Verify the state reflects rebuild
      expect(
        container.read(taskListNotifierProvider).value,
        [],
        reason:
            'taskListNotifierProvider state should be an empty list after rebuild',
      );

      // Verify TaskLocalDataSource.addTask was called
      verify(() => mockLocalDataSource.addTask(any())).called(1);
    });
  });
}

// Mock drift.managers
class MockDriftManagers {
  final MockTasksManager tasks;
  MockDriftManagers({required this.tasks});
}

late MockDriftManagers drift;
