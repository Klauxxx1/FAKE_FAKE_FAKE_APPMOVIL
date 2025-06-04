import 'package:flutter/material.dart';
import '../../services/prediccion_service.dart';

class PrediccionProvider extends ChangeNotifier {
  final PrediccionService _prediccionService = PrediccionService();

  Map<String, dynamic>? _prediccionRendimiento;
  Map<String, dynamic>? _prediccionTrimestral;
  List<Map<String, dynamic>> _factoresInfluyentes = [];
  Map<String, dynamic>? _historicoPredicciones;
  bool _isLoading = false;
  String _error = '';

  Map<String, dynamic>? get prediccionRendimiento => _prediccionRendimiento;
  Map<String, dynamic>? get prediccionTrimestral => _prediccionTrimestral;
  List<Map<String, dynamic>> get factoresInfluyentes => _factoresInfluyentes;
  Map<String, dynamic>? get historicoPredicciones => _historicoPredicciones;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> obtenerPrediccionRendimiento(int inscripcionId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _prediccionRendimiento = await _prediccionService
          .obtenerPrediccionRendimiento(inscripcionId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> obtenerPrediccionTrimestreActual(
    int inscripcionTrimestreId,
  ) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _prediccionTrimestral = await _prediccionService
          .obtenerPrediccionTrimestreActual(inscripcionTrimestreId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> obtenerFactoresInfluyentes(int estudianteId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _factoresInfluyentes = await _prediccionService
          .obtenerFactoresInfluyentes(estudianteId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> obtenerHistoricoPredicciones(int estudianteId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _historicoPredicciones = await _prediccionService
          .obtenerHistoricoPredicciones(estudianteId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
