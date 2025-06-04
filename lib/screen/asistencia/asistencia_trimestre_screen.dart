import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screen/asistencia/asistencia_provider.dart';
import '../../models/asistencia_model.dart';

class AsistenciaTrimestreScreen extends StatefulWidget {
  final String titulo;
  final int trimestreId;

  const AsistenciaTrimestreScreen({
    Key? key,
    required this.titulo,
    required this.trimestreId,
  }) : super(key: key);

  @override
  State<AsistenciaTrimestreScreen> createState() =>
      _AsistenciaTrimestreScreenState();
}

class _AsistenciaTrimestreScreenState extends State<AsistenciaTrimestreScreen> {
  bool _isLoading = true;
  List<MateriaTarjeta> _materias = [];

  @override
  void initState() {
    super.initState();
    // Simular carga de datos
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _materias = _getMockMaterias();
        _isLoading = false;
      });
    });
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
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: _materias.length,
                    itemBuilder: (context, index) {
                      return _buildMateriaTarjeta(_materias[index]);
                    },
                  ),
                ),
      ),
    );
  }

  Widget _buildMateriaTarjeta(MateriaTarjeta materia) {
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
                      '- ${asistencia.fecha}: ',
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
                    'Porcentaje de asistencia: ${(materia.presentes * 100 / (materia.presentes + materia.faltas)).toStringAsFixed(1)}%',
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

  List<MateriaTarjeta> _getMockMaterias() {
    // Datos de ejemplo para mostrar en las tarjetas
    return [
      MateriaTarjeta(
        nombreMateria: 'Matemáticas',
        nombreProfesor: 'Profesor Álvarez',
        curso: '2° - A',
        asistencias: [
          AsistenciaData(fecha: '2025-06-01', asistio: true),
          AsistenciaData(fecha: '2025-06-03', asistio: true),
          AsistenciaData(fecha: '2025-06-05', asistio: false),
          AsistenciaData(fecha: '2025-06-07', asistio: true),
        ],
        presentes: 3,
        faltas: 1,
      ),
      MateriaTarjeta(
        nombreMateria: 'Lenguaje',
        nombreProfesor: 'Profesora Gutiérrez',
        curso: '2° - A',
        asistencias: [
          AsistenciaData(fecha: '2025-06-02', asistio: true),
          AsistenciaData(fecha: '2025-06-04', asistio: false),
          AsistenciaData(fecha: '2025-06-06', asistio: true),
          AsistenciaData(fecha: '2025-06-08', asistio: true),
        ],
        presentes: 3,
        faltas: 1,
      ),
      MateriaTarjeta(
        nombreMateria: 'Historia',
        nombreProfesor: 'Profesor Rodríguez',
        curso: '2° - A',
        asistencias: [
          AsistenciaData(fecha: '2025-06-01', asistio: false),
          AsistenciaData(fecha: '2025-06-03', asistio: true),
          AsistenciaData(fecha: '2025-06-05', asistio: true),
          AsistenciaData(fecha: '2025-06-07', asistio: true),
        ],
        presentes: 3,
        faltas: 1,
      ),
      MateriaTarjeta(
        nombreMateria: 'Ciencias Naturales',
        nombreProfesor: 'Profesor Ramírez',
        curso: '2° - A',
        asistencias: [
          AsistenciaData(fecha: '2025-06-02', asistio: true),
          AsistenciaData(fecha: '2025-06-04', asistio: true),
          AsistenciaData(fecha: '2025-06-06', asistio: true),
          AsistenciaData(fecha: '2025-06-08', asistio: false),
        ],
        presentes: 3,
        faltas: 1,
      ),
      MateriaTarjeta(
        nombreMateria: 'Educación Física',
        nombreProfesor: 'Profesor López',
        curso: '2° - A',
        asistencias: [
          AsistenciaData(fecha: '2025-06-01', asistio: true),
          AsistenciaData(fecha: '2025-06-03', asistio: false),
          AsistenciaData(fecha: '2025-06-05', asistio: true),
          AsistenciaData(fecha: '2025-06-07', asistio: true),
        ],
        presentes: 3,
        faltas: 1,
      ),
      MateriaTarjeta(
        nombreMateria: 'Arte',
        nombreProfesor: 'Profesora Sánchez',
        curso: '2° - A',
        asistencias: [
          AsistenciaData(fecha: '2025-06-02', asistio: true),
          AsistenciaData(fecha: '2025-06-04', asistio: true),
          AsistenciaData(fecha: '2025-06-06', asistio: false),
          AsistenciaData(fecha: '2025-06-08', asistio: true),
        ],
        presentes: 3,
        faltas: 1,
      ),
      MateriaTarjeta(
        nombreMateria: 'Música',
        nombreProfesor: 'Profesor García',
        curso: '2° - A',
        asistencias: [
          AsistenciaData(fecha: '2025-06-01', asistio: false),
          AsistenciaData(fecha: '2025-06-03', asistio: true),
          AsistenciaData(fecha: '2025-06-05', asistio: true),
          AsistenciaData(fecha: '2025-06-07', asistio: true),
        ],
        presentes: 3,
        faltas: 1,
      ),
      MateriaTarjeta(
        nombreMateria: 'Inglés',
        nombreProfesor: 'Profesora Wilson',
        curso: '2° - A',
        asistencias: [
          AsistenciaData(fecha: '2025-06-02', asistio: true),
          AsistenciaData(fecha: '2025-06-04', asistio: true),
          AsistenciaData(fecha: '2025-06-06', asistio: true),
          AsistenciaData(fecha: '2025-06-08', asistio: true),
        ],
        presentes: 4,
        faltas: 0,
      ),
      MateriaTarjeta(
        nombreMateria: 'Computación',
        nombreProfesor: 'Profesor Torres',
        curso: '2° - A',
        asistencias: [
          AsistenciaData(fecha: '2025-06-01', asistio: true),
          AsistenciaData(fecha: '2025-06-03', asistio: true),
          AsistenciaData(fecha: '2025-06-05', asistio: false),
          AsistenciaData(fecha: '2025-06-07', asistio: false),
        ],
        presentes: 2,
        faltas: 2,
      ),
      MateriaTarjeta(
        nombreMateria: 'Religión',
        nombreProfesor: 'Profesor Huerta',
        curso: '2° - A',
        asistencias: [
          AsistenciaData(fecha: '2025-06-02', asistio: true),
          AsistenciaData(fecha: '2025-06-04', asistio: false),
          AsistenciaData(fecha: '2025-06-06', asistio: true),
          AsistenciaData(fecha: '2025-06-08', asistio: true),
        ],
        presentes: 3,
        faltas: 1,
      ),
    ];
  }
}

// Clases auxiliares para manejar los datos de ejemplo
class MateriaTarjeta {
  final String nombreMateria;
  final String nombreProfesor;
  final String curso;
  final List<AsistenciaData> asistencias;
  final int presentes;
  final int faltas;

  MateriaTarjeta({
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
