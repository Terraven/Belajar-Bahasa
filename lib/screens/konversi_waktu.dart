import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Untuk format waktu

class TimezoneScreen extends StatefulWidget {
  @override
  _TimezoneScreenState createState() => _TimezoneScreenState();
}

class _TimezoneScreenState extends State<TimezoneScreen> {
  final String _apiKey = '428a17b7a9f24a66904089196698de5b'; // API Key
  final TextEditingController _inputTimeController = TextEditingController();
  String _sourceZone = 'Asia/Jakarta'; // Default zona waktu pengguna
  final Map<String, String> _targetZones = {
    'WIB (Asia/Jakarta)': 'Asia/Jakarta',
    'WITA (Asia/Makassar)': 'Asia/Makassar',
    'WIT (Asia/Jayapura)': 'Asia/Jayapura',
    'London': 'Europe/London',
    'Tokyo': 'Asia/Tokyo',
  };
  Map<String, String>? _conversionResults;

  Future<Map<String, dynamic>?> _fetchConvertedTime(
      String sourceZone, String targetZone, String time) async {
    final sourceUrl =
        'https://api.ipgeolocation.io/timezone?apiKey=$_apiKey&tz=$sourceZone';
    final targetUrl =
        'https://api.ipgeolocation.io/timezone?apiKey=$_apiKey&tz=$targetZone';

    try {
      final sourceResponse = await http.get(Uri.parse(sourceUrl));
      final targetResponse = await http.get(Uri.parse(targetUrl));

      if (sourceResponse.statusCode == 200 && targetResponse.statusCode == 200) {
        final sourceData = json.decode(sourceResponse.body);
        final targetData = json.decode(targetResponse.body);

        // Get UTC offset (dalam detik)
        final sourceOffset =
            (double.parse(sourceData['timezone_offset_with_dst'].toString()) * 3600)
                .toInt(); // Konversi ke detik
        final targetOffset =
            (double.parse(targetData['timezone_offset_with_dst'].toString()) * 3600)
                .toInt(); // Konversi ke detik

        // Get today's date
        final currentDate = DateTime.now();

        // Parse input time
        final timeParts = time.split(':').map(int.parse).toList();
        final inputTime = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          timeParts[0],
          timeParts[1],
        );

        // Konversi waktu menggunakan offset
        final utcTime = inputTime.subtract(Duration(seconds: sourceOffset));
        final convertedTime = utcTime.add(Duration(seconds: targetOffset));

        // Format hasil dengan intl
        final formattedTime =
            DateFormat('yyyy-MM-dd HH:mm').format(convertedTime);

        return {'converted_time': formattedTime};
      }
    } catch (e) {
      debugPrint('Error fetching time: $e');
      return null;
    }
    return null;
  }

  Future<void> _convertTime() async {
    String time = _inputTimeController.text.trim();

    // Validasi dan konversi input
    if (time.isEmpty) {
      _showErrorDialog('Harap masukkan waktu.');
      return;
    }

    // Deteksi format input
    if (RegExp(r'^\d{4}$').hasMatch(time)) {
      // Format angka saja (misalnya 1209)
      time = '${time.substring(0, 2)}:${time.substring(2, 4)}';
    } else if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(time)) {
      _showErrorDialog('Format waktu salah. Gunakan HH:MM atau angka 4 digit (misalnya, 1209).');
      return;
    }

    setState(() {
      _conversionResults = null; // Reset hasil sebelumnya
    });

    Map<String, String> results = {};
    for (String zoneName in _targetZones.keys) {
      final zone = _targetZones[zoneName];
      final data = await _fetchConvertedTime(_sourceZone, zone!, time);
      if (data != null) {
        results[zoneName] = data['converted_time']!;
      } else {
        results[zoneName] = 'Gagal mengambil data';
      }
    }

    setState(() {
      _conversionResults = results;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Waktu'),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _inputTimeController,
              decoration: const InputDecoration(
                labelText: 'Masukkan Waktu (HH:MM atau 4 digit, misal 1209)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: const Text('Konversi Waktu'),
            ),
            const SizedBox(height: 20),
            _conversionResults != null
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _conversionResults!.length,
                      itemBuilder: (context, index) {
                        final zoneName = _conversionResults!.keys.elementAt(index);
                        final time = _conversionResults![zoneName]!;
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(zoneName),
                            subtitle: Text(time),
                          ),
                        );
                      },
                    ),
                  )
                : const Text(
                    'Tekan tombol untuk memulai konversi waktu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputTimeController.dispose();
    super.dispose();
  }
}
