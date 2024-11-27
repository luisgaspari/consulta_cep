import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cepController = TextEditingController();
  String _result = ''; // Variável para armazenar o resultado da consulta

  Future<void> _searchCEP() async {
    try {
      final response = await http.get(
          Uri.parse('https://viacep.com.br/ws/${_cepController.text}/json/'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Verifica se o CEP foi encontrado
        if (data.containsKey('erro')) {
          setState(() {
            _result = 'CEP não encontrado';
          });
        } else {
          setState(() {
            _result = 'CEP: ${data['cep']}\n'
                'Logradouro: ${data['logradouro']}\n'
                'Complemento: ${data['complemento'] ?? 'Não informado'}\n'
                'Bairro: ${data['bairro']}\n'
                'Localidade: ${data['localidade']}\n'
                'UF: ${data['uf']}';
          });
        }
      } else {
        setState(() {
          _result = 'Erro na consulta. Tente novamente.';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Erro de conexão. Verifique sua internet.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de CEP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cepController,
              decoration: const InputDecoration(labelText: 'CEP'),
              keyboardType: TextInputType.number, // Teclado numérico
            ),
            ElevatedButton(
              onPressed: _searchCEP,
              child: const Text('Consultar'),
            ),
            const SizedBox(height: 16),
            Text(_result), // Resultado da consulta
          ],
        ),
      ),
    );
  }
}
