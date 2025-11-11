ElevatedButton.icon(
  icon: const Icon(Icons.login),
  label: const Text('Entrar com Google'),
  onPressed: () async {
    try {
      final res = await Supabase.instance.client.auth.signInWithOAuth(
        Provider.google,
        options: AuthOptions(
          redirectTo: 'com.smartconsulta://login-callback', // ⚠️ mesmo scheme do AndroidManifest
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no login Google: $e')),
      );
    }
  },
),
