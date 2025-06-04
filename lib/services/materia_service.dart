import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/materia_model.dart';

class MateriaService {
  final String baseUrl = 'https://prueba1dlv7.duckdns.org/api';

  Future<List<Materia>> obtenerMaterias() async {
    final response = await http.get(
      Uri.parse('$baseUrl/materias'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> materiasJson = json.decode(response.body);
      return materiasJson.map((json) => Materia.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las materias');
    }
  }

  Future<Materia> obtenerMateriaPorId(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/materias/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Materia.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar la materia');
    }
  }
}
