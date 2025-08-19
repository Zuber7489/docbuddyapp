 import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/doctor.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Pre-configured doctor accounts
  static const Map<String, Map<String, String>> doctorAccounts = {
    'cardio_dr': {
      'username': 'dr.sarah',
      'password': 'cardio123',
      'name': 'Dr. Sarah Johnson',
      'specialization': 'Cardiologist',
      'email': 'dr.sarah@docbuddy.com',
      'phone': '+1-555-0101',
    },
    'derma_dr': {
      'username': 'dr.michael',
      'password': 'derma456',
      'name': 'Dr. Michael Chen',
      'specialization': 'Dermatologist',
      'email': 'dr.michael@docbuddy.com',
      'phone': '+1-555-0102',
    },
    'pediatric_dr': {
      'username': 'dr.emily',
      'password': 'pediatric789',
      'name': 'Dr. Emily Rodriguez',
      'specialization': 'Pediatrician',
      'email': 'dr.emily@docbuddy.com',
      'phone': '+1-555-0103',
    },
    'ortho_dr': {
      'username': 'dr.james',
      'password': 'ortho012',
      'name': 'Dr. James Wilson',
      'specialization': 'Orthopedic Surgeon',
      'email': 'dr.james@docbuddy.com',
      'phone': '+1-555-0104',
    },
    'neuro_dr': {
      'username': 'dr.lisa',
      'password': 'neuro345',
      'name': 'Dr. Lisa Thompson',
      'specialization': 'Neurologist',
      'email': 'dr.lisa@docbuddy.com',
      'phone': '+1-555-0105',
    },
  };

  // Super admin account
  static const Map<String, String> superAdminAccount = {
    'username': 'admin',
    'password': 'admin123',
    'name': 'Super Admin',
    'email': 'admin@docbuddy.com',
    'phone': '+1-555-0000',
  };

  // Mock user database
  static final Map<String, User> _users = {
    // Super admin
    'admin': User(
      id: 'admin_001',
      name: 'Super Admin',
      email: 'admin@docbuddy.com',
      phone: '+1-555-0000',
      userType: 'super_admin',
    ),
    
    // Doctor accounts
    'dr.sarah': User(
      id: 'doctor_001',
      name: 'Dr. Sarah Johnson',
      email: 'dr.sarah@docbuddy.com',
      phone: '+1-555-0101',
      userType: 'doctor',
      doctorId: '1',
    ),
    'dr.michael': User(
      id: 'doctor_002',
      name: 'Dr. Michael Chen',
      email: 'dr.michael@docbuddy.com',
      phone: '+1-555-0102',
      userType: 'doctor',
      doctorId: '2',
    ),
    'dr.emily': User(
      id: 'doctor_003',
      name: 'Dr. Emily Rodriguez',
      email: 'dr.emily@docbuddy.com',
      phone: '+1-555-0103',
      userType: 'doctor',
      doctorId: '3',
    ),
    'dr.james': User(
      id: 'doctor_004',
      name: 'Dr. James Wilson',
      email: 'dr.james@docbuddy.com',
      phone: '+1-555-0104',
      userType: 'doctor',
      doctorId: '4',
    ),
    'dr.lisa': User(
      id: 'doctor_005',
      name: 'Dr. Lisa Thompson',
      email: 'dr.lisa@docbuddy.com',
      phone: '+1-555-0105',
      userType: 'doctor',
      doctorId: '5',
    ),
  };

  // Mock patient accounts
  static final Map<String, String> _patientPasswords = {};

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Check super admin
      if (username == superAdminAccount['username'] && 
          password == superAdminAccount['password']) {
        _currentUser = _users['admin'];
        _isLoading = false;
        notifyListeners();
        return true;
      }

      // Check doctor accounts
      for (var entry in doctorAccounts.entries) {
        if (entry.value['username'] == username && 
            entry.value['password'] == password) {
          _currentUser = _users[username];
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      // Check patient accounts
      if (_users.containsKey(username) && 
          _patientPasswords[username] == password) {
        _currentUser = _users[username];
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String name, String email, String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Check if user already exists
      if (_users.values.any((user) => user.email == email)) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Create new patient user
      final userId = 'patient_${DateTime.now().millisecondsSinceEpoch}';
      final username = email.split('@')[0];
      
      final newUser = User(
        id: userId,
        name: name,
        email: email,
        phone: phone,
        userType: 'patient',
      );

      _users[username] = newUser;
      _patientPasswords[username] = password;

      _currentUser = newUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  bool isDoctor() {
    return _currentUser?.userType == 'doctor';
  }

  bool isSuperAdmin() {
    return _currentUser?.userType == 'super_admin';
  }

  bool isPatient() {
    return _currentUser?.userType == 'patient';
  }

  String? getDoctorId() {
    return _currentUser?.doctorId;
  }

  // Get all doctors for super admin
  List<User> getAllDoctors() {
    return _users.values.where((user) => user.userType == 'doctor').toList();
  }

  // Get doctor account details
  Map<String, String>? getDoctorAccountDetails(String username) {
    for (var entry in doctorAccounts.entries) {
      if (entry.value['username'] == username) {
        return entry.value;
      }
    }
    return null;
  }
}