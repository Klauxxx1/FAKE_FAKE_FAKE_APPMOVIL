import 'dart:convert';
import 'package:http/http.dart' as http;

class InscripcionTrimestralService {
  final String baseUrl = 'https://prueba1dlv7.duckdns.org/api';

  // Método para obtener todas las inscripciones trimestrales de un estudiante para un trimestre específico
  Future<List<dynamic>> obtenerInscripcionesTrimestrales(
    int estudianteId,
    String gestionTrimestral,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/inscripciones-trimestrales-estudiante/?estudiante_id=$estudianteId&gestion_academica_trimestral=$gestionTrimestral',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Error al obtener inscripciones trimestrales: ${response.statusCode}',
      );
    }
  }
}
