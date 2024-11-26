import 'dart:convert'; // Untuk mengolah JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Untuk melakukan request HTTP

class KonversiUangScreen extends StatefulWidget {
  @override
  _KonversiUangScreenState createState() => _KonversiUangScreenState();
}

class _KonversiUangScreenState extends State<KonversiUangScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _sourceCurrency = 'USD';
  String _targetCurrency = 'IDR';

  Map<String, double> _conversionRates = {};
  double _convertedAmount = 0;

  @override
  void initState() {
    super.initState();
    fetchConversionRates(); // Memuat nilai tukar saat aplikasi dibuka
  }

  Future<void> fetchConversionRates() async {
    const apiUrl =
        'https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_N8OSRFtEP7pFNcazJeGGemvgcs94r6MKYXSC9toq';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic> rates = data['data'];

        setState(() {
          _conversionRates = rates.map((key, value) =>
              MapEntry(key, (value as num).toDouble())); // Konversi ke `double`
        });
      } else {
        print('Gagal memuat data. Kode status: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  void _convertCurrency() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    double sourceRate = _conversionRates[_sourceCurrency] ?? 1.0;
    double targetRate = _conversionRates[_targetCurrency] ?? 1.0;

    setState(() {
      _convertedAmount = amount * (targetRate / sourceRate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Uang', style: TextStyle(color: Colors.white)),
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
      body: _conversionRates.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Indikator loading
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
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
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Masukkan jumlah yang ingin dikonversi:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Jumlah',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildCurrencyDropdown(
                          'Mata Uang Asal', _sourceCurrency, (value) {
                        setState(() => _sourceCurrency = value);
                      }),
                      const SizedBox(height: 10),
                      _buildCurrencyDropdown(
                          'Mata Uang Tujuan', _targetCurrency, (value) {
                        setState(() => _targetCurrency = value);
                      }),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _convertCurrency,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                          child: const Text(
                            'Konversi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Hasil: ${_convertedAmount.toStringAsFixed(2)} $_targetCurrency',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildCurrencyDropdown(String label, String value, Function(String) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: (val) => onChanged(val!),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      items: _conversionRates.keys.map((String currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
    );
  }
}
