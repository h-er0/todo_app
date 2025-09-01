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
import 'package:todo_app/app/features/task/presentation/notifiers/edit_task_notifier.dart';
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

// Mock TaskRepositoryImpl
class MockTaskRepositoryImpl extends Mock implements TaskRepositoryImpl {}

// Mock TaskLocalDataSource
class MockTaskLocalDataSource extends Mock implements TaskLocalDataSource {}

// Mock TableManager for drift.managers.tasks
class MockTasksManager extends Mock {
  Future<void> update(Function(dynamic) updates);
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
  late MockTaskRepositoryImpl mockRepository;
  late MockTaskLocalDataSource mockLocalDataSource;
  late MockTasksManager mockTasksManager;
  late ProviderContainer container;

  setUpAll(() {
    // Register fallback value for TaskModel
    registerFallbackValue(FakeTaskModel());
  });

  setUp(() {
    // Initialize mocks
    mockRepository = MockTaskRepositoryImpl();
    mockLocalDataSource = MockTaskLocalDataSource();
    mockTasksManager = MockTasksManager();

    // Setup drift.managers.tasks as the mock
    drift = MockDriftManagers(tasks: mockTasksManager);

    // Mock successful task update
    when(() => mockTasksManager.update(any())).thenAnswer((_) async {});
    when(() => mockLocalDataSource.editTask(any())).thenAnswer((_) async {});
    when(() => mockRepository.editTask(any())).thenAnswer((_) async {
      log('MockTaskRepositoryImpl.editTask called');
    });

    // Create a ProviderContainer with overridden providers
    container = ProviderContainer(
      overrides: [
        taskRepositoryProvider.overrideWithValue(mockRepository),
        taskListNotifierProvider.overrideWith(() => MockTaskListNotifier()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('EditTaskNotifier', () {
    test('build initializes state to AsyncData<void>', () async {
      // Read the notifier to trigger build
      final state = container.read(editTaskNotifierProvider);

      // Verify state
      expect(
        state,
        const AsyncData<void>(null),
        reason: 'Initial state should be AsyncData<void>',
      );
    });

    test(
      'editTask updates task and invalidates taskListNotifierProvider',
      () async {
        final notifier = container.read(editTaskNotifierProvider.notifier);
        final taskListNotifier =
            container.read(taskListNotifierProvider.notifier)
                as MockTaskListNotifier;
        final task = TaskModel(
          id: '1',
          title: 'Updated Task',
          description: 'Updated Description',
          isComplete: false,
          createdAt: DateTime.now(),
          scheduledDate: DateTime(2025, 9, 1),
          scheduledTime: const TimeOfDay(hour: 14, minute: 30),
          priority: TaskPriority.high,
        );

        // Trigger initial build of taskListNotifier
        final initialBuildCount = taskListNotifier.buildCallCount;
        await container.read(taskListNotifierProvider.future);

        // Call editTask
        await notifier.editTask(task);

        // Verify state transitions
        expect(
          container.read(editTaskNotifierProvider),
          const AsyncData<void>(null),
          reason: 'State should be AsyncData<void> after successful edit',
        );

        // Verify repository.editTask was called with correct TaskModel
        verify(
          () => mockRepository.editTask(
            any<TaskModel>(
              that: isA<TaskModel>()
                  .having((t) => t.id, 'id', task.id)
                  .having((t) => t.title, 'title', task.title)
                  .having((t) => t.description, 'description', task.description)
                  .having((t) => t.priority, 'priority', task.priority)
                  .having(
                    (t) => t.scheduledDate,
                    'scheduledDate',
                    task.scheduledDate,
                  )
                  .having(
                    (t) => t.scheduledTime,
                    'scheduledTime',
                    task.scheduledTime,
                  )
                  .having((t) => t.isComplete, 'isComplete', task.isComplete),
            ),
          ),
        ).called(1);

        // Wait for invalidation to trigger rebuild
        await container.read(taskListNotifierProvider.future);

        // Verify taskListNotifierProvider was invalidated (build called again)
        expect(
          taskListNotifier.buildCallCount,
          greaterThan(initialBuildCount),
          reason: 'taskListNotifierProvider should rebuild after invalidation',
        );

        // Verify taskListNotifierProvider state
        expect(
          container.read(taskListNotifierProvider).value,
          [],
          reason:
              'taskListNotifierProvider state should be an empty list after rebuild',
        );
      },
    );

    test('editTask handles errors correctly', () async {
      // Simulate a database error
      when(
        () => mockTasksManager.update(any()),
      ).thenThrow('Failed to update task');
      when(
        () => mockLocalDataSource.editTask(any()),
      ).thenThrow('Failed to update task');
      when(
        () => mockRepository.editTask(any()),
      ).thenThrow('Failed to update task');

      final notifier = container.read(editTaskNotifierProvider.notifier);
      final task = TaskModel(
        id: '1',
        title: 'Updated Task',
        description: 'Updated Description',
        isComplete: false,
        createdAt: DateTime.now(),
        scheduledDate: null,
        scheduledTime: const TimeOfDay(hour: 10, minute: 0),
        priority: TaskPriority.medium,
      );

      // Call editTask
      await notifier.editTask(task);

      // Verify state is AsyncError
      expect(
        container.read(editTaskNotifierProvider),
        isA<AsyncError<void>>().having(
          (e) => e.error,
          'error',
          'Failed to update task',
        ),
        reason: 'State should be AsyncError on failure',
      );

      // Verify repository.editTask was called
      verify(() => mockRepository.editTask(any())).called(1);
    });
  });
}

// Mock drift.managers
class MockDriftManagers {
  final MockTasksManager tasks;
  MockDriftManagers({required this.tasks});
}

late MockDriftManagers drift;
