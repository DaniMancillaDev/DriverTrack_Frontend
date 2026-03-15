import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ui/custom_avatar.dart';
import '../widgets/ui/custom_switch.dart';
import '../widgets/ui/custom_list_card.dart';
import '../widgets/ui/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeroHeader(),
                _buildStatsDashboard(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('Vehicle Preferences'),
                      _buildVehicleSection(),
                      const SizedBox(height: 20),
                      _buildSectionLabel('Notifications'),
                      _buildNotificationSection(),
                      const SizedBox(height: 20),
                      _buildSectionLabel('Privacy & Security'),
                      _buildSecuritySection(),
                      const SizedBox(height: 20),
                      _buildSectionLabel('App Settings'),
                      _buildAppSettingsSection(),
                      const SizedBox(height: 20),
                      _buildSectionLabel('Feedback & Support'),
                      _buildSupportSection(),
                      const SizedBox(height: 32),
                      _buildSignOutButton(),
                      const SizedBox(height: 24),
                      _buildFooter(),
                      const SizedBox(height: 40), // Space for bottom nav
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

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -1.2),
          radius: 1.2,
          colors: [
            AppColors.orangePrimary.withOpacity(0.13),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.orangePrimary.withOpacity(0.4),
                      blurRadius: 32,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const CustomAvatar(
                  radius: 48,
                  fallbackText: 'JD',
                  backgroundColor: AppColors.orangePrimary,
                  foregroundColor: Colors.white,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt_outlined, size: 13, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'John Doe',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.edit_outlined, size: 12, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'john.doe@example.com',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge(Icons.emoji_events_outlined, 'Pro Driver', AppColors.orangeSecondary),
              const SizedBox(width: 8),
              _buildBadge(Icons.check_circle_outline, 'Member since 2024', AppColors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsDashboard() {
    final stats = [
      {'label': 'Vehicles', 'value': '3', 'accent': AppColors.orangePrimary, 'sub': 'linked'},
      {'label': 'Services', 'value': '18', 'accent': AppColors.cyan, 'sub': 'logged'},
      {'label': 'Saved', 'value': '\$1.2K', 'accent': AppColors.green, 'sub': 'in costs'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: stats.asMap().entries.map((entry) {
              final int idx = entry.key;
              final Map<String, dynamic> s = entry.value;
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: idx > 0
                        ? const Border(left: BorderSide(color: AppColors.borderLight))
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        s['value'] as String,
                        style: TextStyle(
                          color: s['accent'] as Color,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        s['label'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        s['sub'] as String,
                        style: const TextStyle(color: AppColors.textDim, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildVehicleSection() {
    final bool isOpen = _openSection == 'vehicles';
    return _buildExpandableContainer(
      isOpen: isOpen,
      header: _buildRow(
        icon: Icons.directions_car_outlined,
        accent: AppColors.orangePrimary,
        label: 'Vehicle Preferences',
        subtitle: '3 vehicles linked',
        onTap: () => _toggleSection('vehicles'),
        trailing: Icon(
          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: 16,
          color: isOpen ? AppColors.orangePrimary : AppColors.surfaceLight2,
        ),
        showBottomBorder: isOpen,
      ),
      children: [
        _buildSubVehicleItem('Toyota Camry', 'Sedan · ABC-1234', AppColors.orangeSecondary),
        _buildSubVehicleItem('Honda CBR 600RR', 'Motorcycle · XYZ-5678', AppColors.green),
        _buildSubVehicleItem('Ford Explorer', 'SUV · LMN-9012', AppColors.red),
        _buildAddAction('+ Add new vehicle'),
      ],
    );
  }

  Widget _buildNotificationSection() {
    final bool isOpen = _openSection == 'notifs';
    return _buildExpandableContainer(
      isOpen: isOpen,
      header: _buildRow(
        icon: Icons.notifications_none,
        accent: AppColors.cyan,
        label: 'Notifications',
        subtitle: 'Configure your alerts',
        onTap: () => _toggleSection('notifs'),
        trailing: Icon(
          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: 16,
          color: isOpen ? AppColors.cyan : AppColors.surfaceLight2,
        ),
        showBottomBorder: isOpen,
      ),
      children: [
        _buildToggleSubRow(
          'Push Notifications',
          _pushNotifs,
          (val) => setState(() => _pushNotifs = val),
          accent: AppColors.cyan,
        ),
        _buildToggleSubRow(
          'Service Reminders',
          _serviceReminders,
          (val) => setState(() => _serviceReminders = val),
          accent: AppColors.cyan,
        ),
        _buildToggleSubRow(
          'Critical Alerts',
          _criticalAlerts,
          (val) => setState(() => _criticalAlerts = val),
          accent: AppColors.red,
          showBottomBorder: false,
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    final bool isOpen = _openSection == 'security';
    return _buildExpandableContainer(
      isOpen: isOpen,
      header: _buildRow(
        icon: Icons.shield_outlined,
        accent: AppColors.green,
        label: 'Privacy & Security',
        subtitle: _twoFA ? '2FA active · Protected' : 'Password, 2FA',
        onTap: () => _toggleSection('security'),
        trailing: Icon(
          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: 16,
          color: isOpen ? AppColors.green : AppColors.surfaceLight2,
        ),
        showBottomBorder: isOpen,
      ),
      children: [
        _buildSecurityActionButton(
          'Password Reset',
          'Last changed 30 days ago',
          Icons.vpn_key_outlined,
          'Reset',
        ),
        _buildToggleSubRow(
          'Two-Factor Auth (2FA)',
          _twoFA,
          (val) => setState(() => _twoFA = val),
          accent: AppColors.green,
          subtitle: _twoFA ? '● Enabled' : '○ Disabled — tap to enable',
          showBottomBorder: false,
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection() {
    final bool isOpen = _openSection == 'settings';
    return _buildExpandableContainer(
      isOpen: isOpen,
      header: _buildRow(
        icon: Icons.settings_outlined,
        accent: AppColors.accent,
        label: 'App Settings',
        subtitle: 'Theme: ${_theme == 'dark' ? 'Dark' : 'Light'} · Language: $_language',
        onTap: () => _toggleSection('settings'),
        trailing: Icon(
          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          size: 16,
          color: isOpen ? AppColors.accent : AppColors.surfaceLight2,
        ),
        showBottomBorder: isOpen,
      ),
      children: [
        _buildSelectionSubRow(
          'Theme',
          ['dark', 'light'],
          (val) => setState(() => _theme = val),
          _theme,
          accent: AppColors.accent,
        ),
        _buildSelectionSubRow(
          'Language',
          ['EN', 'ES'],
          (val) => setState(() => _language = val),
          _language,
          accent: AppColors.accent,
          showBottomBorder: false,
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    final bool isOpen = _openSection == 'support';
    return _buildExpandableContainer(
      isOpen: isOpen,
      header: Column(
        children: [
          _buildRow(
            icon: Icons.star_outline,
            accent: AppColors.orangeSecondary,
            label: 'Rate DriveTrack',
            subtitle: 'Share your experience',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) => const Icon(Icons.star, size: 12, color: AppColors.orangeSecondary)),
            ),
          ),
          _buildRow(
            icon: Icons.help_outline,
            accent: AppColors.textMuted,
            label: 'Help & Support',
            subtitle: 'FAQs, Contact us',
            onTap: () => _toggleSection('support'),
            trailing: Icon(
              isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 16,
              color: isOpen ? AppColors.textMuted : AppColors.surfaceLight2,
            ),
            showBottomBorder: isOpen,
            borderBottom: false,
          ),
        ],
      ),
      children: [
        _buildSimpleSubRow('FAQs', Icons.bookmark_border),
        _buildSimpleSubRow('Chat Support', Icons.chat_bubble_outline),
        _buildSimpleSubRow('+1 (800) DRIVE-TK', Icons.phone_outlined, showBottomBorder: false),
      ],
    );
  }

  Widget _buildExpandableContainer({required bool isOpen, required Widget header, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          header,
          if (isOpen) ...children,
        ],
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required Color accent,
    required String label,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool borderBottom = true,
    bool showBottomBorder = true,
  }) {
    return CustomListCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: borderBottom && showBottomBorder
              ? const Border(bottom: BorderSide(color: AppColors.borderLight))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: accent.withOpacity(0.2)),
              ),
              child: Icon(icon, color: accent, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  if (subtitle != null)
                    Text(subtitle, style: const TextStyle(color: AppColors.textDark, fontSize: 12)),
                ],
              ),
            ),
            if (trailing != null) trailing else const Icon(Icons.chevron_right, size: 16, color: AppColors.surfaceLight2),
          ],
        ),
      ),
    );
  }

  Widget _buildSubVehicleItem(String name, String details, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Icon(Icons.directions_car, color: color, size: 14),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(details, style: const TextStyle(color: AppColors.textDim, fontSize: 11)),
                ],
              ),
            ],
          ),
          const Icon(Icons.chevron_right, size: 14, color: AppColors.surfaceLight2),
        ],
      ),
    );
  }

  Widget _buildAddAction(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: AppColors.background,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: AppColors.orangePrimary, fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildToggleSubRow(String label, bool value, ValueChanged<bool> onChanged, {required Color accent, String? subtitle, bool showBottomBorder = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: showBottomBorder ? const Border(bottom: BorderSide(color: AppColors.borderLight)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              if (subtitle != null)
                Text(subtitle, style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
          CustomSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityActionButton(String label, String sub, IconData icon, String action) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.green.withOpacity(0.2)),
                ),
                child: Icon(icon, color: AppColors.green, size: 15),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(sub, style: const TextStyle(color: AppColors.textDim, fontSize: 11)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.green.withOpacity(0.2)),
            ),
            child: Text(action, style: const TextStyle(color: AppColors.green, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionSubRow(String label, List<String> options, ValueChanged<String> onSelect, String current, {required Color accent, bool showBottomBorder = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: showBottomBorder ? const Border(bottom: BorderSide(color: AppColors.borderLight)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: options.map((opt) {
              final bool isSelected = opt == current;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelect(opt),
                  child: Container(
                    margin: EdgeInsets.only(right: opt == options.last ? 0 : 8),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? accent.withOpacity(0.12) : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? accent.withOpacity(0.4) : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          opt == 'dark' ? Icons.dark_mode_outlined : (opt == 'light' ? Icons.light_mode_outlined : Icons.language),
                          size: 14,
                          color: isSelected ? accent : AppColors.textDark,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          opt.toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? accent : AppColors.textDark,
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.check, size: 12, color: accent),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleSubRow(String label, IconData icon, {bool showBottomBorder = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: showBottomBorder ? const Border(bottom: BorderSide(color: AppColors.borderLight)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            ],
          ),
          const Icon(Icons.open_in_new, size: 13, color: AppColors.surfaceLight2),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return CustomButton(
      onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
      variant: ButtonVariant.destructive,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.logout, color: Colors.white, size: 19),
          SizedBox(width: 10),
          Text(
            'Sign Out',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: const [
          Text('DriveTrack v1.0.0', style: TextStyle(color: AppColors.textDark, fontSize: 11)),
          SizedBox(height: 4),
          Text('Made with ❤️ for drivers', style: TextStyle(color: AppColors.textDark, fontSize: 11)),
        ],
      ),
    );
  }
}
