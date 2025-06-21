// lib/presentation/anti_corps/anti_corps_creation_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immunowarriors/domain/entities/anti_corps.dart';
import 'package:immunowarriors/domain/entities/ressources_defensives.dart';
import 'package:immunowarriors/domain/providers/auth_provider.dart';
import 'package:immunowarriors/domain/providers/user_data_providers.dart'; // Pour les ressources
import 'package:immunowarriors/infrastructure/repositories/user_repository.dart';

class AntiCorpsCreationScreen extends ConsumerStatefulWidget {
  const AntiCorpsCreationScreen({super.key});

  @override
  ConsumerState<AntiCorpsCreationScreen> createState() => _AntiCorpsCreationScreenState();
}

class _AntiCorpsCreationScreenState extends ConsumerState<AntiCorpsCreationScreen> {
  final _antiCorpsNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _antiCorpsNameController.dispose();
    super.dispose();
  }

  Future<void> _createAntiCorps() async {
    final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
    if (userId == null) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur: Utilisateur non connecté.')));
      return;
    }

    if (_antiCorpsNameController.text.trim().isEmpty) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez donner un nom à votre Anticorps.')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userRepository = ref.read(userRepositoryProvider);
      final currentResources = await ref.read(userResourcesStreamProvider.future); // Accéder à la valeur future des ressources

      if (currentResources == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur: Ressources non disponibles.')));
        return;
      }

      // Définir le coût de l'anticorps (peut être variable plus tard)
      const int costEnergie = 100;
      const int costProteines = 50;
      const int costCellulesSouches = 10;

      // Vérifier si le joueur a suffisamment de ressources
      if (currentResources.energie < costEnergie ||
          currentResources.proteines < costProteines ||
          currentResources.cellulesSouches < costCellulesSouches) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ressources insuffisantes pour créer cet Anticorps.')),
          );
        }
        return;
      }

      // Consommer les ressources
      currentResources.consumeEnergie(costEnergie);
      currentResources.consumeProteines(costProteines);
      currentResources.consumeCellulesSouches(costCellulesSouches);

      // Mettre à jour les ressources dans Firestore
      await userRepository.updateResources(userId, currentResources);

      // Créer le nouvel anticorps
      final newAntiCorps = AntiCorps(
        id: 'anti_corps_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        nom: _antiCorpsNameController.text.trim(),
        type: AntiCorpsType.standard, // Pour l'instant, seulement un type standard
        pointsDeVie: 50,
        attaque: 10,
        defense: 5,
        coutEnergie: costEnergie,
        coutProteines: costProteines,
        coutCellulesSouches: costCellulesSouches,
      );

      // Ajouter l'anticorps à Firestore
      await userRepository.addAntiCorps(userId, newAntiCorps);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${newAntiCorps.nom} a été créé avec succès !')),
        );
        _antiCorpsNameController.clear(); // Effacer le champ après création
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création de l\'Anticorps: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF1A1A1A);
    final Color accentColor = Color(0xFF00C853);
    final Color textColor = Colors.white70;
    final Color inputFillColor = Color(0xFF2C2C2C);
    final Color hintColor = Colors.white38;

    // Observez les ressources pour les afficher en temps réel
    final resourcesAsync = ref.watch(userResourcesStreamProvider);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'Forge d\'Anticorps',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.science, size: 80, color: accentColor),
            const SizedBox(height: 20),
            Text(
              'Créez de puissants Anticorps pour défendre votre système !',
              style: TextStyle(fontSize: 18, color: textColor), // <-- CORRECTION ICI
              textAlign: TextAlign.center, // <-- CORRECTION ICI
            ),
            const SizedBox(height: 30),

            // Affichage des ressources actuelles de l'utilisateur
            resourcesAsync.when(
              data: (resources) {
                if (resources == null) {
                  return Text('Chargement des ressources...', style: TextStyle(color: textColor));
                }
                return Card(
                  color: inputFillColor,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vos Ressources Actuelles:', style: TextStyle(color: accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text('Énergie: ${resources.energie}', style: TextStyle(color: textColor, fontSize: 16)),
                        Text('Protéines: ${resources.proteines}', style: TextStyle(color: textColor, fontSize: 16)),
                        Text('Cellules Souches: ${resources.cellulesSouches}', style: TextStyle(color: textColor, fontSize: 16)),
                        const SizedBox(height: 10),
                        Text('Coût de l\'Anticorps Standard:', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('100 Énergie, 50 Protéines, 10 Cellules Souches', style: TextStyle(color: textColor, fontSize: 14)),
                      ],
                    ),
                  ),
                );
              },
              loading: () => Center(child: CircularProgressIndicator(color: accentColor)),
              error: (e, st) => Text('Erreur de chargement des ressources: $e', style: TextStyle(color: Colors.red)),
            ),

            TextFormField(
              controller: _antiCorpsNameController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Nom de l\'Anticorps',
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
                prefixIcon: Icon(Icons.colorize, color: accentColor),
                hintText: 'Mon Anticorps Alpha',
                hintStyle: TextStyle(color: hintColor),
              ),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: accentColor))
                : ElevatedButton.icon(
              onPressed: _createAntiCorps,
              icon: Icon(Icons.build, color: primaryColor),
              label: const Text('FORGER UN ANTICORPS'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: accentColor,
                foregroundColor: primaryColor,
                elevation: 5,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Vos Anticorps Forgés:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Consumer(
              builder: (context, ref, child) { // <-- CORRECTION: 'ref' au lieu de 'watch' ici
                final AsyncValue<List<AntiCorps>> antiCorpsAsync = ref.watch(userImmuneMemoryAntiCorpsStreamProvider);

                return antiCorpsAsync.when(
                  data: (antiCorpsList) {
                    if (antiCorpsList.isEmpty) {
                      return Text(
                        'Aucun anticorps forgé pour le moment.',
                        style: TextStyle(color: textColor),
                        textAlign: TextAlign.center,
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: antiCorpsList.length,
                      itemBuilder: (context, index) {
                        final antiCorps = antiCorpsList[index];
                        // Définir userRepository et userId ici, dans la portée du builder
                        final userRepository = ref.read(userRepositoryProvider); // <-- CORRECTION ICI
                        final userId = ref.read(firebaseAuthProvider).currentUser?.uid; // <-- CORRECTION ICI

                        return Card(
                          color: inputFillColor,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Icon(Icons.medical_services, color: accentColor),
                            title: Text(antiCorps.nom, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              'PV: ${antiCorps.pointsDeVie}, Att: ${antiCorps.attaque}, Def: ${antiCorps.defense}',
                              style: TextStyle(color: textColor),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () async {
                                if (userId != null) { // Vérification supplémentaire pour userId
                                  await userRepository.deleteAntiCorps(userId, antiCorps.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${antiCorps.nom} supprimé.')),
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Erreur: Impossible de supprimer l\'anticorps, utilisateur non identifié.')),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => Center(child: CircularProgressIndicator(color: accentColor)),
                  error: (e, st) => Text('Erreur lors du chargement des anticorps: $e', style: TextStyle(color: Colors.red)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Ce provider reste inchangé, il était déjà correct
final userImmuneMemoryAntiCorpsStreamProvider = StreamProvider.autoDispose<List<AntiCorps>>((ref) {
  final currentUser = ref.watch(firebaseAuthProvider).currentUser;
  final userId = currentUser?.uid;

  if (userId == null) {
    return Stream.value([]);
  }

  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getAntiCorpsStream(userId);
});