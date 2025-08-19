 class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String userType; // 'patient', 'doctor', 'super_admin'
  final String? doctorId; // For doctor users, reference to their doctor profile

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.doctorId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      userType: json['userType'],
      doctorId: json['doctorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'doctorId': doctorId,
    };
  }
}