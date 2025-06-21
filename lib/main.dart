// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importez User
import 'firebase_options.dart';
import 'package:immunowarriors/domain/providers/auth_provider.dart'; // Pour authStateChangesProvider
import 'package:immunowarriors/presentation/auth/screens/splash_screen.dart';
import 'package:immunowarriors/presentation/auth/screens/login_screen.dart';
import 'package:immunowarriors/presentation/home/temporary_home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Observez l'état du flux d'authentification
    final authState = ref.watch(authStateChangesProvider);

    return MaterialApp(
      title: 'ImmunoWarriors',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 2. Décidez quel écran afficher en fonction de l'état d'authentification
      home: authState.when(
        data: (user) {
          // Si des données sont disponibles (utilisateur connecté ou non)
          if (user != null) {
            // Utilisateur connecté, redirige vers l'écran d'accueil temporaire
            return const TemporaryHomeScreen();
          } else {
            // Aucun utilisateur connecté, redirige vers l'écran de connexion
            return const LoginScreen();
          }
        },
        loading: () {
          // Pendant le chargement initial de l'état d'authentification, affiche le Splash Screen
          return const SplashScreen();
        },
        error: (error, stack) {
          // En cas d'erreur de chargement de l'état d'authentification
          // Vous pouvez afficher un écran d'erreur ou simplement l'écran de connexion
          print('Erreur d\'état d\'authentification: $error');
          return const LoginScreen(); // Redirige vers la connexion en cas d'erreur
        },
      ),
    );
  }
}