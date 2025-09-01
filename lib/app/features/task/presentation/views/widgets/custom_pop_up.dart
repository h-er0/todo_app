import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';

//Custom animated popup menu
class CustomPopupMenu {
  static void show(
    BuildContext context,
    Offset position,
    List<String> options,
    String selected,
    Function(String) onSelect,
  ) {
    final overlay = Overlay.of(context);

    // Use a StatefulBuilder or TickerProvider from your page
    final animationController = AnimationController(
      vsync: Navigator.of(context), // <-- This must be a TickerProvider
      duration: Duration(milliseconds: 250),
    );

    final scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    late OverlayEntry overlayEntry;

    Future<void> dismiss() async {
      await animationController.reverse(); // play reverse animation
      overlayEntry.remove(); // then remove overlay
    }

    overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: dismiss, // dismiss on tap outside
        child: Material(
          color: Colors.transparent,
          type: MaterialType.transparency, // optional

          elevation: 0,
          child: Stack(
            children: [
              // Transparent background
              Positioned.fill(
                child: GestureDetector(
                  onTap: dismiss, // only background taps
                  child: Container(color: Colors.transparent),
                ),
              ),
              // Popup content
              Positioned(
                left: position.dx,
                top: position.dy,
                child: FadeTransition(
                  opacity: fadeAnim,
                  child: ScaleTransition(
                    scale: scaleAnim,
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: options.asMap().entries.map((e) {
                          final index = e.key;
                          return Padding(
                            padding: index < options.length - 1
                                ? const EdgeInsets.only(bottom: 8)
                                : EdgeInsets.zero,
                            child: _buildTile(
                              e.value,
                              selected == e.value,
                              overlayEntry,
                              onSelect,
                              dismiss,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    animationController.forward();
  }

  static Widget _buildTile(
    String title,
    bool isSelected,
    OverlayEntry overlayEntry,
    Function(String) onSelect,
    Future<void> Function() dismiss,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () async {
        onSelect(title);
        await dismiss(); // reverse animation before removing overlay
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                inherit: true,
                letterSpacing: 0,
              ),
            ),
            if (isSelected) ...[
              Gap(10),

              Icon(Ionicons.checkmark_circle, color: Colors.black, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
