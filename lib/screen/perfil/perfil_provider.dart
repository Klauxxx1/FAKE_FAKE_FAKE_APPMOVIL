import 'package:flutter/material.dart';
import '../../models/usuario_model.dart';
import '../../services/perfil_service.dart';

class PerfilProvider extends ChangeNotifier {
  final PerfilService _perfilService = PerfilService();

  Usuario? _usuario;
  Estudiante? _estudiante;
  Profesor? _profesor;
  bool _isLoading = false;
  String _error = '';

  Usuario? get usuario => _usuario;
  Estudiante? get estudiante => _estudiante;
  Profesor? get profesor => _profesor;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> cargarPerfil(int usuarioId, String rol) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _usuario = await _perfilService.obtenerPerfilUsuario(usuarioId);

      if (rol == 'estudiante') {
        _estudiante = await _perfilService.obtenerPerfilEstudiante(usuarioId);
      } else if (rol == 'profesor') {
        _profesor = await _perfilService.obtenerPerfilProfesor(usuarioId);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> actualizarDatosUsuario(Usuario usuario) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _perfilService.actualizarDatosUsuario(usuario);
      _usuario = usuario;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarDatosEstudiante(Estudiante estudiante) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _perfilService.actualizarDatosEstudiante(estudiante);
      _estudiante = estudiante;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarDatosProfesor(Profesor profesor) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _perfilService.actualizarDatosProfesor(profesor);
      _profesor = profesor;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<String?> cambiarContrasena(
    int usuarioId,
    String contrasenaActual,
    String nuevaContrasena,
  ) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final mensaje = await _perfilService.cambiarContrasena(
        usuarioId,
        contrasenaActual,
        nuevaContrasena,
      );

      _isLoading = false;
      notifyListeners();
      return mensaje;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
