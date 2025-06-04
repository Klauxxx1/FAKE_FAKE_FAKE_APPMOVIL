import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calificacion_model.dart';

class CalificacionService {
  final String baseUrl = 'https://prueba1dlv7.duckdns.org/api';

  // Método para obtener calificaciones de un trimestre específico
  Future<List<MateriaCalificacion>> obtenerCalificacionesTrimestre(
    String trimestre,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final estudianteId = prefs.getInt('estudiante_id');
      final token = prefs.getString('token');

      if (estudianteId == null || token == null) {
        throw Exception('No se ha iniciado sesión');
      }

      // Convertir el trimestre (1, 2, 3) a formato API (2025-T1, 2025-T2, 2025-T3)
      String gestionTrimestral = "2025-T$trimestre";

      print(
        'Obteniendo calificaciones: estudiante=$estudianteId, trimestre=$gestionTrimestral',
      );

      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/inscripciones-trimestrales-estudiante/?estudiante_id=$estudianteId&gestion_academica_trimestral=$gestionTrimestral',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      print('Respuesta: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Datos recibidos: ${data.length} materias');

        return data.map((item) => MateriaCalificacion.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        print(
          'No se encontraron calificaciones para el trimestre: $gestionTrimestral',
        );
        return [];
      } else {
        print(
          'Error al obtener calificaciones: ${response.statusCode} - ${response.body}',
        );
        throw Exception(
          'Error al obtener calificaciones: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error al obtener calificaciones: $e');
      throw Exception('Error al obtener calificaciones: $e');
    }
  }

  // Método para obtener todas las calificaciones
  Future<Map<String, List<MateriaCalificacion>>>
  obtenerCalificacionesConsolidadas() async {
    Map<String, List<MateriaCalificacion>> consolidado = {};

    try {
      // Obtener calificaciones para cada trimestre
      for (int i = 1; i <= 3; i++) {
        try {
          final calificaciones = await obtenerCalificacionesTrimestre(
            i.toString(),
          );
          consolidado['T$i'] = calificaciones;
        } catch (e) {
          print('Error al obtener calificaciones del trimestre $i: $e');
          consolidado['T$i'] = [];
        }
      }

      return consolidado;
    } catch (e) {
      print('Error al obtener calificaciones consolidadas: $e');
      throw Exception('Error al obtener calificaciones consolidadas');
    }
  }

  // Método para calcular el promedio de un trimestre
  double calcularPromedioTrimestre(List<MateriaCalificacion> materias) {
    if (materias.isEmpty) return 0.0;

    double sumaNotas = 0.0;
    for (var materia in materias) {
      sumaNotas +=
          double.tryParse(materia.evaluacionLegal.notaEvaluacionLegal) ?? 0.0;
    }

    return sumaNotas / materias.length;
  }

  // Método para calcular el rendimiento académico estimado promedio
  double calcularRendimientoEstimadoPromedio(
    List<MateriaCalificacion> materias,
  ) {
    if (materias.isEmpty) return 0.0;

    double sumaRendimientos = 0.0;
    for (var materia in materias) {
      sumaRendimientos += materia.rendimientoAcademicoEstimado;
    }

    return sumaRendimientos / materias.length;
  }
}
