import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart'; // Ganti dengan file halaman login Anda.

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Navigasi ke halaman login setelah 3 detik
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HalamanLogin()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E24AA), Color(0xFF6A1B9A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar logo
              Image.asset(
                'images/splash.png', // Ganti dengan path logo Anda
                height: 150,
              ),
              const SizedBox(height: 20),
              // Nama aplikasi
              const Text(
                'Aplikasi Belajar Bahasa',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              // Subjudul
              const Text(
                'Belajar dengan mudah dan menyenangkan',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),
              // Animasi loading
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
