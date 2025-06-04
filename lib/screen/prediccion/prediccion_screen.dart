import 'package:flutter/material.dart';
import '../../services/inscripcion_trimestral_service.dart';
//import 'package:fl_chart/fl_chart.dart';

class PrediccionScreen extends StatefulWidget {
  const PrediccionScreen({Key? key}) : super(key: key);

  @override
  State<PrediccionScreen> createState() => _PrediccionScreenState();
}

class _PrediccionScreenState extends State<PrediccionScreen> {
  bool _isLoading = true;
  String _error = '';
  List<MateriaPrediccion> _materias = [];
  double _promedioPredictivo = 0.0;

  // ID del estudiante - en una app real se obtendría del servicio de autenticación
  final int _estudianteId = 103;
  final String _trimestreActual = '2025-T1';

  @override
  void initState() {
    super.initState();
    _cargarPredicciones();
  }

  Future<void> _cargarPredicciones() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Usar el servicio para obtener datos
      final service = InscripcionTrimestralService();
      final inscripciones = await service.obtenerInscripcionesTrimestrales(
        _estudianteId,
        _trimestreActual,
      );

      // Procesar datos para mostrar en la UI
      final List<MateriaPrediccion> materias = [];
      double sumaPredicciones = 0.0;

      for (var inscripcion in inscripciones) {
        final String nombreMateria = inscripcion['nombre_materia'];
        final double rendimientoEstimado =
            inscripcion['rendimiento_academico_estimado'] ?? 0.0;
        sumaPredicciones += rendimientoEstimado;

        materias.add(
          MateriaPrediccion(
            nombreMateria: nombreMateria,
            nombreProfesor: inscripcion['nombre_profesor'],
            curso: inscripcion['nombre_curso'],
            rendimientoActual:
                inscripcion['evaluacion_legal'] != null
                    ? double.parse(
                      inscripcion['evaluacion_legal']['nota_evaluacion_legal'],
                    )
                    : 0.0,
            rendimientoEstimado: rendimientoEstimado,
          ),
        );
      }

      // Calcular promedio predictivo
      final promedio =
          inscripciones.isNotEmpty
              ? sumaPredicciones / inscripciones.length
              : 0.0;

      setState(() {
        _materias = materias;
        _promedioPredictivo = promedio;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predicción del Rendimiento'),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                )
                : _error.isNotEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar datos: $_error',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _cargarPredicciones,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
                : RefreshIndicator(
                  onRefresh: _cargarPredicciones,
                  color: Colors.red,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryCard(),
                        const SizedBox(height: 20),
                        const Text(
                          'Predicción por Materias',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._materias
                            .map(
                              (materia) => _buildMateriaPrediccionCard(materia),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red.shade100, Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rendimiento Académico Proyectado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Promedio Estimado',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_promedioPredictivo.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getColorForScore(_promedioPredictivo),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getCalificacionTexto(_promedioPredictivo),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _getColorForScore(_promedioPredictivo),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: _promedioPredictivo / 100,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getColorForScore(_promedioPredictivo),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${_promedioPredictivo.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _getColorForScore(_promedioPredictivo),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Basado en tu asistencia, participación y evaluaciones previas.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMateriaPrediccionCard(MateriaPrediccion materia) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              materia.nombreMateria,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Prof. ${materia.nombreProfesor}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.timeline, color: Colors.blue, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Rendimiento actual: ',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                Text(
                  '${materia.rendimientoActual.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getColorForScore(materia.rendimientoActual),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.purple, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Rendimiento estimado: ',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                Text(
                  '${materia.rendimientoEstimado.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getColorForScore(materia.rendimientoEstimado),
                  ),
                ),
                const SizedBox(width: 4),
                _buildRendimientoIcon(
                  materia.rendimientoEstimado,
                  materia.rendimientoActual,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: materia.rendimientoEstimado / 100,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getColorForScore(materia.rendimientoEstimado),
                ),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRendimientoIcon(double estimado, double actual) {
    if (actual == 0) {
      return const Icon(Icons.new_releases, color: Colors.orange, size: 16);
    }

    if (estimado > actual) {
      return const Icon(Icons.trending_up, color: Colors.green, size: 16);
    } else if (estimado < actual) {
      return const Icon(Icons.trending_down, color: Colors.red, size: 16);
    } else {
      return const Icon(Icons.trending_flat, color: Colors.blue, size: 16);
    }
  }

  Color _getColorForScore(double score) {
    if (score >= 90) return Colors.green.shade700;
    if (score >= 80) return Colors.green;
    if (score >= 70) return Colors.blue;
    if (score >= 51) return Colors.orange;
    return Colors.red;
  }

  String _getCalificacionTexto(double nota) {
    if (nota >= 90) return 'Excelente';
    if (nota >= 80) return 'Muy Bueno';
    if (nota >= 70) return 'Bueno';
    if (nota >= 51) return 'Regular';
    return 'Insuficiente';
  }
}

// Clases auxiliares para manejar los datos
class MateriaPrediccion {
  final String nombreMateria;
  final String nombreProfesor;
  final String curso;
  final double rendimientoActual;
  final double rendimientoEstimado;

  MateriaPrediccion({
    required this.nombreMateria,
    required this.nombreProfesor,
    required this.curso,
    required this.rendimientoActual,
    required this.rendimientoEstimado,
  });
}
