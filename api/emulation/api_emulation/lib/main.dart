import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ApiTester(),
    );
  }
}

class ApiTester extends StatefulWidget {
  const ApiTester({super.key});

  @override
  State<ApiTester> createState() => _ApiTesterState();
}

class _ApiTesterState extends State<ApiTester> {
  String _response = '';

  Future<void> checkSupabaseConnection() async {
    const String supabaseUrl = 'http://localhost:8000/is_connected/';
    try {
      final response = await http.get(Uri.parse(supabaseUrl));

      if (response.statusCode == 200) {
        setState(() {
          _response = response.body;
        });
      } else {
        setState(() {
          _response = 'Erro: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Exceção: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Tester!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                await checkSupabaseConnection();
              },
              child: const Text('Testar conexão'),
            ),
            const SizedBox(height: 24),
            Text(
              'Resposta: $_response',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
