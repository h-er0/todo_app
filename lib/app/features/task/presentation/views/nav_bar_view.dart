import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/app/config/routes/app_router.dart';
import 'package:todo_app/app/shared/providers.dart';
import 'widgets/animated_branch_switcher.dart';

// A navigation bar view with animated transitions for branch switching
class NavBarView extends StatefulHookConsumerWidget {
  const NavBarView({
    super.key,
    required this.navigationShell,
    required this.children,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  ConsumerState<NavBarView> createState() => NavBarViewState();
}

class NavBarViewState extends ConsumerState<NavBarView> {
  late final CupertinoTabController tabController = CupertinoTabController(
    initialIndex: widget.navigationShell.currentIndex,
  );

  int _currentIndex = 0;
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _onTap(BuildContext context, int index) {
    _currentIndex = index;
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTop = ref
        .watch(contentShiftedStateProvider.notifier)
        .state; // Tracks content shift state

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            color: CupertinoColors.black,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.viewPaddingOf(
                    context,
                  ).bottom, // Adjust for safe area
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _onTap(context, 0);
                      },
                      child: SizedBox(
                        width: 70,
                        height: 40,

                        child: Center(
                          child: Icon(
                            Ionicons.file_tray_full,
                            color: _currentIndex == 0
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(contentShiftedStateProvider.notifier).state =
                            true;
                        context.push(Routes.taskList + Routes.addTask);
                      },
                      child: Container(
                        width: 70,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(child: Icon(Ionicons.add)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _onTap(context, 1);
                      },
                      child: SizedBox(
                        width: 70,
                        height: 40,

                        child: Center(
                          child: Icon(
                            Ionicons.cog,
                            color: _currentIndex == 1
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Animated content area with branch switching
          AnimatedPositioned(
            duration: Duration(
              milliseconds: 250,
            ), // Animation duration for position (Same as go router animation duration)
            top: isTop ? MediaQuery.viewPaddingOf(context).top + 60 : 0,
            right: 0,
            left: 0,
            bottom: !isTop ? MediaQuery.viewPaddingOf(context).bottom + 60 : 0,
            child: AnimatedContainer(
              clipBehavior: Clip
                  .hardEdge, // Clip content to container to avoid exceeding by child widgets
              duration: Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: AnimatedBranchSwitcher(
                currentIndex: widget.navigationShell.currentIndex,
                children: widget.children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
