import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'notifications_page.dart';
import '../widgets/garage/add_vehicle_sheet.dart';
import '../widgets/garage/weather_widget.dart';
import '../widgets/garage/vehicle_detail_sheet.dart';
import '../widgets/maintenance/add_service_sheet.dart';
import '../widgets/ui/custom_list_card.dart';
import '../widgets/ui/premium_fab.dart';
import '../widgets/ui/summary_stats.dart';
import '../widgets/ui/custom_button.dart';

class GaragePage extends StatefulWidget {
  const GaragePage({super.key});

  @override
  State<GaragePage> createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  final List<Map<String, dynamic>> _vehicles = [
    {
      'id': 'v1',
      'name': 'Toyota Camry',
      'plate': 'ABC-1234',
      'type': 'Sedan',
      'mileage': 42000,
      'maxMileage': 50000,
      'image': 'https://images.unsplash.com/photo-1666887509163-9644127848b9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb2Rlcm4lMjBjYXIlMjBkYXJrJTIwc2hvd3RpbWUlMjBzaWRlJTIwdmlld3xlbnwxfHx8fDE3NzMyNDY3MDl8MA&ixlib=rb-4.1.0&q=80&w=1080',
      'nextService': 'Oil Change in 3,000 mi',
      'status': 'warning',
      'color': AppColors.orangeSecondary,
    },
    {
      'id': 'v2',
      'name': 'Honda CBR 600RR',
      'plate': 'XYZ-5678',
      'type': 'Motorcycle',
      'mileage': 12500,
      'maxMileage': 50000,
      'image': 'https://images.unsplash.com/photo-1588486624469-ad668ac8e1d8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzcG9ydHMlMjBtb3RvcmN5Y2xlJTIwZGFyayUyMGJhY2tncm91bmR8ZW58MXx8fHwxNzczMjQ2NzA5fDA&ixlib=rb-4.1.0&q=80&w=1080',
      'nextService': 'All services up to date',
      'status': 'good',
      'color': AppColors.green,
    },
  ];

