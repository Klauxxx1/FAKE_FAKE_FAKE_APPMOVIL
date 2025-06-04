import 'package:aula_inteligente_si2/screen/calificacion/calificacion_trimestre_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screen/calificacion/calificacion_provider.dart';

class CalificacionScreen extends StatefulWidget {
  const CalificacionScreen({Key? key}) : super(key: key);

  @override
  State<CalificacionScreen> createState() => _CalificacionScreenState();
}

class _CalificacionScreenState extends State<CalificacionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificaciones'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 3.5,
                  mainAxisSpacing: 20,
                  children: [
                    _buildNavigationCard(
                      context,
                      'Trimestre 1-2026',
                      Icons.assignment,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const CalificacionTrimestreScreen(
                                titulo: 'Calificaciones 1-2026',
                                trimestreId: 1,
                              ),
                        ),
                      ),
                    ),
                    _buildNavigationCard(
                      context,
                      'Trimestre 2-2026',
                      Icons.assignment_outlined,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const CalificacionTrimestreScreen(
                                titulo: 'Calificaciones 2-2026',
                                trimestreId: 2,
                              ),
                        ),
                      ),
                    ),
                    _buildNavigationCard(
                      context,
                      'Trimestre 3-2026',
                      Icons.assignment_turned_in,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const CalificacionTrimestreScreen(
                                titulo: 'Calificaciones 3-2026',
                                trimestreId: 3,
                              ),
                        ),
                      ),
                    ),
                    _buildNavigationCard(
                      context,
                      'Gestión 2026',
                      Icons.school,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const CalificacionTrimestreScreen(
                                titulo: 'Calificaciones Gestión 2026',
                                trimestreId: 0,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.red.shade100, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.red),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
