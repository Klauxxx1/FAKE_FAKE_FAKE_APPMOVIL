import 'package:aula_inteligente_si2/models/usuario_model.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Usuario? _usuario;
  bool _isLoading = false;
  String _error = '';

  Usuario? get usuario => _usuario;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<bool> iniciarSesion(String correo, String contrasena) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final result = await _authService.login(correo, contrasena);
      _usuario = result as Usuario?;
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

  Future<void> cerrarSesion() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _usuario = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> verificarSesion() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        _usuario = await _authService.getCurrentUser();
      }
      _isLoading = false;
      notifyListeners();
      return isLoggedIn;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