  late ScrollController _scrollController;
  bool _isFabExtended = true;
  String? _selectedVehicleId;
  bool _sheetExpanded = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.offset > 50 && _isFabExtended) {
          setState(() => _isFabExtended = false);
        } else if (_scrollController.offset <= 50 && !_isFabExtended) {
          setState(() => _isFabExtended = true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleAddVehicle(Map<String, dynamic> newV) {
    setState(() {
      _vehicles.insert(0, {
        'id': 'v${DateTime.now().millisecondsSinceEpoch}',
        'name': '${newV['brand']} ${newV['model']}',
        'plate': newV['plate'],
        'type': newV['type'] == 'car' ? 'Car' : 'Motorcycle',
        'mileage': int.tryParse(newV['mileage'] ?? '0') ?? 0,
        'maxMileage': 50000,
        'image': newV['type'] == 'car'
            ? 'https://images.unsplash.com/photo-1760520830355-e6be53e41c2f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxTVVYlMjBibGFjayUyMGNhciUyMHByb2Zlc3Npb25hbCUyMHN0dWRpb3xlbnwxfHx8fDE3NzMyNDY3MTF8MA&ixlib=rb-4.1.0&q=80&w=1080'
            : 'https://images.unsplash.com/photo-1588486624469-ad668ac8e1d8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzcG9ydHMlMjBtb3RvcmN5Y2xlJTIwZGFyayUyMGJhY2tncm91bmR8ZW58MXx8fHwxNzczMjQ2NzA5fDA&ixlib=rb-4.1.0&q=80&w=1080',
        'nextService': 'Check health soon',
        'status': 'good',
        'color': AppColors.green,
      });
    });
  }

  void _showAddVehicleSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddVehicleSheet(onSave: _handleAddVehicle),
    );
  }

  void _handleLogService(String vehicleName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddServiceSheet(
        vehicles: [vehicleName],
        onSave: (data) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Service logged for $vehicleName'),
              backgroundColor: AppColors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _handleRemoveVehicle(String vehicleId) {
    final vehicle = _vehicles.firstWhere((v) => v['id'] == vehicleId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Remove Vehicle?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        content: Text(
          'Are you sure you want to remove ${vehicle['name']}? This action cannot be undone.',
          style: const TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _vehicles.removeWhere((v) => v['id'] == vehicleId);
                _selectedVehicleId = null;
                _sheetExpanded = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${vehicle['name']} removed'),
                  backgroundColor: AppColors.orangePrimary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _handleEditVehicle(String vehicleId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit feature coming soon! 🚧'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Content
          Positioned.fill(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 80,
                    left: 20,
                    right: 20,
                    bottom: 100,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const WeatherWidget(),
                              const SizedBox(height: 24),
                              _buildQuickStats(),
                              const SizedBox(height: 32),
                              _buildVehiclesSection(),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          
          // Fixed Glass Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildFixedHeader(context),
          ),

          // Vehicle Detail Sheet overlay
          if (_selectedVehicleId != null) ...[
            GestureDetector(
              onTap: () => setState(() {
                _selectedVehicleId = null;
                _sheetExpanded = false;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: Colors.black.withOpacity(_sheetExpanded ? 0.6 : 0.3),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: VehicleDetailSheet(
                vehicle: _vehicles.firstWhere((v) => v['id'] == _selectedVehicleId),
                isExpanded: _sheetExpanded,
                onToggle: () => setState(() => _sheetExpanded = !_sheetExpanded),
                onClose: () => setState(() {
                  _selectedVehicleId = null;
                  _sheetExpanded = false;
                }),
                onLogService: () => _handleLogService(_vehicles.firstWhere((v) => v['id'] == _selectedVehicleId)['name']),
                onEdit: () => _handleEditVehicle(_selectedVehicleId!),
                onRemove: () => _handleRemoveVehicle(_selectedVehicleId!),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: _selectedVehicleId != null ? null : Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Align(
            alignment: Alignment.bottomRight,
            child: PremiumFAB(
              onPressed: _showAddVehicleSheet,
              label: 'Add Vehicle',
              icon: Icons.add,
              isExtended: _isFabExtended,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFixedHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return ClipRRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.7),
            border: Border(
              bottom: BorderSide(color: AppColors.border.withOpacity(0.5)),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, topPadding + 10, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Good morning,',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                        ),
                        Text(
                          'My Garage 🚗',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    _buildIconButton(
                      Icons.notifications_none,
                      2,
                      onTap: () => Navigator.of(context).pushNamed('/notifications'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, int count, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: AppColors.textSecondary, size: 20),
          ),
          if (count > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCountBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cyan.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cyan.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: AppColors.cyan, size: 12),
          const SizedBox(width: 4),
          Text(
            '$count Vehicles',
            style: const TextStyle(
              color: AppColors.cyan,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    if (_vehicles.isEmpty) {
      final stats = [
        StatItem(label: 'Total Miles', value: '0', accent: AppColors.orangePrimary),
        StatItem(label: 'Services Due', value: '0', accent: AppColors.red),
        StatItem(label: 'Avg Health', value: '0%', accent: AppColors.green),
      ];
      return SummaryStats(stats: stats);
    }

    final totalMiles = _vehicles.fold<int>(0, (sum, v) => sum + (v['mileage'] as int));
    final servicesDue = _vehicles.where((v) => v['status'] != 'good').length;
    final totalHealth = _vehicles.fold<double>(0, (sum, v) {
      final health = (100 - ((v['mileage'] as int) / (v['maxMileage'] as int) * 100)).toDouble();
      return sum + health;
    });
    final avgHealth = (totalHealth / _vehicles.length).round();

    final stats = [
      StatItem(
        label: 'Total Miles', 
        value: totalMiles > 1000 ? '${(totalMiles / 1000).toStringAsFixed(1)}K' : totalMiles.toString(), 
        accent: AppColors.orangePrimary
      ),
      StatItem(label: 'Services Due', value: servicesDue.toString(), accent: AppColors.red),
      StatItem(label: 'Avg Health', value: '$avgHealth%', accent: AppColors.green),
    ];

    return SummaryStats(stats: stats);
  }

  Widget _buildVehiclesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Vehicles',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            _buildCountBadge(_vehicles.length),
          ],
        ),
        const SizedBox(height: 16),
        if (_vehicles.isEmpty)
          _buildEmptyState()
        else
          ..._vehicles.map((v) => _buildVehicleCard(v)).toList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.orangePrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_car_outlined, size: 48, color: AppColors.orangePrimary),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your Garage is Empty',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tap the button below to add your first vehicle\nand start tracking its performance.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> v) {
    final Color color = v['color'];
    final double healthPct = (100 - ((v['mileage'] as int) / (v['maxMileage'] as int) * 100)).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: CustomListCard(
        onTap: () {
          setState(() {
            _selectedVehicleId = v['id'];
            _sheetExpanded = false;
          });
        },
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Image / Top Area
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    v['image'],
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        AppColors.surface.withOpacity(0.95),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(v['status'] == 'good' ? Icons.shield_outlined : Icons.warning_amber_rounded, size: 12, color: color),
                        const SizedBox(width: 4),
                        Text(
                          v['status'] == 'good' ? 'Healthy' : (v['status'] == 'warning' ? 'Due Soon' : 'Overdue'),
                          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      v['type'],
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            v['name'],
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.orangePrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.orangePrimary.withOpacity(0.2)),
                            ),
                            child: Text(
                              v['plate'],
                              style: const TextStyle(
                                color: AppColors.orangePrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.orangePrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.orangePrimary.withOpacity(0.2)),
                        ),
                        child: const Icon(Icons.chevron_right, color: AppColors.orangePrimary, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Health Bar
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Vehicle Health', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w500)),
                          Text('${healthPct.round()}%', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: healthPct / 100,
                          minHeight: 6,
                          backgroundColor: AppColors.divider,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${v['mileage'].toString()} mi', style: const TextStyle(color: AppColors.textDim, fontSize: 11)),
                          Text('Limit ${v['maxMileage'].toString()} mi', style: const TextStyle(color: AppColors.textDim, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Next Service
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.bolt, color: color, size: 14),
                        const SizedBox(width: 8),
                        Text(
                          v['nextService'],
                          style: const TextStyle(color: Color(0xFF7A7A8A), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
