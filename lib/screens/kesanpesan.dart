import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KesanPesanScreen extends StatefulWidget {
  @override
  _KesanPesanScreenState createState() => _KesanPesanScreenState();
}

class _KesanPesanScreenState extends State<KesanPesanScreen> {
  final TextEditingController _kesanController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();
  String _kesan = "";
  String _pesan = "";

  @override
  void initState() {
    super.initState();
    _loadKesanPesan();
  }

  Future<void> _loadKesanPesan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _kesan = prefs.getString('kesan') ?? "";
      _pesan = prefs.getString('pesan') ?? "";
    });
  }

  Future<void> _saveKesanPesan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kesan', _kesanController.text);
    await prefs.setString('pesan', _pesanController.text);
    setState(() {
      _kesan = _kesanController.text;
      _pesan = _pesanController.text;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kesan dan Pesan telah disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kesan & Pesan'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kesan Mata Kuliah:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _kesanController,
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Tuliskan kesan Anda...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF8E24AA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF6A1B9A), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pesan untuk Dosen:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _pesanController,
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Tuliskan pesan Anda...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF8E24AA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF6A1B9A), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveKesanPesan,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: const Color.fromARGB(255, 245, 243, 245),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('Simpan Kesan & Pesan'),
              ),
            ),
            const SizedBox(height: 20),
            if (_kesan.isNotEmpty || _pesan.isNotEmpty) ...[
              const Text(
                'Kesan yang telah disimpan:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1B9A),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _kesan,
                style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 242, 241, 242)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pesan yang telah disimpan:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 248, 247, 248),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _pesan,
                style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 247, 246, 247)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
