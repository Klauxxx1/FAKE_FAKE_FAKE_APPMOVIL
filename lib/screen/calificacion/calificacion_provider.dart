import 'package:aula_inteligente_si2/models/GestionesResponse_model.dart';
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

  // Agregar estas propiedades a la clase CalificacionProvider
  List<GestionesResponse> _resumenGestiones = [];
  bool _isLoadingResumen = false;
  String _errorResumen = '';

  // Getters para el resumen
  List<GestionesResponse> get resumenGestiones => _resumenGestiones;
  bool get isLoadingResumen => _isLoadingResumen;
  String get errorResumen => _errorResumen;

  // Método para verificar si ya tenemos datos para un trimestre
  bool tieneDatosTrimestre(String trimestre) {
    return _calificacionesConsolidadas.containsKey('T$trimestre') &&
        _calificacionesConsolidadas['T$trimestre']!.isNotEmpty;
  }

  // Método para cargar calificaciones de un trimestre específico
  Future<void> cargarCalificacionesTrimestre(String trimestre) async {
    if (tieneDatosTrimestre(trimestre)) return;

    // Programa la actualización de estado para después de la construcción
    Future.microtask(() {
      _isLoading = true;
      notifyListeners();

      _cargarDatosTrimestre(trimestre);
    });
  }

  // Método privado para realizar la carga real
  Future<void> _cargarDatosTrimestre(String trimestre) async {
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

  // Método para obtener el resumen de gestiones
  Future<void> obtenerResumenGestiones() async {
    if (!_isLoadingResumen) {
      _isLoadingResumen = true;
      _errorResumen = '';
      notifyListeners();

      try {
        _resumenGestiones =
            await _calificacionService.obtenerResumenGestiones();
      } catch (e) {
        _errorResumen = e.toString();
        print('Error al obtener resumen de gestiones: $_errorResumen');
      } finally {
        _isLoadingResumen = false;
        notifyListeners();
      }
    }
  }

  // Método para filtrar gestiones por año
  List<GestionesResponse> getGestionesPorAnio(String anio) {
    return _resumenGestiones
        .where((gestion) => gestion.gestion.startsWith(anio))
        .toList();
  }

  // Método para obtener promedio anual de rendimiento real
  double getPromedioRendimientoRealAnual(String anio) {
    final gestionesAnio = getGestionesPorAnio(anio);
    if (gestionesAnio.isEmpty) return 0.0;

    double suma = 0.0;
    int count = 0;

    for (var gestion in gestionesAnio) {
      if (gestion.promedioRendimientoAcademicoReal > 0) {
        suma += gestion.promedioRendimientoAcademicoReal;
        count++;
      }
    }

    return count > 0 ? suma / count : 0.0;
  }

  // Método para obtener promedio anual de rendimiento estimado
  double getPromedioRendimientoEstimadoAnual(String anio) {
    final gestionesAnio = getGestionesPorAnio(anio);
    if (gestionesAnio.isEmpty) return 0.0;

    double suma = 0.0;
    int count = 0;

    for (var gestion in gestionesAnio) {
      if (gestion.promedioRendimientoAcademicoEstimado > 0) {
        suma += gestion.promedioRendimientoAcademicoEstimado;
        count++;
      }
    }

    return count > 0 ? suma / count : 0.0;
  }
}
