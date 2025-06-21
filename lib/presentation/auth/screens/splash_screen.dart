// lib/presentation/splash/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Garder si vous utilisez ref pour des styles par exemple

// Nous n'avons plus besoin des imports de LoginScreen et TemporaryHomeScreen ici
// car la navigation est gérée au niveau de MyApp.

class SplashScreen extends ConsumerWidget { // Peut redevenir StatelessWidget si aucune utilisation de ref
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Garder WidgetRef si reste ConsumerWidget
    // Style thématique pour le splash screen
    final Color primaryColor = Color(0xFF1A1A1A); // Couleur sombre de votre thème
    final Color accentColor = Color(0xFF00C853); // Vert vif

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ImmunoWarriors',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: accentColor,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Initialisation du Système...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ],
        ),
      ),
    );
  }
}