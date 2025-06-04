import 'package:flutter/material.dart';
import '../../models/asistencia_model.dart';
import '../../services/asistencia_service.dart';

class AsistenciaProvider extends ChangeNotifier {
  final AsistenciaService _asistenciaService = AsistenciaService();

  List<Asistencia> _asistencias = [];
  double _porcentajeAsistencia = 0.0;
  bool _isLoading = false;
  String _error = '';

  List<Asistencia> get asistencias => _asistencias;
  double get porcentajeAsistencia => _porcentajeAsistencia;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> obtenerAsistencias(int inscripcionTrimestreId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _asistencias = await _asistenciaService.obtenerAsistencias(
        inscripcionTrimestreId,
      );
      _porcentajeAsistencia = await _asistenciaService
          .calcularPorcentajeAsistencia(inscripcionTrimestreId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registrarAsistencia(Asistencia asistencia) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final nuevaAsistencia = await _asistenciaService.registrarAsistencia(
        asistencia,
      );
      _asistencias.add(nuevaAsistencia);
      _porcentajeAsistencia = await _asistenciaService
          .calcularPorcentajeAsistencia(asistencia.inscripcionTrimestreId);
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

  /*Future<bool> actualizarAsistencia(Asistencia asistencia) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _asistenciaService.actualizarAsistencia(asistencia);

      final index = _asistencias.indexWhere((a) => a.id == asistencia.id);
      if (index >= 0) {
        _asistencias[index] = asistencia;
      }

      _porcentajeAsistencia = await _asistenciaService
          .calcularPorcentajeAsistencia(asistencia.inscripcionTrimestreId);
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

  /*Future<bool> eliminarAsistencia(
    int asistenciaId,
    int inscripcionTrimestreId,
  ) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _asistenciaService.eliminarAsistencia(asistenciaId);
      _asistencias.removeWhere((a) => a.id == asistenciaId);
      _porcentajeAsistencia = await _asistenciaService
          .calcularPorcentajeAsistencia(inscripcionTrimestreId);
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

  Future<Map<String, int>> obtenerEstadisticasAsistencia(
    int inscripcionTrimestreId,
  ) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final estadisticas = await _asistenciaService
          .obtenerEstadisticasAsistencia(inscripcionTrimestreId);
      _isLoading = false;
      notifyListeners();
      return estadisticas;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return {'asistencias': 0, 'faltas': 0, 'total': 0};
    }
  }
}
