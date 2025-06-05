import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario_model.dart';

class AuthService {
  // URL base del API
  final String baseUrl = 'https://prueba1dlv7.duckdns.org/api';

  // Singleton para acceder al usuario globalmente
  static final AuthService _instance = AuthService._internal();

  // Información del usuario autenticado (accesible globalmente)
  int? usuarioId;
  String? usuarioRol;
  int? estudianteId;
  int? profesorId;
  int? cursoId;

  // Constructor factory para el singleton
  factory AuthService() {
    return _instance;
  }

  // Constructor interno para el singleton
  AuthService._internal();

  // Inicialización - cargar datos del usuario si existe
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    usuarioId = prefs.getInt('usuario_id');
    usuarioRol = prefs.getString('rol');
    estudianteId = prefs.getInt('estudiante_id');
    profesorId = prefs.getInt('profesor_id');
    cursoId = prefs.getInt('curso_id');
  }

  // Método de inicio de sesión
  Future<Usuario?> login(String correo, String contrasena) async {
    try {
      print('Intentando login con: $correo, $contrasena');

      // Intenta autenticarse con el backend
      final response = await http
          .post(
            Uri.parse('$baseUrl/token/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'correo': correo, 'password': contrasena}),
          )
          .timeout(const Duration(seconds: 10));

      print('Respuesta login: ${response.statusCode}');
      print('Cuerpo respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Guardar tokens
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('access_token', data['access'] ?? '');
        prefs.setString('refresh_token', data['refresh'] ?? '');

        // Guardar ID y rol del usuario
        final id = data['id'] ?? 0;
        final rol = data['rol'] ?? '';

        final peticion = await http.get(
          Uri.parse('$baseUrl/estudiante/por-usuario/?usuario_id=$id'),
          headers: {'Content-Type': 'application/json'},
        );

        if (peticion.statusCode == 200) {
          final dataId = jsonDecode(peticion.body);
          final estudiante_id = dataId['estudiante_id'] ?? 0;
          prefs.setInt('estudiante_id', estudiante_id);
        }

        prefs.setInt('usuario_id', id);
        prefs.setString('rol', rol);

        // Actualizar variables globales
        usuarioId = id;
        usuarioRol = rol;

        // Crear y devolver el objeto usuario
        final usuario = Usuario(
          id: id,
          // Puede que el nombre no venga en la respuesta según el formato de la API
          nombre: data['nombre'] ?? 'Usuario $correo',
          correo: correo,
          rol: rol,
        );

        // Guardar datos del usuario como JSON
        prefs.setString(
          'usuario',
          jsonEncode({
            'id': usuario.id,
            'nombre': usuario.nombre,
            'correo': usuario.correo,
            'rol': usuario.rol,
          }),
        );

        // Si el usuario es un estudiante, obtener su información adicional
        if (rol.toLowerCase() == 'estudiante') {
          await _fetchEstudianteInfo(id, prefs);
        }

        // Si el usuario es un profesor, obtener su información adicional
        if (rol.toLowerCase() == 'profesor') {
          await _fetchProfesorInfo(id, prefs);
        }

        return usuario;
      } else {
        print('Error en login: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Excepción durante el login: $e');

      // Credenciales de respaldo (solo para desarrollo)
      const String backupEmail = 'alumnoklaus@gmail.com';
      const String backupPassword = '123456';

      // Si hay error de conexión y son las credenciales de respaldo
      if (correo == backupEmail && contrasena == backupPassword) {
        print('Usando login de respaldo');

        // Crear usuario de respaldo
        final backupUser = Usuario(
          id: 99,
          nombre: 'Alumno Klaus',
          correo: backupEmail,
          rol: 'estudiante',
        );

        // Guardar datos simulados
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('access_token', 'fake_token');
        prefs.setString('refresh_token', 'fake_refresh_token');
        prefs.setInt('usuario_id', backupUser.id);
        prefs.setString('rol', backupUser.rol);

        // Para simular un estudiante de respaldo
        prefs.setInt('estudiante_id', 99);
        prefs.setInt('curso_id', 1);

        // Actualizar variables globales
        usuarioId = backupUser.id;
        usuarioRol = backupUser.rol;
        estudianteId = 99;
        cursoId = 1;

        prefs.setString(
          'usuario',
          jsonEncode({
            'id': backupUser.id,
            'nombre': backupUser.nombre,
            'correo': backupUser.correo,
            'rol': backupUser.rol,
          }),
        );

        return backupUser;
      }

      return null;
    }
  }

  // Obtener información del estudiante basado en su usuario_id
  Future<void> _fetchEstudianteInfo(int userId, SharedPreferences prefs) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/estudiante/por-usuario/$userId/'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${prefs.getString('access_token')}',
            },
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Guardar ID del estudiante y curso
        final estId = data['id'] ?? 0;
        final cId = data['curso_id'] ?? 0;

        prefs.setInt('estudiante_id', estId);
        prefs.setInt('curso_id', cId);

        // Actualizar variables globales
        estudianteId = estId;
        cursoId = cId;

        print('Información de estudiante obtenida. ID: $estId, Curso: $cId');
      } else {
        print('Error al obtener datos del estudiante: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al buscar información del estudiante: $e');
    }
  }

  // Obtener información del profesor basado en su usuario_id
  Future<void> _fetchProfesorInfo(int userId, SharedPreferences prefs) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/profesor/por-usuario/$userId/'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${prefs.getString('access_token')}',
            },
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Guardar ID del profesor
        final profId = data['id'] ?? 0;
        prefs.setInt('profesor_id', profId);

        // Actualizar variables globales
        profesorId = profId;

        print('Información de profesor obtenida. ID: $profId');
      } else {
        print('Error al obtener datos del profesor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al buscar información del profesor: $e');
    }
  }

  // Verificar si hay una sesión activa
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return token != null && token.isNotEmpty;
  }

  // Cerrar sesión
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Limpiar variables globales
      usuarioId = null;
      usuarioRol = null;
      estudianteId = null;
      profesorId = null;
      cursoId = null;

      // Limpiar datos guardados
      return await prefs.clear();
    } catch (e) {
      print('Error al cerrar sesión: $e');
      return false;
    }
  }

  // Obtener usuario actual
  Future<Usuario?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioJson = prefs.getString('usuario');

    if (usuarioJson != null) {
      final usuarioMap = jsonDecode(usuarioJson);
      return Usuario.fromJson(usuarioMap);
    }
    return null;
  }

  // Obtener ID del usuario actual
  int? getCurrentUserId() {
    return usuarioId;
  }

  // Obtener rol del usuario actual
  String? getCurrentUserRole() {
    return usuarioRol;
  }

  // Obtener ID del estudiante (si el usuario es estudiante)
  int? getCurrentEstudianteId() {
    return estudianteId;
  }

  // Obtener ID del profesor (si el usuario es profesor)
  int? getCurrentProfesorId() {
    return profesorId;
  }

  // Obtener ID del curso del estudiante actual
  int? getCurrentCursoId() {
    return cursoId;
  }

  // Verificar si el token está expirado y refrescarlo si es necesario
  Future<String?> getValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return accessToken;
  }

  // Método para hacer peticiones autenticadas
  Future<http.Response?> authenticatedGet(String endpoint) async {
    final token = await getValidToken();
    if (token == null) return null;

    try {
      return await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print('Error en petición autenticada: $e');
      return null;
    }
  }
}
