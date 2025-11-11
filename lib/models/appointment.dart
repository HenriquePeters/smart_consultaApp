import 'doctor.dart';

class Appointment {
  final String? id;
  final String patientId;
  final String doctorId;
  final DateTime date;
  final String status;
  final Doctor? doctor;

  Appointment({this.id, required this.patientId, required this.doctorId, required this.date, this.status = 'agendado', this.doctor});

  factory Appointment.fromMap(Map<String, dynamic> map) {
    // Caso o retorno inclua dados do médico em `doctors`
    Doctor? d;
    if (map['doctors'] != null && map['doctors'] is Map<String, dynamic>) {
      d = Doctor.fromMap(Map<String, dynamic>.from(map['doctors']));
    }

    return Appointment(
      id: map['id']?.toString(),
      patientId: map['patient_id'] ?? '',
      doctorId: map['doctor_id'] ?? '',
      date: DateTime.parse(map['date']),
      status: map['status'] ?? 'agendado',
      doctor: d,
    );
  }
}
