import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslatorScreen extends StatefulWidget {
  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  bool _isLoading = false;

  // Daftar bahasa yang didukung
  final List<Map<String, String>> languages = [
    {'code': 'id', 'name': 'Indonesia'},
    {'code': 'en', 'name': 'Inggris'},
  ];

  // Bahasa yang dipilih
  String _sourceLanguage = 'id'; // Default: Bahasa Indonesia
  String _targetLanguage = 'en'; // Default: Bahasa Inggris

  // Fungsi untuk menerjemahkan teks menggunakan Deep Translate API
  Future<void> translateText() async {
    final String inputText = _textController.text;
    final String apiUrl = 'https://deep-translate1.p.rapidapi.com/language/translate/v2';

    if (inputText.isEmpty) {
      setState(() {
        _resultController.text = 'Masukkan teks untuk diterjemahkan.';
      });
      return;
    }

    final Map<String, String> headers = {
      'x-rapidapi-key': 'f76039346dmshe7da052dc2a6ca7p11d62bjsn839eaec2c767',
      'x-rapidapi-host': 'deep-translate1.p.rapidapi.com',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      "q": inputText,
      "source": _sourceLanguage,
      "target": _targetLanguage,
    };

    setState(() {
      _isLoading = true; // Menampilkan loading indicator
      _resultController.text = ''; // Reset hasil sebelumnya
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _resultController.text =
              data['data']['translations']['translatedText'] ?? 'Hasil tidak tersedia';
        });
      } else {
        setState(() {
          _resultController.text = 'Gagal menerjemahkan. Kode: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _resultController.text = 'Terjadi kesalahan: $error';
      });
    } finally {
      setState(() {
        _isLoading = false; // Menyembunyikan loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penerjemah Teks', style: TextStyle(color: Colors.white)),
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
                  'Masukkan Teks',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                _buildInputField(),
                const SizedBox(height: 10),
                _buildLanguageDropdowns(),
                const SizedBox(height: 20),
                _buildTranslateButton(),
                const SizedBox(height: 20),
                _buildResultField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return TextField(
      controller: _textController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Teks',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  Widget _buildLanguageDropdowns() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _sourceLanguage,
            items: languages.map((lang) {
              return DropdownMenuItem(
                value: lang['code'],
                child: Text(lang['name']!),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _sourceLanguage = value!;
              });
            },
            decoration: InputDecoration(
              labelText: 'Bahasa Sumber',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _targetLanguage,
            items: languages.map((lang) {
              return DropdownMenuItem(
                value: lang['code'],
                child: Text(lang['name']!),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _targetLanguage = value!;
              });
            },
            decoration: InputDecoration(
              labelText: 'Bahasa Tujuan',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTranslateButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _isLoading ? null : translateText,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
          child: _isLoading
              ? Row(
                  key: const ValueKey('loading'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('Tunggu...', style: TextStyle(color: Colors.white)),
                  ],
                )
              : const Text('Terjemah', key: ValueKey('normal')),
        ),
      ),
    );
  }

  Widget _buildResultField() {
    return TextField(
      controller: _resultController,
      readOnly: true,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Hasil Terjemahan',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }
}
