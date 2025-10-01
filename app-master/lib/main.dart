import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/evaluaciones_screen.dart'; // 👈 Importa la pantalla de evaluaciones

void main() {
  runApp(const LasPalmerasApp());
}

class LasPalmerasApp extends StatelessWidget {
  const LasPalmerasApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF43A047); // Verde esmeralda
    final scheme = ColorScheme.fromSeed(seedColor: seed);

    return MaterialApp(
      title: 'Junta Vecinal Las Palmeras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          centerTitle: true,
          elevation: 0.5,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            foregroundColor: scheme.onPrimary,
            backgroundColor: scheme.primary,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        WelcomeScreen.routeName: (_) => const WelcomeScreen(),
        EvaluacionesScreen.routeName: (_) =>
            const EvaluacionesScreen(), // 👈 Ruta agregada
      },
    );
  }
}
