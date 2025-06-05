import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_drawer.dart';
import '../../services/auth_service.dart';
import '../../models/usuario_model.dart';
import '../../models/GestionesResponse_model.dart';
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
  Set<String> _aniosDisponibles = {};

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

        // Solo cargar datos después de cargar usuario
        if (_usuario != null) {
          final provider = Provider.of<CalificacionProvider>(
            context,
            listen: false,
          );
          // Cargar calificaciones consolidadas
          await provider.obtenerCalificacionesConsolidadas();
          // Cargar resumen de gestiones
          await provider.obtenerResumenGestiones();

          // Obtener los años disponibles
          if (mounted) {
            setState(() {
              _aniosDisponibles =
                  provider.resumenGestiones
                      .map((g) => g.gestion.split('-')[0])
                      .toSet();
            });
          }
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
          if (provider.isLoading || provider.isLoadingResumen) {
            return _buildLoadingIndicator();
          }

          if (provider.error.isNotEmpty) {
            return _buildErrorMessage(
              'Error al cargar calificaciones',
              provider.error,
            );
          }

          if (provider.errorResumen.isNotEmpty) {
            return _buildErrorMessage(
              'Error al cargar resumen de gestiones',
              provider.errorResumen,
            );
          }

          // Si no hay gestiones, mostrar mensaje
          if (provider.resumenGestiones.isEmpty) {
            return _buildErrorMessage(
              'No hay gestiones disponibles',
              'No se encontraron datos de gestiones académicas.',
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mis Gestiones Académicas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecciona una gestión para ver tus calificaciones',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),

                //Aca falta nashe deah
                Expanded(
                  child: ListView(
                    children: () {
                      final anios =
                          _aniosDisponibles.toList()
                            ..sort((a, b) => b.compareTo(a));
                      return anios
                          .map<Widget>(
                            (anio) =>
                                _buildAnioSection(context, provider, anio),
                          )
                          .toList();
                    }(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnioSection(
    BuildContext context,
    CalificacionProvider provider,
    String anio,
  ) {
    List<GestionesResponse> gestionesAnio = provider.getGestionesPorAnio(anio);

    // Ordenar por trimestre
    gestionesAnio.sort((a, b) => a.gestion.compareTo(b.gestion));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.9)),
              const SizedBox(width: 8),
              Text(
                'Gestión $anio',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),

        // Tarjetas de trimestres para este año
        ...gestionesAnio
            .map((gestion) => _buildGestionCard(context, gestion))
            .toList(),

        // Mostrar resumen anual
        _buildResumenAnualCard(provider, anio),

        const Divider(color: Colors.white, height: 1),
      ],
    );
  }

  Widget _buildGestionCard(BuildContext context, GestionesResponse gestion) {
    // Extraer información de la gestión
    final partes = gestion.gestion.split('-');
    final anio = partes[0];
    final trimestre = partes[1].replaceAll('T', '');

    // Configurar información visual según el trimestre
    IconData icon;
    Color color;
    String subtitle;

    switch (trimestre) {
      case '1':
        icon = Icons.auto_awesome;
        color = Colors.blue.shade700;
        subtitle = 'Primer Trimestre $anio';
        break;
      case '2':
        icon = Icons.grade;
        color = Colors.amber.shade700;
        subtitle = 'Segundo Trimestre $anio';
        break;
      case '3':
        icon = Icons.emoji_events;
        color = Colors.green.shade700;
        subtitle = 'Tercer Trimestre $anio';
        break;
      default:
        icon = Icons.school;
        color = Colors.purple.shade700;
        subtitle = 'Trimestre $trimestre de $anio';
    }

    final bool tieneCalificaciones =
        gestion.promedioRendimientoAcademicoReal >= 0;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => CalificacionTrimestreScreen(
                      titulo: 'Calificaciones ${subtitle}',
                      trimestre: trimestre,
                    ),
              ),
            ),
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
                          'Trimestre $trimestre',
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
                      'Rendimiento Real',
                      gestion.promedioRendimientoAcademicoReal.toStringAsFixed(
                        2,
                      ),
                      Colors.blue,
                    ),
                    _buildStatItem(
                      'Rendimiento Est.',
                      gestion.promedioRendimientoAcademicoEstimado
                          .toStringAsFixed(2),
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

  Widget _buildResumenAnualCard(CalificacionProvider provider, String anio) {
    double promedioReal = provider.getPromedioRendimientoRealAnual(anio);
    double promedioEstimado = provider.getPromedioRendimientoEstimadoAnual(
      anio,
    );

    // Si no hay datos reales, no mostrar la tarjeta
    if (promedioReal <= 0) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.red.shade50,
      margin: const EdgeInsets.only(top: 16),
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
                  'Resumen Anual $anio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildResumenStatItem(
                  'Rendimiento Real',
                  promedioReal.toStringAsFixed(2),
                  Colors.blue.shade700,
                ),
                _buildResumenStatItem(
                  'Rendimiento Estimado',
                  promedioEstimado.toStringAsFixed(2),
                  Colors.orange.shade700,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _getCalificacionTexto(promedioReal),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.red.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
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

  String _getCalificacionTexto(double nota) {
    if (nota >= 90) return '¡Excelente desempeño!';
    if (nota >= 80) return '¡Muy buen trabajo!';
    if (nota >= 70) return 'Buen desempeño';
    if (nota >= 60) return 'Desempeño aceptable';
    if (nota >= 50) return 'Necesita mejorar';
    return 'Desempeño insuficiente';
  }
}
