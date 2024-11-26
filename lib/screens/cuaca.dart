import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import tambahan untuk locale

class LocationInfoScreen extends StatefulWidget {
  @override
  _LocationInfoScreenState createState() => _LocationInfoScreenState();
}

class _LocationInfoScreenState extends State<LocationInfoScreen> {
  final String _weatherApiKey = '2a6c4fd28eadb3b8937762a3e6dd30a6';
  String _selectedZone = 'Indonesia';
  Map<String, dynamic>? _locationData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi locale untuk tanggal
    initializeDateFormatting('id_ID', null);
  }

  Future<void> _fetchLocationData(String zone) async {
    setState(() {
      _isLoading = true;
    });

    final weatherUrl =
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$zone?unitGroup=metric&key=U5GT83RSCGEPDXFERJCKD9DU9&contentType=json';

    try {
      final weatherResponse = await http.get(Uri.parse(weatherUrl));

      if (weatherResponse.statusCode == 200) {
        final weatherData = json.decode(weatherResponse.body);

        setState(() {
          _locationData = {
            'weather': {
              'temperature': weatherData['currentConditions']['temp'],
              'description': weatherData['currentConditions']['conditions'],
            },
            'location': {
              'city': weatherData['resolvedAddress'],
            },
          };
        });
      } else {
        _showError('Gagal memuat data cuaca. Status code: ${weatherResponse.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching location data: $e');
      _showError('Terjadi kesalahan saat mengambil data cuaca.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
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

  IconData _getWeatherIcon(String description) {
    if (description.contains('rain') || description.contains('shower')) {
      return Icons.umbrella;
    } else if (description.contains('cloud')) {
      return Icons.cloud;
    } else if (description.contains('clear') || description.contains('sunny')) {
      return Icons.wb_sunny;
    } else {
      return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuaca dan Info Wilayah'),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentDate,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedZone,
              items: [
                'Indonesia',
                'Jakarta',
                'Surabaya',
                'Bandung',
                'Yogyakarta',
              ].map((zone) {
                return DropdownMenuItem<String>(
                  value: zone,
                  child: Text(zone),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedZone = value;
                    _locationData = null;
                  });
                  _fetchLocationData(value);
                }
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _locationData != null
                    ? Expanded(
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          shadowColor: Colors.grey.withOpacity(0.5),
                          elevation: 5,
                          child: ListTile(
                            leading: Icon(
                              _getWeatherIcon(_locationData!['weather']['description'].toLowerCase()),
                              size: 50,
                              color: Colors.deepPurple,
                            ),
                            title: Text(
                              'Cuaca: ${_locationData!['weather']['description']}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Suhu: ${_locationData!['weather']['temperature']}°C\nKota: ${_locationData!['location']['city']}',
                            ),
                          ),
                        ),
                      )
                    : const Text(
                        'Pilih zona waktu untuk melihat informasi.',
                        textAlign: TextAlign.center,
                      ),
          ],
        ),
      ),
    );
  }
}
