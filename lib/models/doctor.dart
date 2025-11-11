class Doctor {
  final String id;
  final String name;
  final String specialty;

  Doctor({required this.id, required this.name, required this.specialty});

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
    );
  }
}
