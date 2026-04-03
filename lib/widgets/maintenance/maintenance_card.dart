import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/maintenance_view_model.dart';
import '../ui/custom_list_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/units/presentation/unit_system_provider.dart';
import '../../core/units/domain/unit_formatter.dart';
import '../../features/currency/presentation/widgets/currency_display.dart';
import '../../core/responsive/responsive.dart';
import '../../core/i18n/translations.g.dart';

class MaintenanceCard extends ConsumerStatefulWidget {
  final MaintenanceViewModel vm;
  final String vehicleName;
  final VoidCallback onTap;

  const MaintenanceCard({
    super.key,
    required this.vm,
    required this.vehicleName,
    required this.onTap,
  });

  @override
  ConsumerState<MaintenanceCard> createState() => _MaintenanceCardState();
}

class _MaintenanceCardState extends ConsumerState<MaintenanceCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final unitSystem = ref.watch(unitSystemProvider);
    final r = context.responsive;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(bottom: r.space(AppSpacing.md)),
            padding: EdgeInsets.all(r.space(AppSpacing.lg)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rounded-square icon container (Principio #8: radio moderno)
                Container(
                  width: r.dim(44),
                  height: r.dim(44),
                  decoration: BoxDecoration(
                    color: widget.vm.computedAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(r.r(AppRadius.md)),
                  ),
                  child: Icon(
                    widget.vm.computedIcon,
                    color: widget.vm.computedAccent,
                    size: AppIconSizes.md(context),
                  ),
                ),
                SizedBox(width: r.space(AppSpacing.lg)),
                
                // Central Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container( // The single accent dot
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: widget.vm.computedAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: r.space(AppSpacing.s)),
                          Expanded(
                            child: Text(
                              widget.vm.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.space(AppSpacing.xs)),
                      
                      // Combined Meta string
                      Text(
                        '${widget.vehicleName} • ${DateFormat('MMM d, y').format(widget.vm.date)} • ${UnitFormatter.formatDistance(widget.vm.mileage.toDouble(), unitSystem, fractionDigits: 0)}',
                        style: AppTextStyles.caption(context).copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      if (widget.vm.notes != null) ...[
                        SizedBox(height: r.space(AppSpacing.s)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: r.space(AppSpacing.s),
                            vertical: r.space(4),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(r.r(AppRadius.s)),
                          ),
                          child: Text(
                            widget.vm.notes!,
                            style: AppTextStyles.caption(context).copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Trailing Cost
                SizedBox(width: r.space(AppSpacing.md)),
                if (widget.vm.cost > 0)
                  CurrencyDisplay(
                    amount: widget.vm.cost,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  )
                 else 
                  Text(
                    Translations.of(context).common.free,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
              ],
            ),
          ),
      ),
    );
  }
}
