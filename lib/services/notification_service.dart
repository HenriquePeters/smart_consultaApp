import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Configurações locais (Android)
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint("Notificação clicada: ${response.payload}");
      },
    );

    // Configura FCM
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Solicita permissão (necessário no iOS)
    await messaging.requestPermission();

    // Token de registro
    String? token = await messaging.getToken();
    debugPrint("FCM Token: $token");

    // Handler de mensagens em foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Mensagem recebida: ${message.notification?.title}");
      if (message.notification != null) {
        _showLocalNotification(
          message.notification!.title ?? "Nova mensagem",
          message.notification!.body ?? "",
        );
      }
    });
  }

  static Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'smartconsulta_channel',
      'SmartConsulta Notificações',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      title,
      body,
      platformDetails,
      payload: 'smartconsulta_payload',
    );
  }
}
