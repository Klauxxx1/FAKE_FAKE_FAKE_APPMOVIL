import 'package:flutter/foundation.dart';
import '../../models/calificacion_model.dart';
import '../../services/calificacion_service.dart';

class CalificacionProvider with ChangeNotifier {
  final CalificacionService _calificacionService = CalificacionService();
  Map<String, List<MateriaCalificacion>> _calificacionesConsolidadas = {};
  bool _isLoading = false;
  String _error = '';

  // Getters
  Map<String, List<MateriaCalificacion>> get calificacionesConsolidadas =>
      _calificacionesConsolidadas;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Método para verificar si ya tenemos datos para un trimestre
  bool tieneDatosTrimestre(String trimestre) {
    return _calificacionesConsolidadas.containsKey('T$trimestre') &&
        _calificacionesConsolidadas['T$trimestre']!.isNotEmpty;
  }

  // Método para cargar calificaciones de un trimestre específico
  Future<void> cargarCalificacionesTrimestre(String trimestre) async {
    if (tieneDatosTrimestre(trimestre)) return;

    _isLoading = true;
    notifyListeners();

    try {
      final calificaciones = await _calificacionService
          .obtenerCalificacionesTrimestre(trimestre);
      _calificacionesConsolidadas['T$trimestre'] = calificaciones;
      _error = '';
    } catch (e) {
      _error = e.toString();
      print('Error al cargar calificaciones: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para acceder a los datos de manera sincrónica, sin notificar
  List<MateriaCalificacion> getDatosTrimestre(String trimestre) {
    return _calificacionesConsolidadas['T$trimestre'] ?? [];
  }

  // Método para obtener todas las calificaciones
  Future<void> obtenerCalificacionesConsolidadas() async {
    if (!_isLoading) {
      _isLoading = true;
      _error = '';
      notifyListeners();

      try {
        _calificacionesConsolidadas =
            await _calificacionService.obtenerCalificacionesConsolidadas();
      } catch (e) {
        _error = e.toString();
        print('Error al obtener calificaciones consolidadas: $_error');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  // Método para calcular el promedio por trimestre
  double calcularPromedioTrimestre(String trimestre) {
    if (!_calificacionesConsolidadas.containsKey('T$trimestre') ||
        _calificacionesConsolidadas['T$trimestre']!.isEmpty) {
      return 0.0;
    }

    return _calificacionService.calcularPromedioTrimestre(
      _calificacionesConsolidadas['T$trimestre']!,
    );
  }

  // Método para calcular el rendimiento estimado promedio por trimestre
  double calcularRendimientoEstimadoPromedio(String trimestre) {
    if (!_calificacionesConsolidadas.containsKey('T$trimestre') ||
        _calificacionesConsolidadas['T$trimestre']!.isEmpty) {
      return 0.0;
    }

    return _calificacionService.calcularRendimientoEstimadoPromedio(
      _calificacionesConsolidadas['T$trimestre']!,
    );
  }
}
