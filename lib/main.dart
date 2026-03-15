import 'package:flutter/material.dart';
import 'layouts/main_layout.dart';
import 'pages/registration_page.dart';
import 'pages/notifications_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DriveTrack',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B1A),
          brightness: Brightness.dark,
          surface: const Color(0xFF16161A), // Used for input backgrounds
          surfaceContainer: const Color(0xFF16161A),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F12),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),
        '/app': (context) => const MainLayout(),
        '/notifications': (context) => const NotificationsPage(),
      },
    );
  }
}
