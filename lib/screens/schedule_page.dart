import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/doctor.dart';
import '../services/supabase_service.dart';
import '../models/appointment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SchedulePage extends StatefulWidget {
  final Doctor? doctor;
  final bool showMyAppointments;

  const SchedulePage({Key? key, this.doctor, this.showMyAppointments = false}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final supa = SupabaseService();
  bool loading = false;
  List<Appointment> myAppointments = [];

  @override
  void initState() {
    super.initState();
    if (widget.showMyAppointments) loadMyAppointments();
  }

  Future<void> loadMyAppointments() async {
    setState(() => loading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw 'Usuário não autenticado';
      final list = await supa.getAppointments(user.id);
      setState(() => myAppointments = list);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _createAppointment() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw 'Faça login primeiro.';
      if (_selectedDay == null) throw 'Selecione uma data.';
      if (widget.doctor == null) throw 'Médico inválido.';

      final appt = Appointment(
        patientId: user.id,
        doctorId: widget.doctor!.id,
        date: DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day, 9, 0), // hora fixa 09:00 exemplo
      );

      await supa.createAppointment(appt);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agendamento criado!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showMyAppointments) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meus Agendamentos')),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: myAppointments.length,
                itemBuilder: (context, index) {
                  final a = myAppointments[index];
                  return ListTile(
                    title: Text(a.doctor?.name ?? 'Médico'),
                    subtitle: Text('${a.date.toLocal()} - ${a.status}'),
                  );
                },
              ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Agendar - ${widget.doctor?.name ?? ''}')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _createAppointment, child: const Text('Confirmar agendamento às 09:00')),
          ],
        ),
      ),
    );
  }
}
