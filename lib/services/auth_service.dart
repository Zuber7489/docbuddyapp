import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../models/doctor.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  static const String _userDataKey = 'user_data';
  static const String _patientPasswordsKey = 'patient_passwords';
  static const String _currentUserKey = 'current_user';

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

  // Mock user database - will be loaded from SharedPreferences
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

  // Mock patient accounts - will be loaded from SharedPreferences
  static final Map<String, String> _patientPasswords = {};

  // Initialize the service
  Future<void> initialize() async {
    await _loadUserData();
    await _loadCurrentUser();
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userDataKey);
      final passwordsString = prefs.getString(_patientPasswordsKey);
      
      if (userDataString != null) {
        final userData = json.decode(userDataString) as Map<String, dynamic>;
        userData.forEach((key, value) {
          if (key != 'admin' && !key.startsWith('dr.')) {
            _users[key] = User.fromJson(value);
          }
        });
      }
      
      if (passwordsString != null) {
        final passwords = json.decode(passwordsString) as Map<String, dynamic>;
        _patientPasswords.addAll(passwords.cast<String, String>());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save only patient users (exclude admin and doctors)
      final patientUsers = <String, dynamic>{};
      _users.forEach((key, user) {
        if (key != 'admin' && !key.startsWith('dr.')) {
          patientUsers[key] = user.toJson();
        }
      });
      
      await prefs.setString(_userDataKey, json.encode(patientUsers));
      await prefs.setString(_patientPasswordsKey, json.encode(_patientPasswords));
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user data: $e');
      }
    }
  }

  // Load current user from SharedPreferences
  Future<void> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUserString = prefs.getString(_currentUserKey);
      
      if (currentUserString != null) {
        final userData = json.decode(currentUserString) as Map<String, dynamic>;
        _currentUser = User.fromJson(userData);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading current user: $e');
      }
    }
  }

  // Save current user to SharedPreferences
  Future<void> _saveCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentUser != null) {
        await prefs.setString(_currentUserKey, json.encode(_currentUser!.toJson()));
      } else {
        await prefs.remove(_currentUserKey);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving current user: $e');
      }
    }
  }

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
        await _saveCurrentUser();
        _isLoading = false;
        notifyListeners();
        return true;
      }

      // Check doctor accounts
      for (var entry in doctorAccounts.entries) {
        if (entry.value['username'] == username && 
            entry.value['password'] == password) {
          _currentUser = _users[username];
          await _saveCurrentUser();
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      // Check patient accounts
      if (_users.containsKey(username) && 
          _patientPasswords[username] == password) {
        _currentUser = _users[username];
        await _saveCurrentUser();
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

      // Create new patient user with unique username
      final userId = 'patient_${DateTime.now().millisecondsSinceEpoch}';
      final username = 'user_${DateTime.now().millisecondsSinceEpoch}'; // Unique username
      
      final newUser = User(
        id: userId,
        name: name,
        email: email,
        phone: phone,
        userType: 'patient',
      );

      _users[username] = newUser;
      _patientPasswords[username] = password;

      // Save to persistent storage
      await _saveUserData();

      _currentUser = newUser;
      await _saveCurrentUser();
      
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
    _saveCurrentUser(); // Clear saved user
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

  // Find username by email for patient accounts
  String? findUsernameByEmail(String email) {
    for (var entry in _users.entries) {
      if (entry.value.email == email && entry.value.userType == 'patient') {
        return entry.key;
      }
    }
    return null;
  }

  // Update user profile
  Future<bool> updateProfile(String name, String email, String phone) async {
    try {
      if (_currentUser != null) {
        // Create updated user
        final updatedUser = User(
          id: _currentUser!.id,
          name: name,
          email: email,
          phone: phone,
          userType: _currentUser!.userType,
          doctorId: _currentUser!.doctorId,
        );

        // Update in users map
        final username = _users.entries
            .firstWhere((entry) => entry.value.id == _currentUser!.id)
            .key;
        _users[username] = updatedUser;

        // Update current user
        _currentUser = updatedUser;

        // Save to persistent storage
        await _saveUserData();
        await _saveCurrentUser();

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile: $e');
      }
      return false;
    }
  }
}