import 'doctor.dart';

class Appointment {
  final String id;
  final String patientName;
  final String patientPhone;
  final Doctor doctor;
  final DateTime date;
  final String timeSlot;
  final String status; // 'confirmed', 'pending', 'cancelled'
  final String? notes;

  Appointment({
    required this.id,
    required this.patientName,
    required this.patientPhone,
    required this.doctor,
    required this.date,
    required this.timeSlot,
    required this.status,
    this.notes,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientName: json['patientName'],
      patientPhone: json['patientPhone'],
      doctor: Doctor.fromJson(json['doctor']),
      date: DateTime.parse(json['date']),
      timeSlot: json['timeSlot'],
      status: json['status'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'patientPhone': patientPhone,
      'doctor': doctor.toJson(),
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'status': status,
      'notes': notes,
    };
  }

  Appointment copyWith({
    String? id,
    String? patientName,
    String? patientPhone,
    Doctor? doctor,
    DateTime? date,
    String? timeSlot,
    String? status,
    String? notes,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      doctor: doctor ?? this.doctor,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
} 