import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario_model.dart';

class AuthService {
  final String baseUrl = 'http://localhost:3000/api';

  // Método de inicio de sesión con fallback local
  Future<Usuario?> login(String correo, String contrasena) async {
    // Credenciales de respaldo (hardcoded)
    const String backupEmail = 'alumnoklaus@gmail.com';
    const String backupPassword = '123456';

    try {
      // Intenta autenticarse con el backend
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
          )
          .timeout(
            const Duration(seconds: 5),
          ); // Añadir timeout para evitar esperas largas

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Guardar token y datos de usuario
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('usuario', jsonEncode(data['usuario']));
        prefs.setString('rol', data['usuario']['rol']);

        return Usuario.fromJson(data['usuario']);
      } else {
        // Si falla la autenticación con el backend, verificamos las credenciales locales
        if (correo == backupEmail && contrasena == backupPassword) {
          print('Usando autenticación de respaldo...');

          // Crear un usuario de respaldo
          final backupUser = Usuario(
            id: 999,
            nombre: 'Alumno Klaus',
            correo: backupEmail,
            rol: 'estudiante',
          );

          // Guardar datos simulados en SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', 'fake_token_for_backup_login');
          prefs.setString(
            'usuario',
            jsonEncode({
              'id': backupUser.id,
              'nombre': backupUser.nombre,
              'correo': backupUser.correo,
              'rol': backupUser.rol,
            }),
          );
          prefs.setString('rol', 'estudiante');

          return backupUser;
        }
        return null;
      }
    } catch (e) {
      print('Error durante el inicio de sesión: $e');

      // Si hay error de conexión, verificamos las credenciales locales
      if (correo == backupEmail && contrasena == backupPassword) {
        print('Error de conexión. Usando autenticación de respaldo...');

        // Crear un usuario de respaldo
        final backupUser = Usuario(
          id: 999,
          nombre: 'Alumno Klaus',
          correo: backupEmail,
          rol: 'estudiante',
        );

        // Guardar datos simulados en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', 'fake_token_for_backup_login');
        prefs.setString(
          'usuario',
          jsonEncode({
            'id': backupUser.id,
            'nombre': backupUser.nombre,
            'correo': backupUser.correo,
            'rol': backupUser.rol,
          }),
        );
        prefs.setString('rol', 'estudiante');

        return backupUser;
      }
      return null;
    }
  }

  // Método para cerrar sesión
  Future<bool> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      print('Error al cerrar sesión: $e');
      return false;
    }
  }

  // Verificar si hay una sesión activa
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  // Obtener usuario actual
  Future<Usuario?> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usuarioJson = prefs.getString('usuario');

    if (usuarioJson != null) {
      Map<String, dynamic> usuarioMap = jsonDecode(usuarioJson);
      return Usuario.fromJson(usuarioMap);
    }
    return null;
  }

  // Obtener rol del usuario
  Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('rol');
  }
}
