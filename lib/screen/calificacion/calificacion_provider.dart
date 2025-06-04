import 'package:flutter/material.dart';
import '../../models/evaluacion_model.dart';
import '../../services/evaluacion_service.dart';

class CalificacionProvider extends ChangeNotifier {
  final EvaluacionService _evaluacionService = EvaluacionService();

  EvaluacionLegal? _evaluacionLegal;
  List<Map<String, dynamic>> _historialCalificaciones = [];
  bool _isLoading = false;
  String _error = '';

  EvaluacionLegal? get evaluacionLegal => _evaluacionLegal;
  List<Map<String, dynamic>> get historialCalificaciones =>
      _historialCalificaciones;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> obtenerEvaluacionLegal(int inscripcionTrimestreId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _evaluacionLegal = await _evaluacionService.obtenerEvaluacion(
        inscripcionTrimestreId,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /*Future<bool> registrarEvaluacionLegal(EvaluacionLegal evaluacion) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final nuevaEvaluacion = await _evaluacionService.registrarEvaluacion(
        evaluacion,
      );
      _evaluacionLegal = nuevaEvaluacion;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }*/

  Future<bool> actualizarEvaluacionLegal(EvaluacionLegal evaluacion) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _evaluacionService.actualizarEvaluacion(evaluacion);
      _evaluacionLegal = evaluacion;
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

  Future<void> obtenerHistorialCalificaciones(int estudianteId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _historialCalificaciones = await _evaluacionService
          .obtenerHistorialCalificaciones(estudianteId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /*Future<Map<String, dynamic>> obtenerEstadisticasCalificaciones(
    int estudianteId,
  ) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final estadisticas = await _evaluacionService
          .obtenerEstadisticasCalificaciones(estudianteId);
      _isLoading = false;
      notifyListeners();
      return estadisticas;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return {'promedio': 0.0, 'minima': 0.0, 'maxima': 0.0};
    }
  }
}*/
}
