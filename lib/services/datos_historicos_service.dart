import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dato_historico_model.dart';

class DatosHistoricosService {
  final String baseUrl = 'https://prueba1dlv7.duckdns.org/api';

  Future<List<DatoHistorico>> obtenerDatosHistoricos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final estudianteId = prefs.getInt('estudiante_id');
      final token = prefs.getString('token');

      if (estudianteId == null || token == null) {
        throw Exception('No se ha iniciado sesión');
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/resumen-gestiones/estudiante/$estudianteId/'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final datosHistoricos =
            data.map((item) => DatoHistorico.fromJson(item)).toList();

        // Ordenar por gestión (más reciente primero)
        datosHistoricos.sort((a, b) => b.gestion.compareTo(a.gestion));

        return datosHistoricos;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
          'Error al obtener datos históricos: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener datos históricos: $e');
    }
  }
}
