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
import '../models/maintenance_model.dart';
import '../models/vehicle_model.dart';
import '../viewmodels/vehicle_view_model.dart';

// Widgets modulares
import '../core/units/presentation/unit_system_provider.dart';
import '../core/units/domain/unit_system.dart';
import '../widgets/profile/profile_hero.dart';
import '../widgets/profile/profile_stats_dashboard.dart';
import '../widgets/profile/profile_menu_widgets.dart';
import '../widgets/profile/profile_vehicle_item.dart';
import '../widgets/profile/profile_settings_widgets.dart';
import '../widgets/profile/edit_profile_sheet.dart';
import '../widgets/profile/change_password_dialog.dart';
import '../widgets/maintenance/add_service_sheet.dart';

import 'package:url_launcher/url_launcher.dart';

/// Centro de configuración y gestión del perfil del usuario.
/// 
/// Consolida la administración de la cuenta y la personalización de la experiencia 
/// de uso. Ofrece:
/// * **Identidad Visual**: Gestión de avatar y datos personales.
/// * **Resumen de Actividad**: Métricas globales de flota y gastos.
/// * **Preferencias de Interfaz**: Configuración de tema (oscuro/claro), 
///   idioma (ES/EN) y sistema de unidades (Métrico/Imperial).
/// * **Seguridad y Soporte**: Gestión de contraseñas y canales de asistencia.
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

  void _showEditProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EditProfileSheet(),
    );
  }

  void _showChangePasswordDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ChangePasswordDialog(),
    );
  }

  Future<void> _callSupport() async {
    final uri = Uri.parse('tel:+526645367724');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
          SliverToBoxAdapter(
            child: ProfileHero(
              onTapEdit: _showEditProfileSheet,
            ),
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
    final maintenanceAsync = ref.watch(
      maintenanceDocsProvider(const MaintenanceParams()),
    );
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
            return t.profile.favoritesSaved(n: count).replaceAll('{n}', count.toString());
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

            final allRecords = maintenanceAsync.value ?? [];

            return favorites.map((vehicle) {
              final vehicleRecords = allRecords
                  .where((rec) => rec.vehicleId == vehicle.id)
                  .toList();
                  
              final vm = VehicleViewModel.fromVehicleWithRecords(vehicle, vehicleRecords);

              Color brandColor = AppColors.orangeSecondary;
              final typeSlug = vehicle.vehicleType.slug.toLowerCase();
              if (typeSlug.contains('motorcycle') || typeSlug.contains('moto')) {
                brandColor = AppColors.green;
              } else if (typeSlug.contains('suv') || typeSlug.contains('truck')) {
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
                viewModel: vm,
                maintenanceRecords: vehicleRecords,
                onLogService: () => _showLogServiceSheet(vehicle, allRecords),
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

  /// Abre el sheet de registro de servicio para un vehículo favorito.
  void _showLogServiceSheet(Vehicle vehicle, List<Maintenance> allRecords) {
    final t = Translations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddServiceSheet(
        vehicles: [vehicle],
        onSave: (data) async {
          final repository = ref.read(maintenanceRepositoryProvider);
          final params = MaintenanceParams(vehicleId: vehicle.id);
          final recordData = {
            'vehicle_id': vehicle.id,
            'date': data['date'] as String,
            'description': data['notes'] != null && data['notes'].toString().isNotEmpty
                ? '${data['description']} | ${data['notes']}'
                : data['description'],
            'cost': data['cost'].toString(),
            'mileage': data['mileage'],
            'category': data['category'],
          };
          final newRecord = await repository.addMaintenanceRecord(recordData);
          ref.read(maintenanceDocsProvider(params).notifier).updateLocal(newRecord);
          ref.read(maintenanceDocsProvider(const MaintenanceParams()).notifier).updateLocal(newRecord);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  t.garage.serviceLogged(vehicleName: vehicle.displayName),
                ),
                backgroundColor: AppColors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }



  Widget _buildNotificationSection(Translations t) {
    final bool isOpen = _openSection == 'notifs';
    final prefsAsync = ref.watch(profilePreferencesProvider);
    final notifier = ref.read(profilePreferencesProvider.notifier);

    // Determina el estado de carga/error
    final isLoading = prefsAsync.isLoading;
    final hasError = prefsAsync.hasError;
    final prefs = prefsAsync.value ?? const ProfilePreferences();

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
        if (hasError)
          _buildPrefsError(t)
        else ...[
          ProfileToggleRow(
            label: t.profile.pushNotifications,
            value: prefs.pushNotifications,
            onChanged: notifier.setPushNotifications,
            accent: AppColors.cyan,
            enabled: !isLoading,
          ),
          ProfileToggleRow(
            label: t.profile.serviceReminders,
            value: prefs.serviceReminders,
            onChanged: notifier.setServiceReminders,
            accent: AppColors.cyan,
            enabled: !isLoading,
          ),
          ProfileToggleRow(
            label: t.profile.criticalAlerts,
            value: prefs.criticalAlerts,
            onChanged: notifier.setCriticalAlerts,
            accent: AppColors.red,
            showBottomBorder: false,
            enabled: !isLoading,
          ),
        ],
      ],
    );
  }

  Widget _buildPrefsError(Translations t) {
    final r = context.responsive;
    return Padding(
      padding: EdgeInsets.all(r.space(AppSpacing.md)),
      child: Column(
        children: [
          Text(
            t.profile.errorLoadingPreferences,
            style: AppTextStyles.caption(context).copyWith(
              color: context.colors.textMuted,
            ),
          ),
          SizedBox(height: r.space(AppSpacing.xs)),
          TextButton.icon(
            onPressed: () => ref.invalidate(profilePreferencesProvider),
            icon: Icon(Icons.refresh, size: AppIconSizes.xs(context)),
            label: Text(t.common.retry),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.orangePrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(Translations t) {
    final bool isOpen = _openSection == 'security';
    final user = ref.watch(authProvider);

    String pwdSubtitle = t.profile.passwordLastChanged;
    if (user?.passwordChangedAt != null) {
      final diff = DateTime.now().difference(user!.passwordChangedAt!);
      final months = diff.inDays / 30.0;

      String colorIcon = '🟢';
      if (months >= 6) {
        colorIcon = '🔴';
      } else if (months >= 3) {
        colorIcon = '🟡';
      }

      if (diff.inDays == 0) {
        pwdSubtitle = 'Cambiada hoy $colorIcon';
      } else if (diff.inDays < 30) {
        pwdSubtitle = 'Cambiada hace ${diff.inDays} días $colorIcon';
      } else if (diff.inDays < 365) {
        pwdSubtitle = 'Cambiada hace ${diff.inDays ~/ 30} meses $colorIcon';
      } else {
        pwdSubtitle = 'Cambiada hace ${diff.inDays ~/ 365} años $colorIcon';
      }
    } else {
      pwdSubtitle = 'No has cambiado tu contraseña 🔴';
    }

    return ProfileExpandableContainer(
      isOpen: isOpen,
      header: ProfileMenuRow(
        icon: Icons.shield_outlined,
        accent: AppColors.green,
        label: t.profile.privacySecurity,
        subtitle: t.profile.securitySubtitleDefault,
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
          label: t.profile.changePassword,
          subtitle: pwdSubtitle,
          icon: Icons.vpn_key_outlined,
          actionLabel: t.profile.changePassword,
          onTap: _showChangePasswordDialog,
        ),
      ],
    );
  }


  Widget _buildAppSettingsSection(Translations t) {
    final bool isOpen = _openSection == 'settings';
    final appLocale = ref.watch(localeProvider);
    final currentLangTag = appLocale.languageTag.toUpperCase();

    // Leer tema actual desde el provider — se actualiza en tiempo real
    final currentTheme = ref.watch(themeProvider).value ?? ThemeMode.dark;
    final currentThemeSlug = currentTheme == ThemeMode.dark ? 'dark' : 'light';

    return ProfileExpandableContainer(
      isOpen: isOpen,
      header: ProfileMenuRow(
        icon: Icons.settings_outlined,
        accent: AppColors.accent,
        label: t.profile.appSettings,
        subtitle: t.profile.appSettingsSubtitle(
              theme: currentThemeSlug == 'dark'
                  ? t.profile.themeDark
                  : t.profile.themeLight,
              language: currentLangTag,
        ),
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
            final locale = LocaleNotifier.fromTag(val);
            if (locale != null) {
              ref.read(localeProvider.notifier).setLocale(locale);
            }
          },
          currentValue: appLocale.languageTag,
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
    return ProfileExpandableContainer(
      isOpen: false,
      header: ProfileMenuRow(
        icon: Icons.phone_outlined,
        accent: AppColors.green,
        label: t.profile.callSupport,
        subtitle: t.profile.supportPhone,
        onTap: _callSupport,
        trailing: Icon(
          Icons.call_outlined,
          size: AppIconSizes.sm(context),
          color: AppColors.green,
        ),
      ),
      children: const [],
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
