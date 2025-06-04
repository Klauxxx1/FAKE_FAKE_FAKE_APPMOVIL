import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/calificacion_model.dart';
import 'calificacion_provider.dart';

class CalificacionTrimestreScreen extends StatefulWidget {
  final String titulo;
  final String trimestre;

  const CalificacionTrimestreScreen({
    Key? key,
    required this.titulo,
    required this.trimestre,
  }) : super(key: key);

  @override
  State<CalificacionTrimestreScreen> createState() =>
      _CalificacionTrimestreScreenState();
}

class _CalificacionTrimestreScreenState
    extends State<CalificacionTrimestreScreen> {
  List<MateriaCalificacion> _materias = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _cargarCalificaciones();
  }

  Future<void> _cargarCalificaciones() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final provider = Provider.of<CalificacionProvider>(
        context,
        listen: false,
      );

      // Primero verifica si ya hay datos en caché
      if (provider.tieneDatosTrimestre(widget.trimestre)) {
        setState(() {
          _materias = provider.getDatosTrimestre(widget.trimestre);
          _isLoading = false;
        });
        return;
      }

      // Si no hay datos, inicia la carga pero no esperes aquí
      await provider.cargarCalificacionesTrimestre(widget.trimestre);

      // Después de la carga, obtén los datos y actualiza el estado
      if (mounted) {
        setState(() {
          _materias = provider.getDatosTrimestre(widget.trimestre);
          _error = provider.error;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.white.withOpacity(0.8),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Error al cargar calificaciones',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _error,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _cargarCalificaciones,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_materias.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school,
                size: 80,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(height: 16),
              const Text(
                'No hay calificaciones disponibles',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No se encontraron calificaciones para este trimestre',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                ),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.red, Colors.white],
          stops: [0.0, 0.3],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPromedioGeneralCard(_materias),
          const SizedBox(height: 16),
          ..._materias.map((materia) => _buildMateriaCard(materia)).toList(),
        ],
      ),
    );
  }

  Widget _buildPromedioGeneralCard(List<MateriaCalificacion> materias) {
    // Calcular el promedio general del trimestre
    double sumaNotas = 0;
    for (var materia in materias) {
      sumaNotas += double.parse(materia.evaluacionLegal.notaEvaluacionLegal);
    }
    double promedioGeneral =
        materias.isNotEmpty ? sumaNotas / materias.length : 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Promedio ${widget.titulo}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getColorForNota(promedioGeneral),
                shape: BoxShape.circle,
              ),
              child: Text(
                promedioGeneral.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getCalificacionTexto(promedioGeneral),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMateriaCard(MateriaCalificacion materia) {
    final nota = double.parse(materia.evaluacionLegal.notaEvaluacionLegal);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la materia
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getColorForNota(nota).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.book, color: _getColorForNota(nota)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Materia: ${materia.nombreMateria}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Profesor: ${materia.nombreProfesor}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Curso: ${materia.nombreCurso}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // Evaluación Legal
            const Text(
              'Evaluación Legal:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Evaluación del profesor
            const Text(
              '- Evaluación profesor:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            _buildDimensionRow(
              'Saber:',
              materia.evaluacionLegal.notaSaberEvaluacionProfesor,
            ),
            _buildDimensionRow(
              'Hacer:',
              materia.evaluacionLegal.notaHacerEvaluacionProfesor,
            ),
            _buildDimensionRow(
              'Ser:',
              materia.evaluacionLegal.notaSerEvaluacionProfesor,
            ),
            _buildDimensionRow(
              'Decidir:',
              materia.evaluacionLegal.notaDecidirEvaluacionProfesor,
            ),
            _buildDimensionRow(
              'Promedio profesor:',
              materia.evaluacionLegal.notaEvaluacionProfesor,
            ),

            const SizedBox(height: 8),

            // Evaluación del estudiante
            const Text(
              '- Evaluación estudiante:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            _buildDimensionRow(
              'Ser:',
              materia.evaluacionLegal.notaSerEvaluacionEstudiante,
            ),
            _buildDimensionRow(
              'Decidir:',
              materia.evaluacionLegal.notaDecidirEvaluacionEstudiante,
            ),
            _buildDimensionRow(
              'Promedio estudiante:',
              materia.evaluacionLegal.notaEvaluacionEstudiante,
            ),

            const Divider(height: 24),

            // Nota final
            Row(
              children: [
                const Icon(Icons.diamond, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Nota Legal Final: ${materia.evaluacionLegal.notaEvaluacionLegal}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getColorForNota(nota),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDimensionRow(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label)),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Color _getColorForNota(double nota) {
    if (nota >= 80) return Colors.green;
    if (nota >= 60) return Colors.amber;
    return Colors.red;
  }

  String _getCalificacionTexto(double nota) {
    if (nota >= 90) return '¡Excelente desempeño!';
    if (nota >= 80) return '¡Muy buen trabajo!';
    if (nota >= 70) return 'Buen desempeño';
    if (nota >= 60) return 'Desempeño aceptable';
    if (nota >= 50) return 'Necesita mejorar';
    return 'Desempeño insuficiente';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
