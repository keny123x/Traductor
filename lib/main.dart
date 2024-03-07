import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TranslationPage(),
    );
  }
}

class TranslationPage extends StatefulWidget {
  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final TextEditingController _textEditingController = TextEditingController();
  String _translatedText = 'es';
  final String apiKey = 'trnsl.1.1.20240306T160039Z.d319c71cb7edc045.096d4d896af661ce58b7ac27ba77cfb4684f1608';

  Future<void> _translateText(String text, String destLanguage) async {
    final response = await http.get(Uri.parse('https://translate.yandex.net/api/v1.5/tr.json/translate?key=$apiKey&text=$text&lang=$destLanguage'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        _translatedText = jsonResponse['text'][0];
      });
    } else {
      throw Exception('Failed to load translation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traductor Simple'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              labelText: 'Enter text to translate',
            ),
          ),
          ElevatedButton(
            child: Text('Traducir'),
            onPressed: () {
              String textToTranslate = _textEditingController.text;
              // Cambiar 'ja' al código ISO del idioma de destino deseado
              _translateText(textToTranslate, 'es');
            },
          ),
          SizedBox(height: 20),
          Text(
            'Texto Traducido:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(_translatedText),
        ],
      ),
    );
  }
}
