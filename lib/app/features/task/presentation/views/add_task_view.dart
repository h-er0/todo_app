import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/app/config/theme/color_theme.dart';
import 'package:todo_app/app/core/extensions/task_priority_x.dart';
import 'package:todo_app/app/features/task/presentation/notifiers/add_task_notifier.dart';
import 'package:todo_app/app/shared/widgets/app_button.dart';

import '../../../../core/errors/error_dialog.dart';
import '../../../../core/utils/format_date.dart';
import '../../../../core/utils/format_time.dart';
import '../../../../core/utils/pick_date.dart';
import '../../../../core/utils/pick_time.dart';
import '../../../../shared/enums/task_priority.dart';
import '../../../../shared/providers.dart';

class AddTaskView extends HookConsumerWidget {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState<int?>(null);

    final formKey = useRef(GlobalKey<FormState>());
    final state = ref.watch(addTaskNotifierProvider);
    final notifier = ref.read(addTaskNotifierProvider.notifier);
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();

    final scheduledDate = useState<DateTime?>(null);
    final scheduledTime = useState<TimeOfDay?>(null);

    final focusNode1 = useFocusNode();
    final focusNode2 = useFocusNode();

    final priority = useState<TaskPriority>(TaskPriority.low);

    //Shift the main content page for animation
    void shiftContent() {
      ref.read(contentShiftedStateProvider.notifier).state = false;
    }

    void goBack() {
      shiftContent();
      context.pop(); //Return to task list screen.
    }

    //Listen to addTaskNotifierProvider to perform some action when the provider change.
    ref.listen<AsyncValue<void>>(addTaskNotifierProvider, (previous, next) {
      next.whenOrNull(
        loading: () {},
        data: (_) {
          // On successful update, pop the screen, reset content shift, and show a success message

          goBack();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Task created successfully")),
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
                                onTap: () => priority.value = e.value,
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
                        Gap(16),
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
                  Spacer(),
                  //Task scheduling date and time picker
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
                          //Today time picker
                          GestureDetector(
                            onTap: () async {
                              //Pick time when the scheduling date is today
                              scheduledTime.value = await pickTime(context);
                              if (scheduledTime.value != null) {
                                //Set selected index to 0 to display border arrond and show that this option is selected
                                selectedIndex.value = 0;
                              }
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
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  Gap(5),
                                  Text(
                                    "Today${selectedIndex.value == 0 ? " ${formatTime(context, scheduledTime.value)}" : ""}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //All day time picker
                          GestureDetector(
                            onTap: () async {
                              //Pick time when the scheduling date is all day
                              scheduledTime.value = await pickTime(context);
                              if (scheduledTime.value != null) {
                                //Set selected index to 1 to display border arrond and show that this option is selected
                                selectedIndex.value = 1;
                              }
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
                                  Icon(Ionicons.time, size: 15),
                                  Gap(5),
                                  Text(
                                    "All day${selectedIndex.value == 1 ? " ${formatTime(context, scheduledTime.value)}" : ""}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Custom date and time selector
                          GestureDetector(
                            onTap: () async {
                              try {
                                // Pick date first
                                final date = await pickDate(context);
                                if (date == null) {
                                  return; // User canceled date picker
                                }

                                if (!context.mounted) {
                                  return; // Safety check before using context
                                }

                                // Pick time only if date was selected
                                final time = await pickTime(context);
                                if (time == null) {
                                  return; // User canceled time picker
                                }

                                // Update state
                                scheduledDate.value = date;
                                scheduledTime.value = time;
                                selectedIndex.value = 2;
                              } catch (e, _) {
                                // Optional: handle errors gracefully
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to pick date or time.',
                                    ),
                                  ),
                                );
                              }
                            },

                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.grey1,
                                borderRadius: BorderRadius.circular(10),
                                border: selectedIndex.value == 2
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
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Gap(5),
                                  Text(
                                    (scheduledDate.value == null &&
                                                scheduledTime.value == null) ||
                                            selectedIndex.value != 2
                                        ? "Reminder"
                                        : "${formatDate(scheduledDate.value!)} ${formatTime(context, scheduledTime.value)}",
                                    style: TextStyle(
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
                  Gap(16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AppButton(
                      isLoading: state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      ),
                      label: "Create task",
                      isDisabled:
                          selectedIndex.value ==
                          null, //Check if date and time is picked before allowing user to press the button
                      onTap: () async {
                        if (formKey.value.currentState!.validate()) {
                          // Determine task date
                          final taskDate = selectedIndex.value == 0
                              ? DateTime.now()
                              : scheduledDate.value;

                          // Ensure time is selected
                          final taskTime = scheduledTime.value;
                          if (taskTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a time'),
                              ),
                            );
                            return;
                          }

                          // Call addTask
                          await notifier.addTask(
                            titleController.text,
                            descriptionController.text,
                            priority.value,
                            taskDate,
                            taskTime,
                          );
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
