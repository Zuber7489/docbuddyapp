 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/appointment_service.dart';
import '../models/appointment.dart';
import '../models/doctor.dart';
import 'login_screen.dart';

class DoctorAdminScreen extends StatefulWidget {
  const DoctorAdminScreen({super.key});

  @override
  State<DoctorAdminScreen> createState() => _DoctorAdminScreenState();
}

class _DoctorAdminScreenState extends State<DoctorAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'pending';
  
  // Cache filtered appointments to avoid recalculation
  Map<String, List<Appointment>> _filteredAppointmentsCache = {};
  List<Appointment> _currentAppointments = [];
  String? _currentDoctorId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      final newFilter = _getFilterForIndex(_tabController.index);
      if (newFilter != _selectedFilter) {
        setState(() {
          _selectedFilter = newFilter;
        });
      }
    }
  }

  String _getFilterForIndex(int index) {
    switch (index) {
      case 0: return 'pending';
      case 1: return 'confirmed';
      case 2: return 'completed';
      default: return 'pending';
    }
  }

  List<Appointment> _getFilteredAppointments(List<Appointment> appointments, String doctorId) {
    // Check cache first
    if (_filteredAppointmentsCache.containsKey(_selectedFilter) && 
        _currentAppointments == appointments && _currentDoctorId == doctorId) {
      return _filteredAppointmentsCache[_selectedFilter]!;
    }

    // Update cache
    _currentAppointments = appointments;
    _currentDoctorId = doctorId;
    
    final doctorAppointments = appointments.where((app) => app.doctor.id == doctorId).toList();
    List<Appointment> filtered;
    
    switch (_selectedFilter) {
      case 'pending':
        filtered = doctorAppointments.where((app) => app.status == 'pending').toList();
        break;
      case 'confirmed':
        filtered = doctorAppointments.where((app) => app.status == 'confirmed').toList();
        break;
      case 'completed':
        filtered = doctorAppointments.where((app) => 
          app.status == 'completed' || app.date.isBefore(DateTime.now())).toList();
        break;
      default:
        filtered = doctorAppointments;
    }
    
    _filteredAppointmentsCache[_selectedFilter] = filtered;
    return filtered;
  }

  Future<void> _updateAppointmentStatus(Appointment appointment, String status) async {
    try {
      await context.read<AppointmentService>().updateAppointmentStatus(appointment.id, status);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment ${status.toLowerCase()} successfully'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating appointment: $e'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final doctorId = authService.getDoctorId();

    if (doctorId == null) {
      return const Scaffold(
        body: Center(
          child: Text('Doctor ID not found'),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(authService),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: _buildContent(doctorId),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AuthService authService) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${authService.currentUser?.name ?? 'Doctor'}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your appointments and schedule',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: const Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 24,
              ),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                authService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Color(0xFFEF4444)),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String doctorId) {
    return Column(
      children: [
        _buildTabBar(),
        Expanded(
          child: Consumer<AppointmentService>(
            builder: (context, appointmentService, child) {
              final filteredAppointments = _getFilteredAppointments(
                appointmentService.appointments,
                doctorId,
              );
              
              if (filteredAppointments.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: filteredAppointments.length,
                itemBuilder: (context, index) {
                  return _buildAppointmentCard(filteredAppointments[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: TabBar(
          controller: _tabController,
          onTap: (index) {
            // Tab change is handled by listener, no need for setState here
          },
          indicator: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorPadding: const EdgeInsets.all(2),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade600,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1).withOpacity(0.1),
                  const Color(0xFF8B5CF6).withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              _getEmptyStateIcon(),
              size: 80,
              color: const Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            _getEmptyStateMessage(),
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getEmptyStateIcon() {
    switch (_selectedFilter) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.calendar_today_outlined;
    }
  }

  String _getEmptyStateMessage() {
    switch (_selectedFilter) {
      case 'pending':
        return 'No pending appointments\nNew requests will appear here';
      case 'confirmed':
        return 'No confirmed appointments\nApproved appointments will appear here';
      case 'completed':
        return 'No completed appointments\nPast appointments will appear here';
      default:
        return 'No appointments found';
    }
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Info
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        appointment.patientPhone,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(appointment.status),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Appointment Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          Icons.calendar_today,
                          'Date',
                          DateFormat('MMM dd, yyyy').format(appointment.date),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoItem(
                          Icons.access_time,
                          'Time',
                          appointment.timeSlot,
                        ),
                      ),
                    ],
                  ),
                  if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      Icons.note,
                      'Notes',
                      appointment.notes!,
                      fullWidth: true,
                    ),
                  ],
                ],
              ),
            ),
            
            // Action Buttons
            if (appointment.status == 'pending') ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _updateAppointmentStatus(appointment, 'rejected'),
                      icon: const Icon(Icons.close),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444),
                        side: const BorderSide(color: Color(0xFFEF4444), width: 2),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateAppointmentStatus(appointment, 'confirmed'),
                      icon: const Icon(Icons.check),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            
            if (appointment.status == 'confirmed' && 
                appointment.date.isAfter(DateTime.now())) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _updateAppointmentStatus(appointment, 'completed'),
                  icon: const Icon(Icons.done_all),
                  label: const Text('Mark as Completed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, {bool fullWidth = false}) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: const Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;
    String text;

    switch (status) {
      case 'pending':
        color = const Color(0xFFF59E0B);
        icon = Icons.schedule;
        text = 'Pending';
        break;
      case 'confirmed':
        color = const Color(0xFF10B981);
        icon = Icons.check_circle;
        text = 'Confirmed';
        break;
      case 'completed':
        color = const Color(0xFF6366F1);
        icon = Icons.done_all;
        text = 'Completed';
        break;
      case 'rejected':
        color = const Color(0xFFEF4444);
        icon = Icons.cancel;
        text = 'Rejected';
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}