import 'package:http/http.dart' as http;
import 'dart:convert';

class LugarService {
  static const String baseUrl = 'https://261d-200-87-196-6.ngrok-free.app/api';

  static Future<List<dynamic>> obtenerLugares() async {
    final response = await http.post(
      Uri.parse('$baseUrl/lugares/search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({}), // cuerpo vacío, sin filtros
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error al obtener lugares: ${response.body}');
    }
  }
}
