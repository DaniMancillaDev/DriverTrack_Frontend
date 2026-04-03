import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../ui/summary_stats.dart';
import '../ui/sheet_container.dart';
import '../ui/sheet_header.dart';
import '../../core/i18n/translations.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/units/presentation/unit_system_provider.dart';
import '../../core/units/domain/unit_formatter.dart';
import '../../core/units/domain/unit_system.dart';
import '../../features/currency/presentation/widgets/currency_display.dart';
import '../../core/responsive/responsive.dart';

class ServiceDetailSheet extends ConsumerWidget {
  final String serviceTitle;
  final String vehicleName;
  final DateTime date;
  final double cost;
  final int mileage;
  final String? notes;
  final Color accentColor;
  final String category;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onClose;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const ServiceDetailSheet({
    super.key,
    required this.serviceTitle,
    required this.vehicleName,
    required this.date,
    required this.cost,
    required this.mileage,
    required this.accentColor,
    required this.category,
    this.notes,
    required this.isExpanded,
    required this.onToggle,
    required this.onClose,
    this.onEdit,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitSystem = ref.watch(unitSystemProvider);
    final r = context.responsive;

    return SheetContainer(
      height: isExpanded ? MediaQuery.of(context).size.height * 0.85 : r.dim(450),
      showDragHandle: false,
      child: Column(
        children: [
          // Custom Handle for Toggle
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy < -10 && !isExpanded) onToggle();
              if (details.delta.dy > 10 && isExpanded) onToggle();
            },
            onTap: onToggle,
            child: _buildHandle(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                r.space(AppSpacing.lg),
                0,
                r.space(AppSpacing.lg),
                r.space(AppSpacing.xl),
              ),
              physics: isExpanded
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SheetHeader(
                    title: serviceTitle,
                    onClose: onClose,
                    trailing: (onEdit != null || onRemove != null)
                        ? _buildTrailingActions(context)
                        : null,
                  ),
                  SizedBox(height: r.space(AppSpacing.xxs)),
                  Row(
                    children: [
                      Icon(Icons.directions_car, size: AppIconSizes.sm(context), color: accentColor),
                      SizedBox(width: r.space(AppSpacing.xs)),
                      Expanded(
                        child: Text(
                          vehicleName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textMuted,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: r.space(AppSpacing.lg)),
                  _buildCostSection(context, cost, accentColor),
                  SizedBox(height: r.space(AppSpacing.xl)),
                  _buildStatsSection(context, accentColor, unitSystem),
                  SizedBox(height: r.space(AppSpacing.xl)),
                  _buildNotesSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final r = context.responsive;
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: r.space(AppSpacing.s)),
      child: Center(
        child: Container(
          width: r.dim(36),
          height: r.dim(4),
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(r.r(AppRadius.xs)),
          ),
        ),
      ),
    );
  }

  Widget _buildTrailingActions(BuildContext context) {
    final r = context.responsive;
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          onEdit?.call();
        } else if (value == 'remove') {
          onRemove?.call();
        }
      },
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r.r(AppRadius.lg)),
      ),
      icon: Icon(Icons.more_vert_rounded, color: AppColors.textMuted, size: AppIconSizes.lg(context)),
      itemBuilder: (context) => [
        if (onEdit != null)
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: AppIconSizes.md(context),
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: r.space(AppSpacing.md)),
                Text(
                  Translations.of(context).maintenance.editEntry,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        if (onRemove != null)
          PopupMenuItem(
            value: 'remove',
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  size: AppIconSizes.md(context),
                  color: AppColors.red,
                ),
                SizedBox(width: r.space(AppSpacing.md)),
                Text(
                  Translations.of(context).maintenance.deleteEntry,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.red,
                      ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCostSection(BuildContext context, double costValue, Color accent) {
    final r = context.responsive;
    return Container(
      padding: EdgeInsets.all(r.space(AppSpacing.lg)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(r.r(AppRadius.xxl)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Translations.of(context).maintenance.totalInvestment,
                  style: AppTextStyles.label(context).copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: r.space(AppSpacing.xxs)),
                Text(
                  Translations.of(context).maintenance.professionalService,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          CurrencyDisplay(
            amount: costValue,
            style: AppTextStyles.headline(context).copyWith(
              color: AppColors.green,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, Color accent, UnitSystem unitSystem) {
    final stats = [
      StatItem(
        label: Translations.of(context).maintenance.mileage,
        value: UnitFormatter.formatDistance(mileage.toDouble(), unitSystem, fractionDigits: 0),
        accent: accent,
      ),
      StatItem(
        label: Translations.of(context).maintenance.date,
        value: DateFormat('MMM d, y').format(date),
        accent: AppColors.cyan,
      ),
      StatItem(label: Translations.of(context).maintenance.category, value: category, accent: AppColors.purple),
    ];

    return SummaryStats(stats: stats);
  }

  Widget _buildNotesSection(BuildContext context) {
    final r = context.responsive;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SERVICE NOTES',
          style: AppTextStyles.label(context).copyWith(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: r.space(AppSpacing.md)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(r.space(AppSpacing.lg)),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
          ),
          child: Text(
            notes ?? Translations.of(context).maintenance.noNotes,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
