import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/evaluacion_model.dart';

class EvaluacionService {
  final String baseUrl = 'https://prueba1dlv7.duckdns.org/api';

  Future<EvaluacionLegal> obtenerEvaluacion(int inscripcionTrimestreId) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/inscripciones-trimestre/$inscripcionTrimestreId/evaluacion',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return EvaluacionLegal.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar la evaluación');
    }
  }

  Future<EvaluacionLegal> guardarEvaluacion(EvaluacionLegal evaluacion) async {
    final response = await http.post(
      Uri.parse('$baseUrl/evaluaciones'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(evaluacion.toJson()),
    );

    if (response.statusCode == 201) {
      return EvaluacionLegal.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al guardar la evaluación');
    }
  }

  Future<EvaluacionLegal> actualizarEvaluacion(
    EvaluacionLegal evaluacion,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/evaluaciones/${evaluacion.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(evaluacion.toJson()),
    );

    if (response.statusCode == 200) {
      return EvaluacionLegal.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar la evaluación');
    }
  }

  //hayq que revisarlo OJO
  Future<List<Map<String, dynamic>>> obtenerHistorialCalificaciones(
    int estudianteId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/estudiantes/$estudianteId/calificaciones/historial'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> historialJson = json.decode(response.body);
      return historialJson.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar el historial de calificaciones');
    }
  }
}
