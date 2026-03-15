import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/maintenance/add_service_sheet.dart';
import '../widgets/maintenance/service_detail_sheet.dart';
import '../widgets/ui/custom_list_card.dart';
import '../widgets/ui/premium_fab.dart';
import '../widgets/ui/summary_stats.dart';
import '../widgets/ui/filter_pills.dart';

class ServiceEntry {
  final String id;
  final String vehicle;
  final String service;
  final String category;
  final DateTime date;
  final double cost;
  final int mileage;
  final String? notes;
  final IconData icon;
  final Color accent;

  ServiceEntry({
    required this.id,
    required this.vehicle,
    required this.service,
    required this.category,
    required this.date,
    required this.cost,
    required this.mileage,
    this.notes,
    required this.icon,
    required this.accent,
  });
}

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  String _activeFilter = 'All Vehicles';
  final List<String> _filters = ['All Vehicles', 'Toyota Camry', 'Honda CBR 600RR', 'Ford Explorer'];
  late ScrollController _scrollController;
  bool _isFabExtended = true;
  String? _selectedServiceId;
  bool _sheetExpanded = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && _isFabExtended) {
        setState(() => _isFabExtended = false);
      } else if (_scrollController.offset <= 50 && !_isFabExtended) {
        setState(() => _isFabExtended = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<ServiceEntry> _entries = [
    ServiceEntry(
      id: 's1',
      vehicle: 'Toyota Camry',
      service: 'Oil Change',
      category: 'Engine',
      date: DateTime(2026, 2, 15),
      cost: 89.99,
      mileage: 41500,
      notes: 'Synthetic 5W-30, filter replaced',
      icon: Icons.opacity,
      accent: AppColors.orangePrimary,
    ),
    ServiceEntry(
      id: 's2',
      vehicle: 'Ford Explorer',
      service: 'Tire Rotation',
      category: 'Tires',
      date: DateTime(2026, 1, 28),
      cost: 45.00,
      mileage: 47800,
      icon: Icons.adjust,
      accent: AppColors.cyan,
    ),
    ServiceEntry(
      id: 's3',
      vehicle: 'Honda CBR 600RR',
      service: 'Air Filter Replacement',
      category: 'Air System',
      date: DateTime(2026, 1, 10),
      cost: 32.50,
      mileage: 12000,
      notes: 'K&N high-performance filter',
      icon: Icons.air,
      accent: AppColors.purple,
    ),
    ServiceEntry(
      id: 's4',
      vehicle: 'Toyota Camry',
      service: 'Battery Replacement',
      category: 'Electrical',
      date: DateTime(2025, 12, 22),
      cost: 159.00,
      mileage: 40200,
      notes: 'AGM 12V 70Ah — 3-year warranty',
      icon: Icons.battery_charging_full,
      accent: AppColors.green,
    ),
  ];

  void _handleAddService(Map<String, dynamic> data) {
    setState(() {
      _entries.insert(0, ServiceEntry(
        id: 's${DateTime.now().millisecondsSinceEpoch}',
        vehicle: data['vehicle'],
        service: data['service'],
        category: 'General',
        date: data['date'],
        cost: data['cost'],
        mileage: data['mileage'],
        notes: data['notes'],
        icon: Icons.build_circle_rounded,
        accent: AppColors.orangePrimary,
      ));
    });
  }

  void _showAddServiceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddServiceSheet(
        vehicles: _filters.where((f) => f != 'All Vehicles').toList(),
        onSave: _handleAddService,
      ),
    );
  }

  void _handleRemoveEntry(String entryId) {
    final entry = _entries.firstWhere((e) => e.id == entryId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Remove Entry?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        content: Text(
          'Are you sure you want to remove the record for "${entry.service}"? This action cannot be undone.',
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
                _entries.removeWhere((e) => e.id == entryId);
                _selectedServiceId = null;
                _sheetExpanded = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Service record removed'),
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

  void _handleEditEntry(String entryId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit entry coming soon! 🚧'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _activeFilter == 'All Vehicles' 
        ? _entries 
        : _entries.where((e) => e.vehicle == _activeFilter).toList();
    
    final totalSpent = filtered.fold<double>(0, (sum, e) => sum + e.cost);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: [
                        _buildHeader(),
                        Expanded(
                          child: ListView(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            children: [
                              _buildSummary(totalSpent, filtered.length),
                              const SizedBox(height: 20),
                              FilterPills(
                                filters: _filters,
                                activeFilter: _activeFilter,
                                onFilterChanged: (f) => setState(() => _activeFilter = f),
                              ),
                              const SizedBox(height: 20),
                              if (filtered.isEmpty)
                                _buildEmptyState()
                              else
                                ...filtered.map((e) => _buildServiceCard(e)).toList(),
                              const SizedBox(height: 100), // Space for FAB
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          if (_selectedServiceId != null) ...[
            GestureDetector(
              onTap: () => setState(() {
                _selectedServiceId = null;
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
              child: ServiceDetailSheet(
                service: (() {
                  final e = _entries.firstWhere((e) => e.id == _selectedServiceId);
                  return {
                    'id': e.id,
                    'vehicle': e.vehicle,
                    'service': e.service,
                    'category': e.category,
                    'date': e.date,
                    'cost': e.cost,
                    'mileage': e.mileage,
                    'notes': e.notes,
                    'icon': e.icon,
                    'accent': e.accent,
                  };
                })(),
                isExpanded: _sheetExpanded,
                onToggle: () => setState(() => _sheetExpanded = !_sheetExpanded),
                onClose: () => setState(() {
                  _selectedServiceId = null;
                  _sheetExpanded = false;
                }),
                onEdit: () => _handleEditEntry(_selectedServiceId!),
                onRemove: () => _handleRemoveEntry(_selectedServiceId!),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: _selectedServiceId != null ? null : Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Align(
            alignment: Alignment.bottomRight,
            child: PremiumFAB(
              onPressed: _showAddServiceSheet,
              label: 'Add Service',
              icon: Icons.add,
              isExtended: _isFabExtended,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Maintenance Log 🔧',
            style: TextStyle(
              color: AppColors.textMain,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Full service history for your vehicles',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(double totalSpent, int count) {
    final stats = [
      StatItem(label: 'Total Spent', value: '\$${totalSpent.toStringAsFixed(0)}', accent: AppColors.green),
      StatItem(label: 'Services', value: '$count', accent: AppColors.orangePrimary),
      StatItem(label: 'Vehicles', value: '3', accent: AppColors.cyan),
    ];

    return SummaryStats(stats: stats);
  }

  Widget _buildServiceCard(ServiceEntry entry) {
    return Column(
      children: [
        CustomListCard(
          onTap: () {
            setState(() {
              _selectedServiceId = entry.id;
              _sheetExpanded = false;
            });
          },
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: entry.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: entry.accent.withOpacity(0.2)),
                  ),
                  child: Icon(entry.icon, color: entry.accent, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.service,
                                  style: const TextStyle(color: AppColors.textMain, fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.directions_car, size: 12, color: AppColors.textDark),
                                    const SizedBox(width: 4),
                                    Text(entry.vehicle, style: const TextStyle(color: AppColors.textDark, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${entry.cost.toStringAsFixed(2)}',
                                style: const TextStyle(color: AppColors.green, fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                              const Text('USD', style: TextStyle(color: AppColors.textDark, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildMeta(Icons.calendar_today, DateFormat('MMM d, y').format(entry.date)),
                          const SizedBox(width: 12),
                          Container(width: 1, height: 12, color: AppColors.borderLight),
                          const SizedBox(width: 12),
                          _buildMeta(Icons.speed, '${NumberFormat('#,###').format(entry.mileage)} mi'),
                        ],
                      ),
                      if (entry.notes != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            entry.notes!,
                            style: const TextStyle(color: Color(0xFF7A7A8A), fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildMeta(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Color(0xFF7A7A8A), fontSize: 12)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: const [
          Icon(Icons.build_circle_outlined, size: 48, color: AppColors.borderLight),
          SizedBox(height: 12),
          Text('No records for this vehicle', style: TextStyle(color: AppColors.textDark, fontSize: 14)),
        ],
      ),
    );
  }
}
