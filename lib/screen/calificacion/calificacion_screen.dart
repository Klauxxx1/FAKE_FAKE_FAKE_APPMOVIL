import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_drawer.dart';
import '../../services/auth_service.dart';
import '../../models/usuario_model.dart';
import 'calificacion_provider.dart';
import 'calificacion_trimestre_screen.dart';

class CalificacionScreen extends StatefulWidget {
  const CalificacionScreen({Key? key}) : super(key: key);

  @override
  State<CalificacionScreen> createState() => _CalificacionScreenState();
}

class _CalificacionScreenState extends State<CalificacionScreen> {
  final AuthService _authService = AuthService();
  Usuario? _usuario;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    try {
      final usuario = await _authService.getCurrentUser();
      if (mounted) {
        setState(() {
          _usuario = usuario;
          _isLoading = false;
        });

        // Solo cargar calificaciones después de cargar usuario
        if (_usuario != null) {
          await Provider.of<CalificacionProvider>(
            context,
            listen: false,
          ).obtenerCalificacionesConsolidadas();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Calificaciones'),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      drawer:
          _isLoading
              ? null
              : (_usuario != null ? AppDrawer(usuario: _usuario!) : null),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }

    if (_usuario == null) {
      return _buildErrorMessage(
        'Debes iniciar sesión',
        'No se puede acceder a las calificaciones sin iniciar sesión.',
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
      child: Consumer<CalificacionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return _buildLoadingIndicator();
          }

          if (provider.error.isNotEmpty) {
            return _buildErrorMessage(
              'Error al cargar calificaciones',
              provider.error,
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestión Académica 2025',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecciona un trimestre para ver tus calificaciones',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView(
                    children: [
                      _buildTrimestreCard(
                        context,
                        'Primer Trimestre',
                        'Febrero - Mayo 2025',
                        Icons.auto_awesome,
                        Colors.blue.shade700,
                        provider.calcularPromedioTrimestre('1'),
                        provider.calcularRendimientoEstimadoPromedio('1'),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const CalificacionTrimestreScreen(
                                  titulo: 'Calificaciones 1° Trimestre',
                                  trimestre: '1',
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTrimestreCard(
                        context,
                        'Segundo Trimestre',
                        'Junio - Agosto 2025',
                        Icons.grade,
                        Colors.amber.shade700,
                        provider.calcularPromedioTrimestre('2'),
                        provider.calcularRendimientoEstimadoPromedio('2'),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const CalificacionTrimestreScreen(
                                  titulo: 'Calificaciones 2° Trimestre',
                                  trimestre: '2',
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTrimestreCard(
                        context,
                        'Tercer Trimestre',
                        'Septiembre - Noviembre 2025',
                        Icons.emoji_events,
                        Colors.green.shade700,
                        provider.calcularPromedioTrimestre('3'),
                        provider.calcularRendimientoEstimadoPromedio('3'),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const CalificacionTrimestreScreen(
                                  titulo: 'Calificaciones 3° Trimestre',
                                  trimestre: '3',
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPromedioPeriodoCard(provider),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
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

  Widget _buildErrorMessage(String title, String message) {
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _cargarUsuario,
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

  Widget _buildTrimestreCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    double promedio,
    double rendimientoEstimado,
    VoidCallback onTap,
  ) {
    final bool tieneCalificaciones = promedio > 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
              if (tieneCalificaciones) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem(
                      'Promedio',
                      promedio.toStringAsFixed(2),
                      Colors.blue,
                    ),
                    _buildStatItem(
                      'Rendimiento Est.',
                      rendimientoEstimado.toStringAsFixed(2),
                      Colors.orange,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromedioPeriodoCard(CalificacionProvider provider) {
    // Calcular el promedio general de todos los trimestres
    double promedioT1 = provider.calcularPromedioTrimestre('1');
    double promedioT2 = provider.calcularPromedioTrimestre('2');
    double promedioT3 = provider.calcularPromedioTrimestre('3');

    // Contar cuántos trimestres tienen calificaciones
    int trimestresConCalificacion = 0;
    if (promedioT1 > 0) trimestresConCalificacion++;
    if (promedioT2 > 0) trimestresConCalificacion++;
    if (promedioT3 > 0) trimestresConCalificacion++;

    // Calcular promedio general
    double promedioGeneral =
        trimestresConCalificacion > 0
            ? (promedioT1 + promedioT2 + promedioT3) / trimestresConCalificacion
            : 0.0;

    // Si no hay calificaciones, no mostrar este card
    if (promedioGeneral <= 0) return const SizedBox();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, color: Colors.red.shade700, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Promedio General Anual',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.shade200.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                promedioGeneral.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getCalificacionTexto(promedioGeneral),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCalificacionTexto(double nota) {
    if (nota >= 90) return '¡Excelente desempeño!';
    if (nota >= 80) return '¡Muy buen trabajo!';
    if (nota >= 70) return 'Buen desempeño';
    if (nota >= 60) return 'Desempeño aceptable';
    if (nota >= 50) return 'Necesita mejorar';
    return 'Desempeño insuficiente';
  }
}
