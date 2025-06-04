import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screen/calificacion/calificacion_provider.dart';

class CalificacionTrimestreScreen extends StatefulWidget {
  final String titulo;
  final int trimestreId;

  const CalificacionTrimestreScreen({
    Key? key,
    required this.titulo,
    required this.trimestreId,
  }) : super(key: key);

  @override
  State<CalificacionTrimestreScreen> createState() =>
      _CalificacionTrimestreScreenState();
}

class _CalificacionTrimestreScreenState
    extends State<CalificacionTrimestreScreen> {
  bool _isLoading = true;
  List<MateriaCalificacion> _materias = [];

  @override
  void initState() {
    super.initState();
    // Simular carga de datos
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _materias = _getMockCalificaciones();
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
                      return _buildMateriaCalificacionCard(_materias[index]);
                    },
                  ),
                ),
      ),
    );
  }

  Widget _buildMateriaCalificacionCard(MateriaCalificacion materia) {
    Color notaColor;
    if (materia.notaFinal >= 80) {
      notaColor = Colors.green;
    } else if (materia.notaFinal >= 70) {
      notaColor = Colors.blue;
    } else if (materia.notaFinal >= 51) {
      notaColor = Colors.orange;
    } else {
      notaColor = Colors.red;
    }

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
              child: Row(
                children: [
                  Expanded(
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
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Curso: ${materia.curso}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: notaColor,
                    ),
                    child: Center(
                      child: Text(
                        materia.notaFinal.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Notas por dimensión
            const Text(
              'Detalles de la calificación:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),

            _buildNotaItem('Saber', materia.notaSaber),
            _buildNotaItem('Hacer', materia.notaHacer),
            _buildNotaItem('Ser', materia.notaSer),
            _buildNotaItem('Decidir', materia.notaDecidir),

            const SizedBox(height: 16),

            // Resumen y nota final
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
                    'Evaluación Final:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Nota final:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        materia.notaFinal.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: notaColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _getCalificacionTexto(materia.notaFinal),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: notaColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: materia.notaFinal / 100,
                    backgroundColor: Colors.red.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(notaColor),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotaItem(String dimension, double nota) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$dimension:',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: nota / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(_getNotaColor(nota)),
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 40,
            child: Text(
              nota.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getNotaColor(nota),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Color _getNotaColor(double nota) {
    if (nota >= 80) return Colors.green;
    if (nota >= 70) return Colors.blue;
    if (nota >= 51) return Colors.orange;
    return Colors.red;
  }

  String _getCalificacionTexto(double nota) {
    if (nota >= 90) return 'Excelente';
    if (nota >= 80) return 'Muy Bueno';
    if (nota >= 70) return 'Bueno';
    if (nota >= 51) return 'Regular';
    return 'Insuficiente';
  }

  List<MateriaCalificacion> _getMockCalificaciones() {
    // Datos de ejemplo para mostrar en las tarjetas
    return [
      MateriaCalificacion(
        nombreMateria: 'Matemáticas',
        nombreProfesor: 'Profesor Álvarez',
        curso: '2° - A',
        notaSaber: 85.0,
        notaHacer: 90.0,
        notaSer: 75.0,
        notaDecidir: 82.0,
        notaFinal: 83.0,
      ),
      MateriaCalificacion(
        nombreMateria: 'Lenguaje',
        nombreProfesor: 'Profesora Gutiérrez',
        curso: '2° - A',
        notaSaber: 92.0,
        notaHacer: 88.0,
        notaSer: 95.0,
        notaDecidir: 90.0,
        notaFinal: 91.0,
      ),
      MateriaCalificacion(
        nombreMateria: 'Historia',
        nombreProfesor: 'Profesor Rodríguez',
        curso: '2° - A',
        notaSaber: 78.0,
        notaHacer: 75.0,
        notaSer: 90.0,
        notaDecidir: 82.0,
        notaFinal: 81.0,
      ),
      MateriaCalificacion(
        nombreMateria: 'Ciencias Naturales',
        nombreProfesor: 'Profesor Ramírez',
        curso: '2° - A',
        notaSaber: 75.0,
        notaHacer: 72.0,
        notaSer: 85.0,
        notaDecidir: 78.0,
        notaFinal: 77.0,
      ),
      MateriaCalificacion(
        nombreMateria: 'Educación Física',
        nombreProfesor: 'Profesor López',
        curso: '2° - A',
        notaSaber: 65.0,
        notaHacer: 95.0,
        notaSer: 90.0,
        notaDecidir: 80.0,
        notaFinal: 82.0,
      ),
      MateriaCalificacion(
        nombreMateria: 'Arte',
        nombreProfesor: 'Profesora Sánchez',
        curso: '2° - A',
        notaSaber: 90.0,
        notaHacer: 95.0,
        notaSer: 100.0,
        notaDecidir: 90.0,
        notaFinal: 94.0,
      ),
      MateriaCalificacion(
        nombreMateria: 'Música',
        nombreProfesor: 'Profesor García',
        curso: '2° - A',
        notaSaber: 85.0,
        notaHacer: 92.0,
        notaSer: 90.0,
        notaDecidir: 85.0,
        notaFinal: 88.0,
      ),
      MateriaCalificacion(
        nombreMateria: 'Inglés',
        nombreProfesor: 'Profesora Wilson',
        curso: '2° - A',
        notaSaber: 75.0,
        notaHacer: 68.0,
        notaSer: 85.0,
        notaDecidir: 72.0,
        notaFinal: 75.0,
      ),
      MateriaCalificacion(
        nombreMateria: 'Computación',
        nombreProfesor: 'Profesor Torres',
        curso: '2° - A',
        notaSaber: 95.0,
        notaHacer: 98.0,
        notaSer: 90.0,
        notaDecidir: 92.0,
        notaFinal: 94.0,
      ),
      MateriaCalificacion(
        nombreMateria: 'Religión',
        nombreProfesor: 'Profesor Huerta',
        curso: '2° - A',
        notaSaber: 80.0,
        notaHacer: 85.0,
        notaSer: 95.0,
        notaDecidir: 85.0,
        notaFinal: 86.0,
      ),
    ];
  }
}

// Clase auxiliar para manejar los datos de ejemplo
class MateriaCalificacion {
  final String nombreMateria;
  final String nombreProfesor;
  final String curso;
  final double notaSaber;
  final double notaHacer;
  final double notaSer;
  final double notaDecidir;
  final double notaFinal;

  MateriaCalificacion({
    required this.nombreMateria,
    required this.nombreProfesor,
    required this.curso,
    required this.notaSaber,
    required this.notaHacer,
    required this.notaSer,
    required this.notaDecidir,
    required this.notaFinal,
  });
}
