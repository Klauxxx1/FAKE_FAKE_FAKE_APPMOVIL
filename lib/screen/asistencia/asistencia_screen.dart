import 'package:flutter/material.dart';
import 'asistencia_trimestre_screen.dart';

class AsistenciaScreen extends StatefulWidget {
  const AsistenciaScreen({Key? key}) : super(key: key);

  @override
  State<AsistenciaScreen> createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends State<AsistenciaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencia'),
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
                      'Trimestre 1-2025',
                      Icons.calendar_today,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const AsistenciaTrimestreScreen(
                                titulo: 'Asistencia 1-2025',
                                trimestreId: 1,
                                gestionTrimestral: '2025-T1',
                              ),
                        ),
                      ),
                    ),
                    _buildNavigationCard(
                      context,
                      'Trimestre 2-2025',
                      Icons.calendar_month,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const AsistenciaTrimestreScreen(
                                titulo: 'Asistencia 2-2025',
                                trimestreId: 2,
                                gestionTrimestral: '2025-T2',
                              ),
                        ),
                      ),
                    ),
                    _buildNavigationCard(
                      context,
                      'Trimestre 3-2025',
                      Icons.calendar_view_month,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const AsistenciaTrimestreScreen(
                                titulo: 'Asistencia 3-2025',
                                trimestreId: 3,
                                gestionTrimestral: '2025-T3',
                              ),
                        ),
                      ),
                    ),
                    _buildNavigationCard(
                      context,
                      'Gestión 2025',
                      Icons.school,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const AsistenciaTrimestreScreen(
                                titulo: 'Asistencia Gestión 2025',
                                trimestreId: 0,
                                gestionTrimestral: '2025',
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
