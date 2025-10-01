import 'package:flutter/material.dart';
import 'evaluaciones_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcome';

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Corrección: manejo seguro del argumento email
    final email =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Usuario';

    final verdePalmeras = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenida')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                'https://i.ibb.co/yn3xH18P/descarga.png',
                height: 100,
              ),
              const SizedBox(height: 16),
              Text(
                'Bienvenido $email 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Gracias por ser parte de la Junta Vecinal Las Palmeras 🌿',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Botón para ir al listado de evaluaciones
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    EvaluacionesScreen.routeName,
                    arguments: email,
                  );
                },
                icon: const Icon(Icons.list),
                label: const Text(
                  "Ir a Evaluaciones",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: verdePalmeras,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
