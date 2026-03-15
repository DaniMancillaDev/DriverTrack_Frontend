import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final bool enabled;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Widget switchWidget = Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeThumbColor: colorScheme.onPrimary, // thumb color when active
      activeTrackColor: colorScheme.primary, // bg-primary when active
      inactiveThumbColor: colorScheme.surface, // bg-card thumb when inactive
      inactiveTrackColor: colorScheme.surfaceContainerHighest, // bg-switch-background 
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (states) => Colors.transparent, // Tailwind usa border-transparent
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    if (label == null) {
      return switchWidget;
    }

    return InkWell(
      onTap: enabled
          ? () {
              if (onChanged != null) onChanged!(!value);
            }
          : null,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            switchWidget,
            const SizedBox(width: 8),
            Text(
              label!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: enabled
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withOpacity(0.5),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
