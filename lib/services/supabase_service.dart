import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';

class SupabaseService {
  // Substitua pelas suas chaves (nunca comitar em repositório público)
  static const SUPABASE_URL = 'https://YOUR_PROJECT.supabase.co';
  static const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY';

  final SupabaseClient client = Supabase.instance.client;

  // AUTENTICAÇÃO
  Future<GotrueSessionResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // MÉDICOS (exemplo simples: busca todos)
  Future<List<Doctor>> getDoctors() async {
    final res = await client.from('doctors').select().order('name');
    if (res.error != null) {
      throw res.error!.message;
    }
    final data = res as List<dynamic>;
    return data.map((e) => Doctor.fromMap(e)).toList();
  }

  // AGENDAMENTOS
  Future<List<Appointment>> getAppointments(String userId) async {
    final res = await client
        .from('appointments')
        .select('id,patient_id,doctor_id,date,status,doctors(*)')
        .eq('patient_id', userId)
        .order('date', ascending: true);
    if (res.error != null) throw res.error!.message;

    final data = res as List<dynamic>;
    return data.map((e) => Appointment.fromMap(e)).toList();
  }

  Future<void> createAppointment(Appointment appt) async {
    final res = await client.from('appointments').insert([{
      'patient_id': appt.patientId,
      'doctor_id': appt.doctorId,
      'date': appt.date.toIso8601String(),
      'status': appt.status,
    }]);
    if (res.error != null) throw res.error!.message;
  }
}
