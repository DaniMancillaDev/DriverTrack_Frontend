// Removed dart:ui
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_color_scheme.dart';

class SheetContainer extends StatelessWidget {
  final Widget child;
  final bool showDragHandle;
  final double maxWidth;
  final double? height;
  final BoxBorder? border;
  final VoidCallback? onClose;
  final VoidCallback? onToggle;

  const SheetContainer({
    super.key,
    required this.child,
    this.showDragHandle = true,
    this.maxWidth = 600,
    this.height,
    this.border,
    this.onClose,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          height: height,
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xxl),
            ),
            border: border,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 0,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
                child: Column(
                  mainAxisSize: height == null ? MainAxisSize.min : MainAxisSize.max,
                  children: [
                    if (showDragHandle)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: AppSpacing.s),
                        width: 48,
                        height: 6,
                        decoration: BoxDecoration(
                          color: context.colors.surfaceLight2,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                      ),
                    Flexible(child: child),
                  ],
                ),
        ),
      ),
    );
  }
}
