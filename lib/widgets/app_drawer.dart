import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/usuario_model.dart';

class AppDrawer extends StatelessWidget {
  final Usuario usuario;

  const AppDrawer({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.red),
            accountName: Text(
              usuario.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(usuario.correo),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Text(
                getInitials(usuario.nombre),
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Calificaciones'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/calificaciones');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Asistencia'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/asistencia');
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Participación'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/participacion');
            },
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Predicción'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/prediccion');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mi Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/perfil');
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () async {
              final AuthService authService = AuthService();
              await authService.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    String initials = '';
    if (nameParts.isNotEmpty) {
      initials += nameParts[0][0];
      if (nameParts.length > 1) {
        initials += nameParts[1][0];
      }
    }
    return initials.toUpperCase();
  }
}
