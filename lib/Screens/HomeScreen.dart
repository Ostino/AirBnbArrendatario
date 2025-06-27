import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'AgregarLugarScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List lugares = [];

  @override
  void initState() {
    super.initState();
    obtenerLugares();
  }

  Future<void> obtenerLugares() async {
    final url = Uri.parse('https://261d-200-87-196-6.ngrok-free.app/api/lugares/search');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      setState(() {
        lugares = json.decode(response.body);
      });
    } else {
      print('Error al obtener lugares: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lugares disponibles'),
      ),
      body: ListView.builder(
        itemCount: lugares.length,
        itemBuilder: (context, index) {
          final lugar = lugares[index];
          final fotos = lugar['fotos'] as List<dynamic>? ?? [];
          final primeraFoto = fotos.isNotEmpty ? fotos[0]['url'] : null;

          // Reemplazar el dominio si hay foto
          final imagen = primeraFoto != null
              ? primeraFoto.replaceFirst(
            'https://toncipinto.nur.edu',
            'https://261d-200-87-196-6.ngrok-free.app',
          )
              : null;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: imagen != null
                ? SizedBox(
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imagen,
                  fit: BoxFit.cover,
                ),
              ),
            )
                : const Icon(Icons.image_not_supported, size: 60),
            title: Text(lugar['nombre'] ?? 'Sin nombre'),
            subtitle: Text('${lugar['ciudad'] ?? 'Sin ciudad'} - \$${lugar['precioNoche'] ?? '??'} por noche'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarLugarScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
