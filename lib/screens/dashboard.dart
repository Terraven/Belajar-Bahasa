import 'package:belajarbahasa/screens/goggle_translate.dart';
import 'package:belajarbahasa/screens/konversi_uang.dart';
import 'package:belajarbahasa/screens/konversi_waktu.dart';
import 'package:belajarbahasa/screens/cuaca.dart'; // Import file cuaca.dart
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  Widget _buildMenuButton(BuildContext context, IconData icon, String label, Widget targetScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.deepPurple),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E24AA), Color(0xFF6A1B9A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildMenuButton(
              context,
              Icons.access_time,
              'Konversi Waktu',
              TimezoneScreen(),
            ),
            _buildMenuButton(
              context,
              Icons.attach_money,
              'Konversi Uang',
              KonversiUangScreen(),
            ),
            _buildMenuButton(
              context,
              Icons.translate,
              'Google Translate',
              TranslatorScreen(),
            ),
            _buildMenuButton(
              context,
              Icons.wb_sunny,
              'Cuaca',
              LocationInfoScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
