import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/app/core/extensions/task_priority_x.dart';
import 'package:todo_app/app/features/task/data/models/task/task_model.dart';

import '../../../../config/theme/color_theme.dart';
import '../../../../core/errors/error_dialog.dart';
import '../../../../core/utils/format_date.dart';
import '../../../../core/utils/format_time.dart';
import '../../../../core/utils/pick_date.dart';
import '../../../../core/utils/pick_time.dart';
import '../../../../shared/enums/task_priority.dart';
import '../../../../shared/providers.dart';
import '../../../../shared/widgets/app_button.dart';
import '../notifiers/edit_task_notifier.dart';
import 'widgets/warning_dialog.dart';

class EditTaskView extends HookConsumerWidget {
  const EditTaskView({super.key, required this.task});

  final TaskModel task; // The task to be edited, passed as a parameter

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAllDay = task.scheduledDate == null;
    final selectedIndex = useState<int>(isAllDay ? 0 : 1);
    final formKey = useRef(GlobalKey<FormState>());
    final state = ref.watch(editTaskNotifierProvider);
    final notifier = ref.read(editTaskNotifierProvider.notifier);
    final titleController = useTextEditingController(text: task.title);
    final descriptionController = useTextEditingController(
      text: task.description,
    );
    final scheduledDate = useState<DateTime?>(task.scheduledDate?.toLocal());
    final scheduledTime = useState<TimeOfDay?>(task.scheduledTime);
    final priority = useState<TaskPriority>(task.priority);

    final focusNode1 = useFocusNode();
    final focusNode2 = useFocusNode();

    // Track changes
    final hasChanges = useState(false);

    //Shift the main content page for animation
    void shiftContent() {
      ref.read(contentShiftedStateProvider.notifier).state = false;
    }

    void goBack() {
      shiftContent();
      context.pop(); //Return to task list screen.
    }

    // Checks if any task fields have changed to enable/disable the update button
    void checkForChanges() {
      final dateChanged = selectedIndex.value == 0
          ? scheduledDate.value != null
          : selectedIndex.value == 1
          ? scheduledDate.value != task.scheduledDate
          : false;
      hasChanges.value =
          titleController.text != task.title ||
          descriptionController.text != task.description ||
          priority.value != task.priority ||
          dateChanged ||
          scheduledTime.value != task.scheduledTime;
    }

    // Add listeners to text controllers to detect changes
    titleController.addListener(checkForChanges);
    descriptionController.addListener(checkForChanges);

    // Listen for state changes in the edit task notifier
    ref.listen<AsyncValue<void>>(editTaskNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          // On successful update, pop the screen, reset content shift, and show a success message
          goBack();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Task updated successfully")),
          );
        },
        error: (error, _) {
          // On error, show an error dialog
          ErrorDialog.show(context: context, content: error.toString());
        },
      );
    });

    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Form(
              key: formKey.value,
              child: Column(
                children: [
                  Gap(75),
                  //Task priority selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: TaskPriority.values.asMap().entries.map((
                            e,
                          ) {
                            final index = e.key;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  priority.value = e.value;
                                  checkForChanges();
                                },
                                child: Container(
                                  margin: index < TaskPriority.values.length - 1
                                      ? const EdgeInsets.only(right: 10)
                                      : null,
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: priority.value == e.value
                                        ? Border.all(width: 1.5)
                                        : null,
                                  ),
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: e.value.color,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const Gap(16),
                        TextFormField(
                          //autofocus: true,
                          controller: titleController,
                          focusNode: focusNode1,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -.41,
                            inherit: true,
                          ),
                          onTapOutside: (event) => focusNode1.unfocus(),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Task title",

                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Name is required";
                            }
                            return null;
                          },
                        ),

                        TextFormField(
                          focusNode: focusNode2,
                          controller: descriptionController,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0,
                          ),
                          maxLines:
                              (MediaQuery.sizeOf(context).height /
                                      (MediaQuery.viewInsetsOf(
                                                context,
                                              ).bottom ==
                                              0
                                          ? 55
                                          : 105))
                                  .truncate(),
                          minLines: 1,
                          onTapOutside: (event) => focusNode2.unfocus(),

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Describe your task",

                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Description is required";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 16,
                        runSpacing: 10,
                        children: [
                          GestureDetector(
                            onTap: () {
                              pickTime(context).then((time) {
                                if (time != null) {
                                  scheduledTime.value = time;
                                  scheduledDate.value = null;
                                  selectedIndex.value = 0;
                                  checkForChanges();
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.grey1,
                                borderRadius: BorderRadius.circular(10),
                                border: selectedIndex.value == 0
                                    ? Border.all()
                                    : null,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 15,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Ionicons.time, size: 15),
                                  const Gap(5),
                                  Text(
                                    "All day${selectedIndex.value == 0 && scheduledTime.value != null ? " ${formatTime(context, scheduledTime.value)}" : ""}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              pickDate(context).then((date) async {
                                if (date != null) {
                                  if (!context.mounted) return;
                                  final time = await pickTime(context);
                                  if (time != null) {
                                    scheduledDate.value = date;
                                    scheduledTime.value = time;
                                    selectedIndex.value = 1;
                                    checkForChanges();
                                  }
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.grey1,
                                borderRadius: BorderRadius.circular(10),
                                border: selectedIndex.value == 1
                                    ? Border.all()
                                    : null,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 15,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Gap(5),
                                  Text(
                                    (scheduledDate.value == null &&
                                                scheduledTime.value == null) ||
                                            selectedIndex.value != 1
                                        ? "Reminder"
                                        : "${formatDate(scheduledDate.value!)} ${formatTime(context, scheduledTime.value)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AppButton(
                      isLoading: state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      ),
                      label: "Update task",
                      isDisabled: !hasChanges.value,
                      onTap: () async {
                        // Validate form and check if changes exist
                        if (formKey.value.currentState!.validate() &&
                            hasChanges.value) {
                          // Determine scheduled date
                          final date = selectedIndex.value == 0
                              ? null
                              : scheduledDate.value;

                          // Ensure scheduledTime is not null
                          final time = scheduledTime.value;
                          if (time == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a time'),
                              ),
                            );
                            return;
                          }

                          final proceed = await WarningDialog.show(
                            context: context,
                            content: "You want to keep modifications ?",
                          );
                          if (proceed) {
                            // Edit task
                            await notifier.editTask(
                              task.copyWith(
                                title: titleController.text,
                                description: descriptionController.text,
                                priority: priority.value,
                                scheduledDate: date,
                                scheduledTime: time,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Back button
                    IconButton(
                      onPressed: goBack,
                      icon: SizedBox(
                        height: 50,
                        width: 50,
                        child: Icon(CupertinoIcons.back),
                      ),
                    ),
                    //Button to hide keyboard
                    if (MediaQuery.viewInsetsOf(context).bottom != 0)
                      IconButton(
                        onPressed: () {
                          focusNode1.unfocus();
                          focusNode2.unfocus();
                          FocusScope.of(context).unfocus();
                        },
                        icon: SizedBox(
                          height: 50,
                          width: 50,
                          child: Icon(
                            CupertinoIcons.keyboard_chevron_compact_down,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
