import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart'; // N'oubliez pas cet import !
import 'package:immunowarriors/domain/providers/auth_provider.dart';
import 'package:immunowarriors/presentation/auth/screens/registration_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final auth = ref.read(firebaseAuthProvider);
        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connexion réussie ! Préparation au déploiement...')),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'Identifiant inconnu. Vérifiez vos accréditations.';
        } else if (e.code == 'wrong-password') {
          message = 'Mot de passe erroné. Accès refusé.';
        } else if (e.code == 'invalid-email') {
          message = 'Format d\'email non valide. Vérifiez votre saisie.';
        } else {
          message = 'Échec de connexion : ${e.message}';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur système inattendue : $e')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Définition des couleurs thématiques pour un look cyber-militaire
    final Color primaryColor = Color(0xFF1A1A1A); // Presque noir
    final Color accentColor = Color(0xFF00C853); // Vert vif (comme sur votre image)
    final Color textColor = Colors.white70; // Texte légèrement estompé
    final Color hintColor = Colors.white38; // Texte d'aide discret
    final Color inputFillColor = Color(0xFF2C2C2C); // Fond des champs plus clair que l'arrière-plan

    return Scaffold(
      backgroundColor: primaryColor, // Arrière-plan sombre
      appBar: AppBar(
        title: Text(
          'ImmunoWarriors',
          style: TextStyle(
            color: accentColor, // Titre en vert vif
            fontWeight: FontWeight.bold,
            fontSize: 28, // Taille plus grande
            letterSpacing: 1.5, // Espacement des lettres pour un look "digital"
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // AppBar transparente
        elevation: 0, // Pas d'ombre
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0), // Plus d'espace
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch, // Étire les éléments
              children: <Widget>[
                Text(
                  'Authentification du Cyber-Guerrier',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50), // Plus d'espace
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: textColor), // Couleur du texte entré
                  decoration: InputDecoration(
                    labelText: 'Adresse Email',
                    labelStyle: TextStyle(color: hintColor),
                    filled: true,
                    fillColor: inputFillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none, // Pas de bordure visible par défaut
                    ),
                    focusedBorder: OutlineInputBorder( // Bordure verte quand le champ est sélectionné
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: accentColor, width: 2.0),
                    ),
                    prefixIcon: Icon(Icons.email, color: accentColor),
                    hintText: 'commandeur@immunowarriors.net',
                    hintStyle: TextStyle(color: hintColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Champ email requis. Accréditations nécessaires.';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Email invalide. Format attendu : user@domain.com.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25), // Plus d'espace
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: TextStyle(color: hintColor),
                    filled: true,
                    fillColor: inputFillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: accentColor, width: 2.0),
                    ),
                    prefixIcon: Icon(Icons.lock, color: accentColor),
                    hintText: '************',
                    hintStyle: TextStyle(color: hintColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mot de passe requis. Accès sécurisé impératif.';
                    }
                    if (value.length < 6) {
                      return 'Mot de passe trop court. Minimum 6 caractères pour la sécurité.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implémenter la navigation vers un écran "Mot de passe oublié"
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Protocole de récupération du mot de passe en cours de développement...')),
                      );
                    },
                    child: Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(color: accentColor.withOpacity(0.8), fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? Center(child: CircularProgressIndicator(color: accentColor))
                    : ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55), // Bouton plus grand
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rayon plus doux
                    ),
                    backgroundColor: accentColor, // Bouton vert vif
                    foregroundColor: primaryColor, // Texte sombre sur bouton clair
                    elevation: 5, // Légère ombre
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  child: const Text('ACCÉDER AU SYSTÈME'),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nouvelle recrue ?',
                      style: TextStyle(color: textColor.withOpacity(0.7)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                        );
                      },
                      child: Text(
                        "Créer un nouveau profil",
                        style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}