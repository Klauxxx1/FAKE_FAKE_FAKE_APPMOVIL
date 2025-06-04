import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/curso_model.dart';

class CursoService {
  final String baseUrl = 'https://prueba1dlv7.duckdns.org/api';

  Future<List<Curso>> obtenerCursos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/cursos'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> cursosJson = json.decode(response.body);
      return cursosJson.map((json) => Curso.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los cursos');
    }
  }

  Future<Curso> obtenerCursoPorId(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cursos/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Curso.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar el curso');
    }
  }

  Future<List<CursoMateriaProfesor>> obtenerCursosMateriaProfesor(
    int cursoId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cursos/$cursoId/materias-profesores'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> relacionesJson = json.decode(response.body);
      return relacionesJson
          .map((json) => CursoMateriaProfesor.fromJson(json))
          .toList();
    } else {
      throw Exception(
        'Error al cargar las relaciones de curso-materia-profesor',
      );
    }
  }
}
