import 'package:flutter/material.dart';

import '../../config/theme/color_theme.dart';
import '../globals.dart';

//Custom button
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.child,
    this.label,
    this.color,
    this.textColor,
    required this.onTap,
    this.width,
    this.radius,
    this.gradient,
    this.outlined = false,
    this.isLoading = false,
    this.isDisabled = false, // disable parameter
  }) : assert(
         (label == null) != (child == null),
         'Either label or child must be provided, but not both.',
       );

  final Widget? child;
  final String? label;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? radius;
  final void Function() onTap;
  final Gradient? gradient;
  final bool outlined;
  final bool isLoading;
  final bool isDisabled; //disable click parameter

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled || isLoading
          ? null
          : onTap, // isDisabled tap when isDisabledd or loading
      child: Container(
        height: 55,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 20),
          border: outlined
              ? Border.all(color: color ?? AppColors.primaryColor)
              : null,
          color: outlined
              ? Colors.transparent
              : isLoading
              ? Colors.grey.withValues(alpha: 0.3)
              : isDisabled
              ? Colors
                    .grey
                    .shade300 // Grey color when isDisabledd
              : color ?? AppColors.primaryColor,
          gradient: !outlined && !isLoading && !isDisabled
              ? gradient
              : null, // Apply gradient only if not outlined, loading, or isDisabledd
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator.adaptive(),
                )
              : label != null
              ? Text(
                  label!,
                  style: TextStyle(
                    fontWeight: isIOS ? FontWeight.w600 : FontWeight.w500,
                    color: isDisabled
                        ? Colors
                              .white // White text when isDisabledd
                        : outlined
                        ? Colors.black
                        : textColor ?? Colors.white,
                    letterSpacing: 0,
                  ),
                )
              : child,
        ),
      ),
    );
  }
}
