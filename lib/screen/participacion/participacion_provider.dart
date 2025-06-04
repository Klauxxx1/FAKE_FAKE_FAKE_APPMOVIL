import 'package:flutter/material.dart';
import '../../models/participacion_model.dart';
import '../../services/participacion_service.dart';

class ParticipacionProvider extends ChangeNotifier {
  final ParticipacionService _participacionService = ParticipacionService();

  List<Participacion> _participaciones = [];
  double _porcentajeParticipacion = 0.0;
  bool _isLoading = false;
  String _error = '';

  List<Participacion> get participaciones => _participaciones;
  double get porcentajeParticipacion => _porcentajeParticipacion;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> obtenerParticipaciones(int inscripcionTrimestreId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _participaciones = await _participacionService.obtenerParticipaciones(
        inscripcionTrimestreId,
      );
      _porcentajeParticipacion = await _participacionService
          .calcularPorcentajeParticipacion(inscripcionTrimestreId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registrarParticipacion(Participacion participacion) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final nuevaParticipacion = await _participacionService
          .registrarParticipacion(participacion);
      _participaciones.add(nuevaParticipacion);
      _porcentajeParticipacion = await _participacionService
          .calcularPorcentajeParticipacion(
            participacion.inscripcionTrimestreId,
          );
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

  Future<bool> actualizarParticipacion(Participacion participacion) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _participacionService.actualizarParticipacion(participacion);

      final index = _participaciones.indexWhere(
        (p) => p.id == participacion.id,
      );
      if (index >= 0) {
        _participaciones[index] = participacion;
      }

      _porcentajeParticipacion = await _participacionService
          .calcularPorcentajeParticipacion(
            participacion.inscripcionTrimestreId,
          );
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

  Future<bool> eliminarParticipacion(
    int participacionId,
    int inscripcionTrimestreId,
  ) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _participacionService.eliminarParticipacion(participacionId);
      _participaciones.removeWhere((p) => p.id == participacionId);
      _porcentajeParticipacion = await _participacionService
          .calcularPorcentajeParticipacion(inscripcionTrimestreId);
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
}
