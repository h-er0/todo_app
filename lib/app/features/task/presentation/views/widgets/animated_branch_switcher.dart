import 'package:flutter/material.dart';

// A widget that animates transitions between child widgets based on the current index
//Use to animate the change of page between the different tabs
class AnimatedBranchSwitcher extends StatelessWidget {
  const AnimatedBranchSwitcher({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),

      transitionBuilder: (child, animation) {
        final fade = FadeTransition(opacity: animation, child: child);
        final slide = SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(0, .2),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: fade,
        );
        return slide;
      },
      child: KeyedSubtree(
        // 🔑 Unique key based on index
        key: ValueKey<int>(currentIndex),
        child: _branchNavigatorWrapper(currentIndex, children[currentIndex]),
      ),
    );
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) => IgnorePointer(
    ignoring: index != currentIndex,
    child: TickerMode(enabled: index == currentIndex, child: navigator),
  );
}
