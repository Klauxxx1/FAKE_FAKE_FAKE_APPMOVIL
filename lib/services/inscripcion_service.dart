import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inscripcion_model.dart';

class InscripcionService {
  final String baseUrl = 'https://prueba1dlv7.duckdns.org/api';

  Future<List<Inscripcion>> obtenerInscripcionesPorEstudiante(
    int estudianteId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/estudiantes/$estudianteId/inscripciones'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> inscripcionesJson = json.decode(response.body);
      return inscripcionesJson
          .map((json) => Inscripcion.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al cargar las inscripciones');
    }
  }

  Future<List<InscripcionTrimestre>> obtenerTrimestresPorInscripcion(
    int inscripcionId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inscripciones/$inscripcionId/trimestres'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> trimestresJson = json.decode(response.body);
      return trimestresJson
          .map((json) => InscripcionTrimestre.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al cargar los trimestres');
    }
  }

  Future<double> obtenerRendimientoAcademico(
    int estudianteId,
    int materiaId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/estudiantes/$estudianteId/materias/$materiaId/rendimiento',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['rendimiento_academico']?.toDouble() ?? 0.0;
    } else {
      throw Exception('Error al cargar el rendimiento académico');
    }
  }
}
