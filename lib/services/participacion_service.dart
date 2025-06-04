import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/participacion_model.dart';

class ParticipacionService {
  final String baseUrl = 'https://prueba1dlv7.duckdns.org/api';

  Future<List<Participacion>> obtenerParticipaciones(
    int inscripcionTrimestreId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/inscripciones-trimestre/$inscripcionTrimestreId/participaciones',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> participacionesJson = json.decode(response.body);
      return participacionesJson
          .map((json) => Participacion.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al cargar las participaciones');
    }
  }

  Future<Participacion> registrarParticipacion(
    Participacion participacion,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/participaciones'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(participacion.toJson()),
    );

    if (response.statusCode == 201) {
      return Participacion.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al registrar la participación');
    }
  }

  Future<double> calcularPorcentajeParticipacion(
    int inscripcionTrimestreId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/inscripciones-trimestre/$inscripcionTrimestreId/porcentaje-participacion',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['porcentaje']?.toDouble() ?? 0.0;
    } else {
      throw Exception('Error al calcular el porcentaje de participación');
    }
  }

  Future<void> actualizarParticipacion(Participacion participacion) async {
    final response = await http.put(
      Uri.parse('$baseUrl/participaciones/${participacion.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(participacion.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la participación');
    }
  }

  Future<void> eliminarParticipacion(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/participaciones/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la participación');
    }
  }
}
