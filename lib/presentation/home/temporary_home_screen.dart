// lib/presentation/home/temporary_home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immunowarriors/domain/providers/auth_provider.dart';
import 'package:immunowarriors/domain/entities/agent_pathogene.dart';
// Importez vos nouveaux providers de données utilisateur
import 'package:immunowarriors/domain/providers/user_data_providers.dart';
import 'package:immunowarriors/infrastructure/repositories/firestore_service.dart';
// Importez l'écran de création d'anticorps
import 'package:immunowarriors/presentation/anti_corps/anti_corps_creation_screen.dart';

import '../../domain/entities/ressources_defensives.dart';
import '../../domain/entities/user_profile.dart';


class TemporaryHomeScreen extends ConsumerWidget {
  const TemporaryHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color primaryColor = Color(0xFF1A1A1A);
    final Color accentColor = Color(0xFF00C853);
    final firestoreService = ref.read(firestoreServiceProvider);

    // Observez le profil utilisateur et les ressources via leurs StreamProviders
    final AsyncValue<UserProfile?> userProfileAsync = ref.watch(userProfileStreamProvider);
    final AsyncValue<RessourcesDefensives?> resourcesAsync = ref.watch(userResourcesStreamProvider);

    // Le currentUser est toujours nécessaire pour le bouton de déconnexion et la logique
    final currentUser = ref.watch(firebaseAuthProvider).currentUser;
    final userId = currentUser?.uid;


    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'ImmunoWarriors - Quartier Général',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: accentColor),
            onPressed: () async {
              await ref.read(firebaseAuthProvider).signOut();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Déconnexion réussie. Accès révoqué.')),
                );
              }
            },
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: userId == null // Vérifier si l'utilisateur est bien connecté et son ID disponible
          ? Center(
        child: CircularProgressIndicator(color: accentColor),
      )
          : Column(
        children: [
          SingleChildScrollView( // Enveloppez les éléments fixes dans un SingleChildScrollView
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.security,
                  size: 80,
                  color: accentColor,
                ),
                const SizedBox(height: 20),
                Text(
                  'Bienvenue, Cyber-Guerrier !',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // --- Affichage du profil utilisateur ---
                userProfileAsync.when(
                  data: (profile) {
                    if (profile == null) {
                      return Text(
                        'Chargement profil...',
                        style: TextStyle(color: Colors.white70),
                      );
                    }
                    return Column(
                      children: [
                        Text(
                          'Nom: ${profile.username}',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          'Niveau: ${profile.niveau} | Exp: ${profile.experience} | Crédits: ${profile.cyberCredits}',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    );
                  },
                  loading: () => CircularProgressIndicator(color: accentColor),
                  error: (e, st) => Text('Erreur profil: $e', style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(height: 20),
                // --- Affichage des ressources ---
                resourcesAsync.when(
                  data: (resources) {
                    if (resources == null) {
                      return Text(
                        'Chargement ressources...',
                        style: TextStyle(color: Colors.white70),
                      );
                    }
                    return Column(
                      children: [
                        Text(
                          'Ressources :',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          'Énergie: ${resources.energie} | Protéines: ${resources.proteines} | Cellules Souches: ${resources.cellulesSouches}',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    );
                  },
                  loading: () => CircularProgressIndicator(color: accentColor),
                  error: (e, st) => Text('Erreur ressources: $e', style: TextStyle(color: Colors.red)),
                ),

                const SizedBox(height: 30),
                // Bouton pour ajouter un agent pathogène de test
                ElevatedButton.icon(
                  onPressed: () async {
                    final testVirus = Virus(
                      id: 'virus_${DateTime.now().millisecondsSinceEpoch}',
                      nom: 'Grippe Numérique',
                      pointsDeVie: 100,
                      attaque: 15,
                      defense: 5,
                      recompense: {'energie': 10, 'proteines': 5},
                      tauxDeMutation: 0.2,
                    );

                    try {
                      await firestoreService.addDocument(
                        'agents_pathogenes',
                        testVirus.toMap(),
                        docId: testVirus.id,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Agent Pathogène ajouté à la base de données !')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erreur lors de l\'ajout de l\'agent: $e')),
                        );
                      }
                    }
                  },
                  icon: Icon(Icons.add_box, color: primaryColor),
                  label: const Text('Déployer un Agent Pathogène'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 15), // Espace entre les boutons

                // NOUVEAU BOUTON : Créer un Anticorps
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AntiCorpsCreationScreen()),
                    );
                  },
                  icon: Icon(Icons.build_circle, color: primaryColor),
                  label: const Text('Forger un Anticorps'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Une couleur différente pour la distinction
                    foregroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  'Agents Pathogènes Déployés (Test):',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Fin du SingleChildScrollView
              ],
            ),
          ),
          Expanded( // Permet au ListView de prendre l'espace restant
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: firestoreService.getCollectionStream('agents_pathogenes'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: accentColor));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur de chargement des données: ${snapshot.error}', style: TextStyle(color: Colors.red)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun agent pathogène trouvé.', style: TextStyle(color: Colors.white70)));
                }

                final agentsData = snapshot.data!;
                return ListView.builder(
                  itemCount: agentsData.length,
                  itemBuilder: (context, index) {
                    try {
                      final agent = AgentPathogene.fromMap(agentsData[index]);
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        color: Color(0xFF2C2C2C),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.bug_report, color: accentColor),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nom: ${agent.nom} (${agent.type})',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    Text('PV: ${agent.pointsDeVie}, Att: ${agent.attaque}, Def: ${agent.defense}',
                                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                                    if (agent is Virus)
                                      Text('Mutation: ${agent.tauxDeMutation}', style: TextStyle(color: Colors.white54)),
                                    if (agent is Bactery)
                                      Text('Résistance: ${agent.resistanceAntibiotique}', style: TextStyle(color: Colors.white54)),
                                    if (agent is Fungus)
                                      Text('Toxicité: ${agent.toxicite}', style: TextStyle(color: Colors.white54)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () async {
                                  await firestoreService.deleteDocument('agents_pathogenes', agent.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${agent.nom} supprimé.')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    } catch (e) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        color: Color(0xFF2C2C2C),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Erreur de données pour un agent: $e',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}