import 'dart:convert';
import 'package:http/http.dart' as http;

class PrediccionService {
  final String baseUrl = 'https://prueba1dlv7.duckdns.org/api';

  Future<Map<String, dynamic>> obtenerPrediccionRendimiento(
    int inscripcionId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/predicciones/rendimiento/$inscripcionId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener la predicción de rendimiento');
    }
  }

  Future<Map<String, dynamic>> obtenerPrediccionTrimestreActual(
    int inscripcionTrimestreId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/predicciones/trimestre/$inscripcionTrimestreId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener la predicción del trimestre');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerFactoresInfluyentes(
    int estudianteId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/predicciones/factores/$estudianteId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> factoresJson = json.decode(response.body);
      return factoresJson.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al obtener los factores influyentes');
    }
  }

  Future<Map<String, dynamic>> obtenerHistoricoPredicciones(
    int estudianteId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/predicciones/historico/$estudianteId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener el histórico de predicciones');
    }
  }
}
