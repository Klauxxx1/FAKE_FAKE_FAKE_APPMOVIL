import 'package:aula_inteligente_si2/screen/asistencia/asistencia_screen.dart';
import 'package:aula_inteligente_si2/screen/calificacion/calificacion_screen.dart';
import 'package:aula_inteligente_si2/screen/home/home_screen.dart';
import 'package:aula_inteligente_si2/screen/participacion/participacion_screen.dart';
import 'package:aula_inteligente_si2/screen/perfil/perfil_screen.dart';
import 'package:aula_inteligente_si2/screen/prediccion/prediccion_screen.dart';
import 'package:aula_inteligente_si2/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screen/auth/login_screen.dart';
import 'screen/auth/auth_provider.dart';
import 'screen/calificacion/calificacion_provider.dart';
// Otros imports...

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CalificacionProvider()),
        // ChangeNotifierProvider(create: (ctx) => DatosHistoricosProvider()),
        // Otros providers...
      ],
      child: MaterialApp(
        title: 'Aula Inteligente',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/perfil': (context) => const PerfilScreen(),
          '/asistencia': (context) => const AsistenciaScreen(),
          '/participacion': (context) => const ParticipacionScreen(),
          '/calificaciones': (context) => const CalificacionScreen(),
          '/prediccion': (context) => const PrediccionScreen(),
          // '/datos-historicos': (ctx) => const DatosHistoricosScreen(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    await _authService.logout(); //klaus duda de esta linea de codigo xd

    bool isLoggedIn = await _authService.isLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Aula Inteligente',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
            const SizedBox(height: 20),
            Text(
              'Cargando...',
              style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
