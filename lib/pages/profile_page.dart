import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ui/custom_button.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/app_providers.dart';
import '../core/i18n/translations.g.dart';
import '../core/i18n/locale_provider.dart';
import '../features/currency/presentation/widgets/currency_converter_widget.dart';

import '../core/responsive/responsive.dart';

// Modular Widgets
import '../core/units/presentation/unit_system_provider.dart';
import '../core/units/domain/unit_system.dart';
import '../widgets/profile/profile_hero.dart';
import '../widgets/profile/profile_stats_dashboard.dart';
import '../widgets/profile/profile_menu_widgets.dart';
import '../widgets/profile/profile_vehicle_item.dart';
import '../widgets/profile/profile_settings_widgets.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  // Toggles
  bool _serviceReminders = true;
  bool _criticalAlerts = true;
  bool _pushNotifs = true;
  bool _twoFA = false;

  // Settings
  String _theme = 'dark';
  String _language = 'EN';

  // Expandable sections
  String? _openSection;

  void _toggleSection(String key) {
    setState(() {
      _openSection = (_openSection == key) ? null : key;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final r = context.responsive;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: r.value(mobile: 600, tablet: 700)),
            child: Column(
              children: [
                const ProfileHero(),
                const ProfileStatsDashboard(),
                Padding(
                  padding: EdgeInsets.all(r.space(AppSpacing.lg)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel(t.profile.vehiclePreferences),
                      _buildVehicleSection(t),
                      SizedBox(height: r.space(AppSpacing.lg)),
                      _buildSectionLabel(t.profile.notifications),
                      _buildNotificationSection(t),
                      SizedBox(height: r.space(AppSpacing.lg)),
                      _buildSectionLabel(t.profile.privacySecurity),
                      _buildSecuritySection(t),
                      SizedBox(height: r.space(AppSpacing.lg)),
                      
                      _buildSectionLabel(t.currency.converterLabel),
                      const CurrencyConverterWidget(),
                      SizedBox(height: r.space(AppSpacing.lg)),

                      _buildSectionLabel(t.profile.appSettings),
                      _buildAppSettingsSection(t),
                      SizedBox(height: r.space(AppSpacing.lg)),
                      _buildSectionLabel(t.profile.feedbackSupport),
                      _buildSupportSection(t),
                      SizedBox(height: r.space(AppSpacing.md)),
                      _buildSignOutSection(t),
                      SizedBox(height: r.space(AppSpacing.lg)),
                      _buildFooter(t),
                      SizedBox(height: r.space(AppSpacing.xxxl)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    final r = context.responsive;
    return Padding(
      padding: EdgeInsets.only(left: r.space(4), bottom: r.space(AppSpacing.xs)),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.label(context).copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
      ),
    );
  }

  Widget _buildVehicleSection(Translations t) {
    final vehiclesAsync = ref.watch(vehiclesProvider);
    final bool isOpen = _openSection == 'vehicles';
    final r = context.responsive;

    return ProfileExpandableContainer(
      isOpen: isOpen,
      header: ProfileMenuRow(
        icon: Icons.star_outline_rounded,
        accent: AppColors.orangeSecondary,
        label: t.profile.favoriteVehicles,
        subtitle: vehiclesAsync.maybeWhen(
          data: (list) {
            final count = list.where((v) => v.isFavorite).length;
            return t.profile.favoritesSaved(n: count);
          },
          orElse: () => t.common.loading,
        ),
        onTap: () => _toggleSection('vehicles'),
        trailing: Icon(
          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: AppIconSizes.sm(context),
          color: isOpen ? AppColors.orangePrimary : AppColors.surfaceLight2,
        ),
        showBottomBorder: isOpen,
      ),
      children: [
        ...vehiclesAsync.maybeWhen(
          data: (list) {
            final favorites = list.where((v) => v.isFavorite).toList();
            if (favorites.isEmpty) {
              return [
                Padding(
                  padding: EdgeInsets.all(r.space(AppSpacing.lg)),
                  child: Center(
                    child: Text(
                      t.profile.noFavorites,
                      style: AppTextStyles.bodySmall(context).copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                  ),
                ),
              ];
            }
            return favorites.map((vehicle) {
              Color brandColor = AppColors.orangeSecondary;
              final typeSlug = vehicle.vehicleType.slug.toLowerCase();

              if (typeSlug.contains('motorcycle') ||
                  typeSlug.contains('moto')) {
                brandColor = AppColors.green;
              } else if (typeSlug.contains('suv') ||
                  typeSlug.contains('truck')) {
                brandColor = AppColors.red;
              }

              final tType = typeSlug.contains('moto') ? t.garage.vehicleTypes.motorcycle : (typeSlug.contains('car') ? t.garage.vehicleTypes.car : vehicle.vehicleType.label);
              final formattedType = tType.isNotEmpty ? '${tType[0].toUpperCase()}${tType.substring(1).toLowerCase()}' : tType;

              return ProfileVehicleItem(
                name: vehicle.displayName,
                details: '$formattedType · ${vehicle.plate}',
                color: brandColor,
                isFavorite: true,
              );
            }).toList();
          },
          orElse: () => [
            Padding(
              padding: EdgeInsets.all(r.space(AppSpacing.md)),
              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationSection(Translations t) {
    final bool isOpen = _openSection == 'notifs';
    return ProfileExpandableContainer(
      isOpen: isOpen,
      header: ProfileMenuRow(
        icon: Icons.notifications_none,
        accent: AppColors.cyan,
        label: t.profile.notifications,
        subtitle: t.profile.configureAlerts,
        onTap: () => _toggleSection('notifs'),
        trailing: Icon(
          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: AppIconSizes.sm(context),
          color: isOpen ? AppColors.cyan : AppColors.surfaceLight2,
        ),
        showBottomBorder: isOpen,
      ),
      children: [
        ProfileToggleRow(
          label: t.profile.pushNotifications,
          value: _pushNotifs,
          onChanged: (val) => setState(() => _pushNotifs = val),
          accent: AppColors.cyan,
        ),
        ProfileToggleRow(
          label: t.profile.serviceReminders,
          value: _serviceReminders,
          onChanged: (val) => setState(() => _serviceReminders = val),
          accent: AppColors.cyan,
        ),
        ProfileToggleRow(
          label: t.profile.criticalAlerts,
          value: _criticalAlerts,
          onChanged: (val) => setState(() => _criticalAlerts = val),
          accent: AppColors.red,
          showBottomBorder: false,
        ),
      ],
    );
  }

  Widget _buildSecuritySection(Translations t) {
    final bool isOpen = _openSection == 'security';
    return ProfileExpandableContainer(
      isOpen: isOpen,
      header: ProfileMenuRow(
        icon: Icons.shield_outlined,
        accent: AppColors.green,
        label: t.profile.privacySecurity,
        subtitle: _twoFA ? t.profile.securitySubtitleActive : t.profile.securitySubtitleDefault,
        onTap: () => _toggleSection('security'),
        trailing: Icon(
          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: AppIconSizes.sm(context),
          color: isOpen ? AppColors.green : AppColors.surfaceLight2,
        ),
        showBottomBorder: isOpen,
      ),
      children: [
        ProfileSecurityButton(
          label: t.profile.passwordReset,
          subtitle: t.profile.passwordLastChanged,
          icon: Icons.vpn_key_outlined,
          actionLabel: t.profile.reset,
        ),
        ProfileToggleRow(
          label: t.profile.twoFactor,
          value: _twoFA,
          onChanged: (val) => setState(() => _twoFA = val),
          accent: AppColors.green,
          subtitle: _twoFA ? t.profile.twoFactorEnabled : t.profile.twoFactorDisabled,
          showBottomBorder: false,
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection(Translations t) {
    final bool isOpen = _openSection == 'settings';
    final currentLangTag = LocaleProvider.instance.currentAppLocale.languageTag.toUpperCase();
    return ProfileExpandableContainer(
      isOpen: isOpen,
      header: ProfileMenuRow(
        icon: Icons.settings_outlined,
        accent: AppColors.accent,
        label: t.profile.appSettings,
        subtitle: t.profile.appSettingsSubtitle
            .replaceAll('{theme}', _theme == 'dark' ? t.profile.themeDark : t.profile.themeLight)
            .replaceAll('{language}', currentLangTag),
        onTap: () => _toggleSection('settings'),
        trailing: Icon(
          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: AppIconSizes.sm(context),
          color: isOpen ? AppColors.accent : AppColors.surfaceLight2,
        ),
        showBottomBorder: isOpen,
      ),
      children: [
        ProfileSelectionRow(
          label: t.profile.theme,
          options: const ['dark', 'light'],
          onChanged: (val) => setState(() => _theme = val),
          currentValue: _theme,
          accent: AppColors.accent,
        ),
        ProfileSelectionRow(
          label: t.profile.language,
          options: const ['es', 'en'],
          displayLabels: const ['ES', 'EN'],
          onChanged: (val) {
            final locale = LocaleProvider.fromTag(val);
            if (locale != null) {
              LocaleProvider.instance.setLocale(locale);
            }
            setState(() => _language = val.toUpperCase());
          },
          currentValue: LocaleProvider.instance.currentAppLocale.languageTag,
          accent: AppColors.accent,
          showBottomBorder: true,
        ),
        Consumer(
          builder: (context, ref, child) {
            final activeSystem = ref.watch(unitSystemProvider);
            final t = Translations.of(context);
            return ProfileSelectionRow(
              label: t.profile.systemOfUnits,
              options: const ['metric', 'imperial'],
              displayLabels: [t.profile.metric, t.profile.imperial],
              onChanged: (val) {
                ref.read(unitSystemProvider.notifier).setSystem(
                  val == 'metric' ? UnitSystem.metric : UnitSystem.imperial
                );
              },
              currentValue: activeSystem.name,
              accent: AppColors.accent,
              showBottomBorder: false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection(Translations t) {
    final bool isOpen = _openSection == 'support';
    return ProfileExpandableContainer(
      isOpen: isOpen,
      header: Column(
        children: [
          ProfileMenuRow(
            icon: Icons.star_outline,
            accent: AppColors.orangeSecondary,
            label: t.profile.rateDriveTrack,
            subtitle: t.profile.shareExperience,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: AppIconSizes.xs(context), color: AppColors.orangeSecondary),
                Icon(Icons.star, size: AppIconSizes.xs(context), color: AppColors.orangeSecondary),
                Icon(Icons.star, size: AppIconSizes.xs(context), color: AppColors.orangeSecondary),
                Icon(Icons.star, size: AppIconSizes.xs(context), color: AppColors.orangeSecondary),
                Icon(Icons.star, size: AppIconSizes.xs(context), color: AppColors.orangeSecondary),
              ],
            ),
          ),
          ProfileMenuRow(
            icon: Icons.help_outline,
            accent: AppColors.textMuted,
            label: t.profile.helpSupport,
            subtitle: t.profile.faqsContact,
            onTap: () => _toggleSection('support'),
            trailing: Icon(
              isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: AppIconSizes.sm(context),
              color: isOpen ? AppColors.textMuted : AppColors.surfaceLight2,
            ),
            showBottomBorder: isOpen,
            borderBottom: false,
          ),
        ],
      ),
      children: [
        ProfileSimpleRow(label: t.profile.faqs, icon: Icons.bookmark_border),
        ProfileSimpleRow(
          label: t.profile.chatSupport,
          icon: Icons.chat_bubble_outline,
        ),
        const ProfileSimpleRow(
          label: '+1 (800) DRIVE-TK',
          icon: Icons.phone_outlined,
          showBottomBorder: false,
        ),
      ],
    );
  }

  Widget _buildSignOutSection(Translations t) {
    final r = context.responsive;
    return CustomButton(
      onPressed: () => ref.read(authProvider.notifier).logout(),
      variant: ButtonVariant.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, size: AppIconSizes.md(context), color: AppColors.red),
          SizedBox(width: r.space(AppSpacing.s)),
          Text(
            t.profile.signOut,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(Translations t) {
    final r = context.responsive;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            t.common.appName,
            style: AppTextStyles.label(context).copyWith(
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: r.space(AppSpacing.xxs)),
          Text(
            t.profile.footerTagline,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
