import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/appointment_service.dart';
import '../models/doctor.dart';
import 'doctor_detail_screen.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Doctor> _filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appointmentService = context.read<AppointmentService>();
      setState(() {
        _filteredDoctors = appointmentService.doctors;
      });
    });
  }

  void _filterDoctors(String query) {
    final appointmentService = context.read<AppointmentService>();
    setState(() {
      _filteredDoctors = appointmentService.searchDoctors(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
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
                    child: _buildContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Doctors',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Book appointments with specialists',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Test button for debugging
          IconButton(
            onPressed: _testUrlLauncher,
            icon: const Icon(
              Icons.bug_report,
              color: Colors.white,
              size: 24,
            ),
            tooltip: 'Test URL Launcher',
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: _filteredDoctors.isEmpty
              ? _buildEmptyState()
              : _buildDoctorsList(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _filterDoctors,
          decoration: InputDecoration(
            hintText: 'Search doctors, specializations, or locations...',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
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
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No doctors found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _filteredDoctors.length,
      itemBuilder: (context, index) {
        return _buildDoctorCard(_filteredDoctors[index]);
      },
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorDetailScreen(doctor: doctor),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildDoctorAvatar(doctor),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDoctorInfo(doctor),
                    ),
                    _buildRatingBadge(doctor),
                  ],
                ),
                const SizedBox(height: 16),
                _buildActionButtons(doctor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorAvatar(Doctor doctor) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: doctor.imageUrl.isNotEmpty
            ? Image.network(
                doctor.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackAvatar(doctor);
                },
              )
            : _buildFallbackAvatar(doctor),
      ),
    );
  }

  Widget _buildFallbackAvatar(Doctor doctor) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          doctor.name.split(' ').map((e) => e[0]).join(''),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorInfo(Doctor doctor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doctor.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            doctor.specialization,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6366F1),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 16,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                doctor.location,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.work,
              size: 16,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              '${doctor.experience} years exp.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingBadge(Doctor doctor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF10B981),
            Color(0xFF059669),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            doctor.rating.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Doctor doctor) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _makePhoneCall(doctor.phone),
            icon: const Icon(Icons.phone, size: 16),
            label: const Text(
              'Call',
              style: TextStyle(fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _openWhatsApp(doctor.whatsapp, doctor.name),
            icon: const Icon(Icons.chat, size: 16),
            label: const Text(
              'WhatsApp',
              style: TextStyle(fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailScreen(doctor: doctor),
                ),
              );
            },
            icon: const Icon(Icons.calendar_today, size: 16),
            label: const Text(
              'Book',
              style: TextStyle(fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      // Clean the phone number - remove spaces, dashes, and other characters
      final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
      
      print('Original phone: $phoneNumber, Cleaned: $cleanPhone');
      
      // Try to launch directly without checking canLaunchUrl first
      try {
        final phoneUri = Uri.parse('tel:$cleanPhone');
        print('Trying to launch phone URI: $phoneUri');
        
        await launchUrl(
          phoneUri, 
          mode: LaunchMode.externalApplication,
        );
        _showSuccessSnackBar('Opening phone dialer...');
        return;
      } catch (e) {
        print('Direct launch failed: $e');
      }
      
      // Fallback: try alternative URI formats
      final fallbackUris = [
        Uri(scheme: 'tel', path: cleanPhone),
        Uri.parse('tel://$cleanPhone'),
      ];
      
      for (final uri in fallbackUris) {
        try {
          print('Trying fallback URI: $uri');
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          _showSuccessSnackBar('Opening phone dialer...');
          return;
        } catch (e) {
          print('Fallback URI failed: $e');
          continue;
        }
      }
      
      // Last resort: try to open empty dialer
      try {
        final emptyDialerUri = Uri(scheme: 'tel');
        await launchUrl(emptyDialerUri, mode: LaunchMode.externalApplication);
        _showSuccessSnackBar('Opening phone dialer...');
      } catch (e) {
        print('Empty dialer failed: $e');
        _showErrorSnackBar('Phone dialer not available on this device');
      }
      
    } catch (e) {
      print('Phone call error: $e');
      _showErrorSnackBar('Error making phone call: $e');
    }
  }

    Future<void> _openWhatsApp(String phoneNumber, String doctorName) async {
    try {
      // Clean the phone number - remove spaces, dashes, and other characters
      final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
      
      // Remove + if it's the first character for WhatsApp
      final whatsappPhone = cleanPhone.startsWith('+') ? cleanPhone.substring(1) : cleanPhone;
      
      print('Original WhatsApp phone: $phoneNumber, Cleaned: $cleanPhone, WhatsApp: $whatsappPhone');
      
      final message = "Hello Dr. $doctorName, I would like to book an appointment with you.";
      
      // Try to launch WhatsApp directly without checking canLaunchUrl first
      final whatsappUrls = [
        "https://wa.me/$whatsappPhone?text=${Uri.encodeComponent(message)}",
        "whatsapp://send?phone=$whatsappPhone&text=${Uri.encodeComponent(message)}",
        "https://api.whatsapp.com/send?phone=$whatsappPhone&text=${Uri.encodeComponent(message)}",
      ];
      
      for (final url in whatsappUrls) {
        try {
          final uri = Uri.parse(url);
          print('Trying WhatsApp URL: $url');
          
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          _showSuccessSnackBar('Opening WhatsApp...');
          return;
        } catch (e) {
          print('WhatsApp URL failed: $url - $e');
          continue;
        }
      }
      
      // If WhatsApp app fails, try WhatsApp Web
      try {
        final webUrl = "https://web.whatsapp.com/send?phone=$whatsappPhone&text=${Uri.encodeComponent(message)}";
        final webUri = Uri.parse(webUrl);
        
        print('Trying WhatsApp Web: $webUrl');
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        _showSuccessSnackBar('Opening WhatsApp Web...');
      } catch (e) {
        print('WhatsApp Web failed: $e');
        _showErrorSnackBar('WhatsApp is not available on this device');
      }
      
    } catch (e) {
      print('WhatsApp error: $e');
      _showErrorSnackBar('Error opening WhatsApp: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Test function to debug URL launcher
  Future<void> _testUrlLauncher() async {
    try {
      // Test 1: Simple tel URI
      print('Testing simple tel URI...');
      final testUri = Uri.parse('tel:+1234567890');
      await launchUrl(testUri, mode: LaunchMode.externalApplication);
      _showSuccessSnackBar('Test 1: Simple tel URI launched');
    } catch (e) {
      print('Test 1 failed: $e');
      _showErrorSnackBar('Test 1 failed: $e');
    }
    
    // Wait a bit before next test
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      // Test 2: WhatsApp URI
      print('Testing WhatsApp URI...');
      final whatsappUri = Uri.parse('https://wa.me/1234567890?text=Test');
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      _showSuccessSnackBar('Test 2: WhatsApp URI launched');
    } catch (e) {
      print('Test 2 failed: $e');
      _showErrorSnackBar('Test 2 failed: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 