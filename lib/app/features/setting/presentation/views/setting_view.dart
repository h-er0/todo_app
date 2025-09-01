import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/features/setting/presentation/notifiers/setting_notifier.dart';
import 'package:todo_app/app/shared/widgets/loading_dialog.dart';

import '../../../../core/errors/error_dialog.dart';
import '../../data/models/setting_model.dart';

class SettingView extends HookConsumerWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingNotifierProvider);
    final notifier = ref.watch(settingNotifierProvider.notifier);

    //To handle loading state while settings update
    final isLoading = useState(false);

    ref.listen<AsyncValue<SettingModel>>(settingNotifierProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        loading: () {
          LoadingDialog.show(context);
        },
        data: (_) {
          // On successful update, pop the loading dialog and show a success message

          if (isLoading.value) {
            context.pop();
            isLoading.value = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Settings updated successfully")),
            );
          }
        },
        error: (error, _) {
          if (isLoading.value) {
            context.pop();
            isLoading.value = false;
          }
          // On error, show an error dialog
          ErrorDialog.show(context: context, content: error.toString());
        },
      );
    });

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -.41,
                  inherit: true,
                ),
              ),
            ),
            Gap(16),
            Expanded(
              child: state.when(
                data: (data) {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text(
                          "Ask before completing or deleting a task",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                            inherit: true,
                          ),
                        ),
                        trailing: Switch.adaptive(
                          value: data.askBeforeAction,
                          onChanged: (value) async {
                            isLoading.value = true;
                            await notifier.toggleAskBeforeAction(
                              data.copyWith(askBeforeAction: value),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(),
                      ),
                      ListTile(
                        title: Text(
                          "Enable notification",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                            inherit: true,
                          ),
                        ),
                        trailing: Switch.adaptive(
                          value: data.activeNotification,
                          onChanged: (value) async {
                            isLoading.value = true;
                            await notifier.toggleNotification(value);
                          },
                        ),
                      ),
                    ],
                  );
                },
                error: (e, s) => Center(
                  child: Text("An error occured", textAlign: TextAlign.center),
                ),
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
