import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/doctor.dart';
import '../models/appointment.dart';

class AppointmentService extends ChangeNotifier {
  List<Doctor> _doctors = [];
  List<Appointment> _appointments = [];

  List<Doctor> get doctors => _doctors;
  List<Appointment> get appointments => _appointments;

  AppointmentService() {
    _loadDoctors();
    _loadAppointments();
  }

  void _loadDoctors() {
    // Mock data for doctors
    _doctors = [
      Doctor(
        id: '1',
        name: 'Dr. Sarah Johnson',
        specialization: 'Cardiologist',
        imageUrl: 'https://via.placeholder.com/150',
        rating: 4.8,
        experience: 15,
        location: 'Downtown Medical Center',
        availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
        availableTimeSlots: ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM'],
      ),
      Doctor(
        id: '2',
        name: 'Dr. Michael Chen',
        specialization: 'Dermatologist',
        imageUrl: 'https://via.placeholder.com/150',
        rating: 4.6,
        experience: 12,
        location: 'City Skin Clinic',
        availableDays: ['Monday', 'Wednesday', 'Friday'],
        availableTimeSlots: ['10:00 AM', '11:00 AM', '01:00 PM', '02:00 PM'],
      ),
      Doctor(
        id: '3',
        name: 'Dr. Emily Rodriguez',
        specialization: 'Pediatrician',
        imageUrl: 'https://via.placeholder.com/150',
        rating: 4.9,
        experience: 8,
        location: 'Children\'s Health Center',
        availableDays: ['Monday', 'Tuesday', 'Thursday', 'Saturday'],
        availableTimeSlots: ['09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM'],
      ),
      Doctor(
        id: '4',
        name: 'Dr. James Wilson',
        specialization: 'Orthopedic Surgeon',
        imageUrl: 'https://via.placeholder.com/150',
        rating: 4.7,
        experience: 20,
        location: 'Sports Medicine Institute',
        availableDays: ['Tuesday', 'Wednesday', 'Thursday', 'Friday'],
        availableTimeSlots: ['08:00 AM', '09:00 AM', '10:00 AM', '02:00 PM', '03:00 PM'],
      ),
    ];
  }

  Future<void> _loadAppointments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final appointmentsJson = prefs.getStringList('appointments') ?? [];
      _appointments = appointmentsJson
          .map((json) => Appointment.fromJson(jsonDecode(json)))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading appointments: $e');
    }
  }

  Future<void> _saveAppointments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final appointmentsJson = _appointments
          .map((appointment) => jsonEncode(appointment.toJson()))
          .toList();
      await prefs.setStringList('appointments', appointmentsJson);
    } catch (e) {
      debugPrint('Error saving appointments: $e');
    }
  }

  Future<void> bookAppointment(Appointment appointment) async {
    _appointments.add(appointment);
    await _saveAppointments();
    notifyListeners();
  }

  Future<void> cancelAppointment(String appointmentId) async {
    _appointments.removeWhere((appointment) => appointment.id == appointmentId);
    await _saveAppointments();
    notifyListeners();
  }

  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    final index = _appointments.indexWhere((appointment) => appointment.id == appointmentId);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(status: status);
      await _saveAppointments();
      notifyListeners();
    }
  }

  List<Appointment> getAppointmentsByDate(DateTime date) {
    return _appointments.where((appointment) {
      return appointment.date.year == date.year &&
          appointment.date.month == date.month &&
          appointment.date.day == date.day;
    }).toList();
  }

  List<Doctor> searchDoctors(String query) {
    if (query.isEmpty) return _doctors;
    
    return _doctors.where((doctor) {
      return doctor.name.toLowerCase().contains(query.toLowerCase()) ||
          doctor.specialization.toLowerCase().contains(query.toLowerCase()) ||
          doctor.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
} 