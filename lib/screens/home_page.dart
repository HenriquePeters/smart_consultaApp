import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../widgets/doctor_card.dart';
import '../models/doctor.dart';
import 'schedule_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supa = SupabaseService();
  List<Doctor> doctors = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    setState(() => loading = true);
    try {
      final d = await supa.getDoctors();
      setState(() => doctors = d);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar médicos: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SmartConsulta')),
      body: RefreshIndicator(
        onRefresh: loadDoctors,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final d = doctors[index];
                  return DoctorCard(
                    doctor: d,
                    onTap: () async {
                      // Abrir agendamento para esse médico
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => SchedulePage(doctor: d)));
                    },
                  );
                },
              ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Meus agendamentos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => SchedulePage(showMyAppointments: true)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                await supa.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
