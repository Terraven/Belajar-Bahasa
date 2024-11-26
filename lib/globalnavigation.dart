import 'package:belajarbahasa/screens/dashboard.dart';
import 'package:belajarbahasa/screens/kesanpesan.dart';
import 'package:belajarbahasa/screens/profile.dart';
import 'package:flutter/material.dart';

class GlobalNavigation extends StatefulWidget {
  @override
  _GlobalNavigationState createState() => _GlobalNavigationState();
}

class _GlobalNavigationState extends State<GlobalNavigation> {
  int _currentIndex = 0;

  // Daftar halaman untuk navigasi
  final List<Widget> _pages = [
    DashboardScreen(), // Halaman Dashboard
    ProfileScreen(), // Halaman Profil
    KesanPesanScreen(), // Halaman Kesan & Pesan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Menampilkan halaman sesuai dengan index yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Menandakan index halaman yang aktif
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Pindah ke halaman yang sesuai
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Kesan & Pesan',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
      // Menambahkan logout button di kanan atas pada halaman Kesan & Pesan
      floatingActionButton: _currentIndex == 2 ? FloatingActionButton(
        onPressed: () {
          // Logout dan kembali ke halaman login
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: Icon(Icons.exit_to_app),
        backgroundColor: Colors.red,
      ) : null,
    );
  }
}
