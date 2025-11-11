# SmartConsulta - Flutter Template

Projeto mínimo funcional com Supabase.

## Setup
1. Coloque a logo em `assets/SmartConsulta_Logo.png`.
2. Configure Supabase com tabelas básicas:

- doctors: id (uuid), name (text), specialty (text)
- appointments: id (uuid), patient_id (uuid), doctor_id (uuid), date (timestamp), status (text)

3. Substitua as chaves em `lib/services/supabase_service.dart`.
4. `flutter pub get`
5. `flutter run`

## Observações
- Este template é um ponto de partida. Para produção: autenticação robusta, tratamento de horários (fuso/hora), validações, notificações (FCM) e regras RLS no Supabase são necessárias.
