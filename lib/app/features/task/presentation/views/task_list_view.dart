import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/app/config/routes/app_router.dart';
import 'package:todo_app/app/core/extensions/task_priority_x.dart';
import 'package:todo_app/app/core/utils/format_date.dart';
import 'package:todo_app/app/features/task/presentation/notifiers/task_list_notifier.dart';
import 'package:todo_app/app/features/task/presentation/views/widgets/warning_dialog.dart';

import '../../../../shared/globals.dart';
import '../../../../shared/providers.dart';
import '../../../../shared/widgets/custom_checkbox.dart';
import 'widgets/custom_pop_up.dart';

class TaskListView extends HookConsumerWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListState = ref.watch(taskListNotifierProvider);
    final notifier = ref.watch(taskListNotifierProvider.notifier);

    final completing = useState(false);
    final deleting = useState(false);

    final selectedList = useState<List<String>>([]);

    final filterOption = useState(["All", "Completed", "Not completed"]);

    final selectedFilter = useState(filterOption.value.first);

    final selectedDate = useState(DateTime.now());

    // Function to reset content shift (e.g., for keyboard handling)

    void shiftContent() {
      ref.read(contentShiftedStateProvider.notifier).state = true;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            key: ValueKey(1),
            child: taskListState.when(
              loading: () =>
                  Center(child: CircularProgressIndicator.adaptive()),
              data: (tasks) {
                // Filter tasks based on selectedFilter
                final filteredTasks = tasks.where((task) {
                  switch (selectedFilter.value) {
                    case "Completed":
                      return task.isComplete;
                    case "Not completed":
                      return !task.isComplete;
                    case "All":
                    default:
                      return true;
                  }
                }).toList();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: selectedList.value.isEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Today",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -.41,
                                        inherit: true,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTapDown: (details) {
                                        CustomPopupMenu.show(
                                          context,
                                          details.globalPosition,
                                          filterOption.value,
                                          selectedFilter.value,
                                          (value) =>
                                              selectedFilter.value = value,
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            selectedFilter.value,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: -.41,
                                              inherit: true,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Gap(6),
                                          Icon(
                                            Ionicons.chevron_down,
                                            color: Colors.grey,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  formatDate(selectedDate.value),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${selectedList.value.length} selected",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -.41,
                                    inherit: true,
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    selectedList.value = [];
                                  },
                                  child: Text("Cancel"),
                                ),
                              ],
                            ),
                    ),
                    filteredTasks.isNotEmpty
                        ? ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 8,
                            ),
                            shrinkWrap: true,
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              bool isSelected = selectedList.value.contains(
                                tasks[index].id,
                              );

                              final bool disable =
                                  isSelected || tasks[index].isComplete;
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) async {
                                        final proceed = await WarningDialog.show(
                                          context: context,
                                          content:
                                              "Do you want to delete this task ?",
                                        );
                                        if (proceed) {
                                          deleting.value = true;
                                          await notifier.deleteTask(
                                            tasks[index].id,
                                          );
                                          ref.invalidate(
                                            taskListNotifierProvider,
                                          );
                                          deleting.value = false;
                                        }
                                      },
                                      backgroundColor: Colors.red,
                                      borderRadius: BorderRadius.circular(15),
                                      foregroundColor: Colors.white,
                                      icon: Ionicons.trash_bin,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    if (!tasks[index].isComplete) {
                                      context.push(
                                        Routes.taskList + Routes.editTask,
                                        extra: {"task": tasks[index]},
                                      );
                                      shiftContent();
                                    }
                                  },
                                  child: Container(
                                    key: UniqueKey(),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blue.withValues(alpha: .3)
                                          : null,
                                      border: !isSelected
                                          ? Border.all(
                                              color:
                                                  tasks[index].priority.color,
                                            )
                                          : null,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Checkbox
                                        CustomCheckbox(
                                          isSelected: isSelected
                                              ? true
                                              : tasks[index].isComplete,
                                          onChanged: (value) async {
                                            if (!tasks[index].isComplete) {
                                              if (isSelected) {
                                                selectedList.value = [
                                                  ...selectedList.value.where(
                                                    (id) =>
                                                        id != tasks[index].id,
                                                  ),
                                                ];
                                              } else {
                                                selectedList.value = [
                                                  ...selectedList.value,
                                                  tasks[index].id,
                                                ];
                                              }
                                            }
                                          },
                                        ),

                                        const SizedBox(width: 12),

                                        // Main text content
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Date / All Day
                                              Text(
                                                tasks[index].scheduledDate !=
                                                        null
                                                    ? formatDate(
                                                        tasks[index]
                                                            .scheduledDate!
                                                            .toLocal(),
                                                      )
                                                    : "All Day",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: -.41,
                                                  inherit: true,
                                                  color: Colors.grey.shade600,
                                                  decoration: disable
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : null,
                                                  decorationColor: Colors.grey,
                                                ),
                                              ),

                                              // Title
                                              Text(
                                                tasks[index].title,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: disable
                                                      ? Colors.grey.shade600
                                                      : Colors.black,
                                                  decoration: disable
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : null,
                                                  decorationColor: Colors.grey,
                                                ),
                                              ),

                                              // Description
                                              Text(
                                                tasks[index].description,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  decoration: disable
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : null,
                                                  decorationColor: Colors.grey,
                                                  color: disable
                                                      ? Colors.grey.shade600
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Gap(6),
                          )
                        : Expanded(child: Center(child: Text("Empty"))),
                  ],
                );
              },
              error: (error, _) => Center(child: Text(error.toString())),
            ),
          ),

          //Display button to mark selected tasks as complete
          if (selectedList.value.isNotEmpty)
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: () async {
                  final proceed = await WarningDialog.show(
                    context: context,
                    content: "Do you really want to complete all these tasks ?",
                  );
                  if (proceed) {
                    completing.value = true;
                    await notifier.completeAll(selectedList.value);
                    ref.invalidate(taskListNotifierProvider);
                    completing.value = false;
                    selectedList.value = [];
                  }
                },
                child: Container(
                  height: 55,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: completing.value
                        ? CircularProgressIndicator.adaptive(
                            strokeCap: StrokeCap.round,
                            backgroundColor: Colors.white,
                          )
                        : Text(
                            "Complete all",
                            style: TextStyle(
                              fontWeight: isIOS
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 0,
                            ),
                          ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
