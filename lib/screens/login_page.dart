import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final supa = SupabaseService();
  bool loading = false;

  Future<void> _login() async {
    setState(() => loading = true);
    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (res.session != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falha no login')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/SmartConsulta_Logo.png', width: 300),
              const SizedBox(height: 24),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 8),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: loading ? null : _login, child: loading ? const CircularProgressIndicator() : const Text('Entrar')),
              TextButton(onPressed: () async {
                // Criar conta simples (email + password)
                try {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  final res = await Supabase.instance.client.auth.signUp(email: email, password: password);
                  if (res.user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conta criada! Faça login.')));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
                }
              }, child: const Text('Criar conta')),
            ],
          ),
        ),
      ),
    );
  }
}
