import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/asistencia_model.dart';

class AsistenciaService {
  final String baseUrl = 'https://prueba1dlv7.duckdns.org/api';

  Future<List<Asistencia>> obtenerAsistencias(
    int inscripcionTrimestreId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/inscripciones-trimestre/$inscripcionTrimestreId/asistencias',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> asistenciasJson = json.decode(response.body);
      return asistenciasJson.map((json) => Asistencia.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las asistencias');
    }
  }

  Future<Asistencia> registrarAsistencia(Asistencia asistencia) async {
    final response = await http.post(
      Uri.parse('$baseUrl/asistencias'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(asistencia.toJson()),
    );

    if (response.statusCode == 201) {
      return Asistencia.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al registrar la asistencia');
    }
  }

  Future<double> calcularPorcentajeAsistencia(
    int inscripcionTrimestreId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/inscripciones-trimestre/$inscripcionTrimestreId/porcentaje-asistencia',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['porcentaje']?.toDouble() ?? 0.0;
    } else {
      throw Exception('Error al calcular el porcentaje de asistencia');
    }
  }

  //hay Que revisar OJITO MIJO
  Future<Map<String, int>> obtenerEstadisticasAsistencia(
    int inscripcionTrimestreId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/inscripciones-trimestre/$inscripcionTrimestreId/estadisticas-asistencia',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return {
        'asistencias': data['asistencias'] ?? 0,
        'faltas': data['faltas'] ?? 0,
        'total': data['total'] ?? 0,
      };
    } else {
      throw Exception('Error al obtener las estadísticas de asistencia');
    }
  }
}
