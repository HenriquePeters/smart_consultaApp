import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Telas
import 'screens/login_page.dart';
import 'screens/home_page.dart';

// Serviços
import 'services/supabase_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Supabase
  await Supabase.initialize(
    url: SupabaseService.SUPABASE_URL,
    anonKey: SupabaseService.SUPABASE_ANON_KEY,
  );

  // Inicializa o Firebase + FCM
  await NotificationService.initialize();

  runApp(const SmartConsultaApp());
}

class SmartConsultaApp extends StatelessWidget {
  const SmartConsultaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartConsulta',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
