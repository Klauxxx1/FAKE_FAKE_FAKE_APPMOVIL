import 'package:aula_inteligente_si2/models/usuario_model.dart';
import 'package:aula_inteligente_si2/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  Usuario? _usuario;
  bool _isLoading = false;
  String? _error;
  final AuthService _authService = AuthService();

  Usuario? get usuario => _usuario;
  bool get isAuthenticated => _usuario != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String correo, String contrasena) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final usuario = await _authService.login(correo, contrasena);

      _isLoading = false;
      if (usuario != null) {
        _usuario = usuario;
        notifyListeners();
        return true;
      } else {
        _error = 'Credenciales incorrectas';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Ocurrió un error inesperado';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _usuario = null;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      _usuario = await _authService.getCurrentUser();
      notifyListeners();
    }
  }
}
