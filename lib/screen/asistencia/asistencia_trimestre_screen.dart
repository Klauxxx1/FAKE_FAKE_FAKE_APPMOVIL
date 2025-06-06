import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/inscripcion_trimestral_service.dart';

class AsistenciaTrimestreScreen extends StatefulWidget {
  final String titulo;
  final int trimestreId;
  final String gestionTrimestral;

  const AsistenciaTrimestreScreen({
    Key? key,
    required this.titulo,
    required this.trimestreId,
    required this.gestionTrimestral,
  }) : super(key: key);

  @override
  State<AsistenciaTrimestreScreen> createState() =>
      _AsistenciaTrimestreScreenState();
}

class _AsistenciaTrimestreScreenState extends State<AsistenciaTrimestreScreen> {
  bool _isLoading = true;
  String _error = '';
  List<MateriaAsistencia> _materias = [];

  // ID del estudiante - en una app real se obtendría del servicio de autenticación
  final int _estudianteId = 103;

  @override
  void initState() {
    super.initState();
    _cargarAsistencias();
  }

  Future<void> _cargarAsistencias() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Usar el servicio para obtener datos
      final service = InscripcionTrimestralService();
      final inscripciones = await service.obtenerInscripcionesTrimestrales(
        _estudianteId,
        widget.gestionTrimestral,
      );

      // Procesar datos para mostrar en la UI
      final List<MateriaAsistencia> materias = [];

      for (var inscripcion in inscripciones) {
        final asistencias = List<Map<String, dynamic>>.from(
          inscripcion['asistencias'],
        );

        int presentes = 0;
        int faltas = 0;
        List<AsistenciaData> asistenciasData = [];

        for (var asistencia in asistencias) {
          final bool esPresente = asistencia['tipo'] == 'P';
          if (esPresente) {
            presentes++;
          } else {
            faltas++;
          }

          asistenciasData.add(
            AsistenciaData(fecha: asistencia['fecha'], asistio: esPresente),
          );
        }

        materias.add(
          MateriaAsistencia(
            nombreMateria: inscripcion['nombre_materia'],
            nombreProfesor: inscripcion['nombre_profesor'],
            curso: inscripcion['nombre_curso'],
            asistencias: asistenciasData,
            presentes: presentes,
            faltas: faltas,
          ),
        );
      }

      setState(() {
        _materias = materias;
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
        title: Text(widget.titulo),
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
                        onPressed: _cargarAsistencias,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
                : _materias.isEmpty
                ? const Center(
                  child: Text('No hay datos de asistencia disponibles'),
                )
                : RefreshIndicator(
                  onRefresh: _cargarAsistencias,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: _materias.length,
                      itemBuilder: (context, index) {
                        return _buildMateriaTarjeta(_materias[index]);
                      },
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildMateriaTarjeta(MateriaAsistencia materia) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.red.shade50],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de la tarjeta
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.red.shade200, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Materia: ${materia.nombreMateria}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Profesor: ${materia.nombreProfesor}',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Curso: ${materia.curso}',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lista de asistencias
            const Text(
              'Asistencias:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            ...materia.asistencias.map((asistencia) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '- ${_formatDate(asistencia.fecha)}: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    if (asistencia.asistio)
                      Row(
                        children: [
                          const Text(
                            'P',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          const Text(
                            'F',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.cancel, color: Colors.red, size: 16),
                        ],
                      ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 16),

            // Resumen de asistencias
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumen:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Presentes: ${materia.presentes}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.cancel, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Faltas: ${materia.faltas}',
                        style: const TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value:
                        materia.presentes /
                        (materia.presentes + materia.faltas),
                    backgroundColor: Colors.red.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Porcentaje de asistencia: ${_calcularPorcentajeAsistencia(materia.presentes, materia.faltas)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String fecha) {
    return fecha; // Puedes implementar un formateador de fecha más sofisticado
  }

  String _calcularPorcentajeAsistencia(int presentes, int faltas) {
    if (presentes + faltas == 0) return '0.0';
    return ((presentes * 100) / (presentes + faltas)).toStringAsFixed(1);
  }
}

// Clases auxiliares para manejar los datos
class MateriaAsistencia {
  final String nombreMateria;
  final String nombreProfesor;
  final String curso;
  final List<AsistenciaData> asistencias;
  final int presentes;
  final int faltas;

  MateriaAsistencia({
    required this.nombreMateria,
    required this.nombreProfesor,
    required this.curso,
    required this.asistencias,
    required this.presentes,
    required this.faltas,
  });
}

class AsistenciaData {
  final String fecha;
  final bool asistio;

  AsistenciaData({required this.fecha, required this.asistio});
}
