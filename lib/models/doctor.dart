class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String imageUrl;
  final double rating;
  final int experience;
  final String location;
  final List<String> availableDays;
  final List<String> availableTimeSlots;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.imageUrl,
    required this.rating,
    required this.experience,
    required this.location,
    required this.availableDays,
    required this.availableTimeSlots,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
      experience: json['experience'],
      location: json['location'],
      availableDays: List<String>.from(json['availableDays']),
      availableTimeSlots: List<String>.from(json['availableTimeSlots']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'imageUrl': imageUrl,
      'rating': rating,
      'experience': experience,
      'location': location,
      'availableDays': availableDays,
      'availableTimeSlots': availableTimeSlots,
    };
  }
} 