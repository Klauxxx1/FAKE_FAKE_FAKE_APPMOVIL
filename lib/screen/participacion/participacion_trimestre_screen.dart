import 'package:flutter/material.dart';
import '../../services/inscripcion_trimestral_service.dart';

class ParticipacionTrimestreScreen extends StatefulWidget {
  final String titulo;
  final int trimestreId;
  final String gestionTrimestral;

  const ParticipacionTrimestreScreen({
    Key? key,
    required this.titulo,
    required this.trimestreId,
    required this.gestionTrimestral,
  }) : super(key: key);

  @override
  State<ParticipacionTrimestreScreen> createState() =>
      _ParticipacionTrimestreScreenState();
}

class _ParticipacionTrimestreScreenState
    extends State<ParticipacionTrimestreScreen> {
  bool _isLoading = true;
  String _error = '';
  List<MateriaParticipacion> _materias = [];

  // ID del estudiante - en una app real se obtendría del servicio de autenticación
  final int _estudianteId = 103;

  @override
  void initState() {
    super.initState();
    _cargarParticipaciones();
  }

  Future<void> _cargarParticipaciones() async {
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
      final List<MateriaParticipacion> materias = [];

      for (var inscripcion in inscripciones) {
        final participaciones = List<Map<String, dynamic>>.from(
          inscripcion['participaciones'],
        );

        int totalParticipaciones = participaciones.length;
        int participacionesActivas =
            participaciones.where((p) => p['participo'] == true).length;
        List<ParticipacionData> participacionesData = [];

        for (var participacion in participaciones) {
          participacionesData.add(
            ParticipacionData(
              fecha: participacion['fecha'],
              participo: participacion['participo'] == true,
            ),
          );
        }

        materias.add(
          MateriaParticipacion(
            nombreMateria: inscripcion['nombre_materia'],
            nombreProfesor: inscripcion['nombre_profesor'],
            curso: inscripcion['nombre_curso'],
            participaciones: participacionesData,
            totalParticipaciones: totalParticipaciones,
            participacionesActivas: participacionesActivas,
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
                        onPressed: _cargarParticipaciones,
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
                  child: Text('No hay datos de participación disponibles'),
                )
                : RefreshIndicator(
                  onRefresh: _cargarParticipaciones,
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

  Widget _buildMateriaTarjeta(MateriaParticipacion materia) {
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

            // Lista de participaciones
            const Text(
              'Participaciones:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            materia.participaciones.isEmpty
                ? Text(
                  'No hay participaciones registradas',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                )
                : Column(
                  children:
                      materia.participaciones.map((participacion) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Text(
                                '- ${_formatDate(participacion.fecha)}: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              if (participacion.participo)
                                Row(
                                  children: [
                                    Text(
                                      'Participó',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.thumb_up,
                                      color: Colors.blue.shade700,
                                      size: 16,
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  children: [
                                    const Text(
                                      'No participó',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.thumb_down,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                ),

            const SizedBox(height: 16),

            // Resumen de participaciones
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
                  Text(
                    'Total de participaciones: ${materia.totalParticipaciones}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  materia.totalParticipaciones > 0
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value:
                                materia.totalParticipaciones > 0
                                    ? materia.participacionesActivas /
                                        materia.totalParticipaciones
                                    : 0,
                            backgroundColor: Colors.red.shade100,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Participaciones efectivas: ${_calcularPorcentajeParticipacion(materia.participacionesActivas, materia.totalParticipaciones)}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      )
                      : const Text(
                        'Sin registros de participación',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
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

  String _calcularPorcentajeParticipacion(int activas, int total) {
    if (total == 0) return '0.0';
    return ((activas * 100) / total).toStringAsFixed(1);
  }
}

// Clases auxiliares para manejar los datos
class MateriaParticipacion {
  final String nombreMateria;
  final String nombreProfesor;
  final String curso;
  final List<ParticipacionData> participaciones;
  final int totalParticipaciones;
  final int participacionesActivas;

  MateriaParticipacion({
    required this.nombreMateria,
    required this.nombreProfesor,
    required this.curso,
    required this.participaciones,
    required this.totalParticipaciones,
    required this.participacionesActivas,
  });
}

class ParticipacionData {
  final String fecha;
  final bool participo;

  ParticipacionData({required this.fecha, required this.participo});
}
