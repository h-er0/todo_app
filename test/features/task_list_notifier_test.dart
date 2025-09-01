import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/app/features/task/data/data_sources/task_local_data_source.dart';
import 'package:todo_app/app/features/task/data/models/task/task_model.dart';
import 'package:todo_app/app/features/task/data/repository/impl/task_repository_impl.dart';
import 'package:todo_app/app/features/task/presentation/notifiers/task_list_notifier.dart';
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
  Future<void> create(Function(dynamic) updates);
  Future<void> update(Function(dynamic) updates);
  Future<void> delete();
}

void main() {
  late MockTaskRepositoryImpl mockRepository;
  late MockTasksManager mockTasksManager;
  late ProviderContainer container;

  setUpAll(() {
    // Register fallback value for TaskModel
    registerFallbackValue(FakeTaskModel());
  });

  setUp(() {
    // Initialize mocks
    mockRepository = MockTaskRepositoryImpl();
    mockTasksManager = MockTasksManager();

    // Setup drift.managers.tasks as the mock
    drift = MockDriftManagers(tasks: mockTasksManager);

    // Mock repository and data source behavior
    when(() => mockRepository.getTasks()).thenAnswer(
      (_) async => [
        TaskModel(
          id: '1',
          title: 'Test Task',
          description: 'Test Description',
          isComplete: false,
          createdAt: DateTime.now(),
          scheduledDate: null,
          scheduledTime: const TimeOfDay(hour: 10, minute: 0),
          priority: TaskPriority.low,
        ),
      ],
    );
    when(() => mockRepository.completeAll(any())).thenAnswer((_) async {});
    when(() => mockRepository.deleteTask(any())).thenAnswer((_) async {});
    when(() => mockTasksManager.create(any())).thenAnswer((_) async {});

    // Create a ProviderContainer with overridden providers
    container = ProviderContainer(
      overrides: [
        taskRepositoryProvider.overrideWithValue(mockRepository),
        taskListNotifierProvider.overrideWith(() => TaskListNotifier()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TaskListNotifier', () {
    test('build fetches tasks from repository and updates state', () async {
      // Read the notifier to trigger build
      await container.read(taskListNotifierProvider.future);

      // Verify state
      expect(
        container.read(taskListNotifierProvider),
        isA<AsyncData<List<TaskModel>>>()
            .having((s) => s.value.length, 'length', 1)
            .having((s) => s.value[0].title, 'title', 'Test Task'),
      );

      // Verify repository.getTasks was called
      verify(() => mockRepository.getTasks()).called(1);
    });

    test('completeAll calls repository.completeAll with correct IDs', () async {
      final notifier = container.read(taskListNotifierProvider.notifier);
      final ids = ['1', '2'];

      // Call completeAll
      await notifier.completeAll(ids);

      // Verify repository.completeAll was called with correct IDs
      verify(() => mockRepository.completeAll(ids)).called(1);
    });

    test('deleteTask calls repository.deleteTask with correct ID', () async {
      final notifier = container.read(taskListNotifierProvider.notifier);
      const id = '1';

      // Call deleteTask
      await notifier.deleteTask(id);

      // Verify repository.deleteTask was called with correct ID
      verify(() => mockRepository.deleteTask(id)).called(1);
    });

    test('invalidation triggers rebuild and fetches tasks again', () async {
      container.read(taskListNotifierProvider.notifier);

      // Trigger initial build
      await container.read(taskListNotifierProvider.future);

      // Reset mock interaction count
      reset(mockRepository);

      // Mock getTasks to return a different task list
      when(() => mockRepository.getTasks()).thenAnswer(
        (_) async => [
          TaskModel(
            id: '2',
            title: 'New Task',
            description: 'New Description',
            isComplete: false,
            createdAt: DateTime.now(),
            scheduledDate: null,
            scheduledTime: const TimeOfDay(hour: 12, minute: 0),
            priority: TaskPriority.high,
          ),
        ],
      );

      // Invalidate the provider
      container.invalidate(taskListNotifierProvider);

      // Wait for rebuild
      await container.read(taskListNotifierProvider.future);

      // Verify state reflects new tasks
      expect(
        container.read(taskListNotifierProvider),
        isA<AsyncData<List<TaskModel>>>()
            .having((s) => s.value.length, 'length', 1)
            .having((s) => s.value[0].title, 'title', 'New Task'),
      );

      // Verify repository.getTasks was called again
      verify(() => mockRepository.getTasks()).called(1);
    });
  });
}

// Mock drift.managers
class MockDriftManagers {
  final MockTasksManager tasks;
  MockDriftManagers({required this.tasks});
}

late MockDriftManagers drift;
