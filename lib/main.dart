import 'package:flutter/material.dart';
import '../screens/splash.dart'; // Halaman Splash
import '../screens/login.dart'; // Halaman Login
import '../screens/daftar.dart'; // Halaman Daftar
import '../globalnavigation.dart'; // Import GlobalNavigation

void main() {
  runApp(BelajarBahasaApp());
}

class BelajarBahasaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belajar Bahasa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Splash sebagai halaman awal
      routes: {
        '/': (context) => SplashScreen(), // Splash Screen
        '/login': (context) => HalamanLogin(), // Login Screen
        '/register': (context) => HalamanRegister(), // Register Screen
        '/home': (context) => GlobalNavigation(), // Global Navigation setelah login atau register
      },
    );
  }
}
