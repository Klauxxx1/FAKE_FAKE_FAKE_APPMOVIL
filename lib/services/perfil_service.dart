import 'dart:convert';
//import 'package:aula_inteligente_si2/models/estudiante_model.dart';
import 'package:http/http.dart' as http;
import '../models/usuario_model.dart';

class PerfilService {
  final String baseUrl = 'https://prueba1dlv7.duckdns.org/api';

  Future<Usuario> obtenerPerfilUsuario(int usuarioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/$usuarioId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el perfil del usuario');
    }
  }

  Future<Estudiante> obtenerPerfilEstudiante(int usuarioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/estudiantes/usuario/$usuarioId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Estudiante.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el perfil del estudiante');
    }
  }

  Future<Profesor> obtenerPerfilProfesor(int usuarioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profesores/usuario/$usuarioId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Profesor.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el perfil del profesor');
    }
  }

  Future<void> actualizarDatosUsuario(Usuario usuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/usuarios/${usuario.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(usuario.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar los datos del usuario');
    }
  }

  Future<void> actualizarDatosEstudiante(Estudiante estudiante) async {
    final response = await http.put(
      Uri.parse('$baseUrl/estudiantes/${estudiante.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'fecha_nacimiento': estudiante.fechaNacimiento,
        'genero': estudiante.genero,
        'nombre_padre': estudiante.nombrePadre,
        'nombre_madre': estudiante.nombreMadre,
        'ci_tutor': estudiante.ciTutor,
        'direccion': estudiante.direccion,
        //'telefono': estudiante.telefono,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar los datos del estudiante');
    }
  }

  Future<void> actualizarDatosProfesor(Profesor profesor) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profesores/${profesor.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'especialidad': profesor.especialidad,
        'profesion': profesor.profesion,
        'tipo_contrato': profesor.tipoContrato,
        'ci': profesor.ci,
        'direccion': profesor.direccion,
        'telefono': profesor.telefono,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar los datos del profesor');
    }
  }

  Future<String> cambiarContrasena(
    int usuarioId,
    String contrasenaActual,
    String nuevaContrasena,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/$usuarioId/cambiar-contrasena'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'contrasena_actual': contrasenaActual,
        'nueva_contrasena': nuevaContrasena,
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['mensaje'];
    } else {
      throw Exception('Error al cambiar la contraseña');
    }
  }
}
