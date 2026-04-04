import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ui/custom_button.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/app_providers.dart';
import '../providers/profile_preferences_provider.dart';
import '../providers/theme_provider.dart';
import '../core/i18n/translations.g.dart';
import '../core/i18n/locale_provider.dart';
import '../features/currency/presentation/widgets/currency_converter_widget.dart';

import '../core/responsive/responsive.dart';
import '../theme/app_color_scheme.dart';

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
  // Solo el estado de UI puro (expansión de secciones) se queda en setState.
  // Los toggles y el tema se delegan a sus respectivos Riverpod providers.
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
      backgroundColor: context.colors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(
            child: ProfileHero(),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: r.value(mobile: 600, tablet: 700),
                ),
                child: Column(
                  children: [
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
    ],
  ),
);
}

  Widget _buildSectionLabel(String label) {
    final r = context.responsive;
    return Padding(
      padding: EdgeInsets.only(
        left: r.space(4),
        bottom: r.space(AppSpacing.xs),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.label(context).copyWith(
          color: context.colors.textMuted,
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
          color: isOpen ? AppColors.orangePrimary : context.colors.surfaceLight2,
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
                      style: AppTextStyles.bodySmall(
                        context,
                      ).copyWith(color: context.colors.textMuted),
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

              final tType = typeSlug.contains('moto')
                  ? t.garage.vehicleTypes.motorcycle
                  : (typeSlug.contains('car')
                        ? t.garage.vehicleTypes.car
                        : vehicle.vehicleType.label);
              final formattedType = tType.isNotEmpty
                  ? '${tType[0].toUpperCase()}${tType.substring(1).toLowerCase()}'
                  : tType;

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
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationSection(Translations t) {
    final bool isOpen = _openSection == 'notifs';
    // Lee las preferencias del provider persistido.
    final prefsAsync = ref.watch(profilePreferencesProvider);
    final prefs = prefsAsync.value ?? const ProfilePreferences();
    final notifier = ref.read(profilePreferencesProvider.notifier);

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
          color: isOpen ? AppColors.cyan : context.colors.surfaceLight2,
        ),
        showBottomBorder: isOpen,
      ),
      children: [
        ProfileToggleRow(
          label: t.profile.pushNotifications,
          value: prefs.pushNotifications,
          onChanged: notifier.setPushNotifications,
          accent: AppColors.cyan,
        ),
        ProfileToggleRow(
          label: t.profile.serviceReminders,
          value: prefs.serviceReminders,
          onChanged: notifier.setServiceReminders,
          accent: AppColors.cyan,
        ),
        ProfileToggleRow(
          label: t.profile.criticalAlerts,
          value: prefs.criticalAlerts,
          onChanged: notifier.setCriticalAlerts,
          accent: AppColors.red,
          showBottomBorder: false,
        ),
      ],
    );
  }

  Widget _buildSecuritySection(Translations t) {
    final bool isOpen = _openSection == 'security';
    final prefs =
        ref.watch(profilePreferencesProvider).value ??
        const ProfilePreferences();
    final notifier = ref.read(profilePreferencesProvider.notifier);
    final twoFA = prefs.twoFactorAuth;

    return ProfileExpandableContainer(
      isOpen: isOpen,
      header: ProfileMenuRow(
        icon: Icons.shield_outlined,
        accent: AppColors.green,
        label: t.profile.privacySecurity,
        subtitle: twoFA
            ? t.profile.securitySubtitleActive
            : t.profile.securitySubtitleDefault,
        onTap: () => _toggleSection('security'),
        trailing: Icon(
          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: AppIconSizes.sm(context),
          color: isOpen ? AppColors.green : context.colors.surfaceLight2,
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
          value: twoFA,
          onChanged: notifier.setTwoFactorAuth,
          accent: AppColors.green,
          subtitle: twoFA
              ? t.profile.twoFactorEnabled
              : t.profile.twoFactorDisabled,
          showBottomBorder: false,
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection(Translations t) {
    final bool isOpen = _openSection == 'settings';
    final currentLangTag = LocaleProvider.instance.currentAppLocale.languageTag
        .toUpperCase();

    // Leer tema actual desde el provider — se actualiza en tiempo real
    final currentTheme = ref.watch(themeProvider).value ?? ThemeMode.dark;
    final currentThemeSlug = currentTheme == ThemeMode.dark ? 'dark' : 'light';

    return ProfileExpandableContainer(
      isOpen: isOpen,
      header: ProfileMenuRow(
        icon: Icons.settings_outlined,
        accent: AppColors.accent,
        label: t.profile.appSettings,
        subtitle: t.profile.appSettingsSubtitle
            .replaceAll(
              '{theme}',
              currentThemeSlug == 'dark'
                  ? t.profile.themeDark
                  : t.profile.themeLight,
            )
            .replaceAll('{language}', currentLangTag),
        onTap: () => _toggleSection('settings'),
        trailing: Icon(
          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: AppIconSizes.sm(context),
          color: isOpen ? AppColors.accent : context.colors.surfaceLight2,
        ),
        showBottomBorder: isOpen,
      ),
      children: [
        ProfileSelectionRow(
          label: t.profile.theme,
          options: const ['dark', 'light'],
          displayLabels: [t.profile.themeDark, t.profile.themeLight],
          onChanged: (val) {
            if (val == 'light') {
              ref.read(themeProvider.notifier).setLight();
            } else {
              ref.read(themeProvider.notifier).setDark();
            }
          },
          currentValue: currentThemeSlug,
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
                ref
                    .read(unitSystemProvider.notifier)
                    .setSystem(
                      val == 'metric' ? UnitSystem.metric : UnitSystem.imperial,
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
                Icon(
                  Icons.star,
                  size: AppIconSizes.xs(context),
                  color: AppColors.orangeSecondary,
                ),
                Icon(
                  Icons.star,
                  size: AppIconSizes.xs(context),
                  color: AppColors.orangeSecondary,
                ),
                Icon(
                  Icons.star,
                  size: AppIconSizes.xs(context),
                  color: AppColors.orangeSecondary,
                ),
                Icon(
                  Icons.star,
                  size: AppIconSizes.xs(context),
                  color: AppColors.orangeSecondary,
                ),
                Icon(
                  Icons.star,
                  size: AppIconSizes.xs(context),
                  color: AppColors.orangeSecondary,
                ),
              ],
            ),
          ),
          ProfileMenuRow(
            icon: Icons.help_outline,
            accent: context.colors.textMuted,
            label: t.profile.helpSupport,
            subtitle: t.profile.faqsContact,
            onTap: () => _toggleSection('support'),
            trailing: Icon(
              isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: AppIconSizes.sm(context),
              color: isOpen ? context.colors.textMuted : context.colors.surfaceLight2,
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
          Icon(
            Icons.logout,
            size: AppIconSizes.md(context),
            color: AppColors.red,
          ),
          SizedBox(width: r.space(AppSpacing.s)),
          Text(
            t.profile.signOut,
            style: AppTextStyles.bodyMedium(
              context,
            ).copyWith(color: AppColors.red, fontWeight: FontWeight.w700),
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
            style: AppTextStyles.label(
              context,
            ).copyWith(color: context.colors.textMuted),
          ),
          SizedBox(height: r.space(AppSpacing.xxs)),
          Text(
            t.profile.footerTagline,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro(
              context,
            ).copyWith(color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
