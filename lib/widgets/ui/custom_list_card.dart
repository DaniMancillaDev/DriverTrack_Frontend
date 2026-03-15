import 'package:flutter/material.dart';

class CustomListCard extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? child;
  final VoidCallback? onTap;
  final bool isSelected;
  final EdgeInsetsGeometry? padding;

  const CustomListCard({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.child,
    this.onTap,
    this.isSelected = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasChild = child != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        highlightColor: const Color(0xFFFF6B1A).withOpacity(0.1),
        splashColor: const Color(0xFFFF6B1A).withOpacity(0.1),
        hoverColor: Colors.white.withOpacity(0.02),
        child: Ink(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
                ? const Color(0xFFFF6B1A).withOpacity(0.08)
                : const Color(0xFF16161A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected 
                  ? const Color(0xFFFF6B1A).withOpacity(0.4)
                  : const Color(0xFF222228),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF6B1A).withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: hasChild 
            ? child! 
            : Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            color: Color(0xFF6B6B7A),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
              ],
            ),
        ),
      ),
    );
  }
}
