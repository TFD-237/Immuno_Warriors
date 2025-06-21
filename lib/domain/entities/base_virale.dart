// lib/domain/entities/base_virale.dart

import 'package:flutter/foundation.dart';
import 'agent_pathogene.dart'; // Importez les classes d'agents pathogènes

class BaseVirale {
  final String id;
  final String nom;
  int pointsDeVie;
  final int niveau;
  final List<AgentPathogene> agentsGeneres; // Liste des types d'agents que cette base peut générer

  BaseVirale({
    required this.id,
    required this.nom,
    required this.pointsDeVie,
    required this.niveau,
    required this.agentsGeneres,
  });

  // Convertit l'objet BaseVirale en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'pointsDeVie': pointsDeVie,
      'niveau': niveau,
      // Convertir la liste d'AgentPathogene en liste de Map pour Firestore
      'agentsGeneres': agentsGeneres.map((agent) => agent.toMap()).toList(),
    };
  }

  // Méthode factory pour créer une BaseVirale à partir d'un Map Firestore
  factory BaseVirale.fromMap(Map<String, dynamic> map) {
    // Convertir la liste de Map en liste d'AgentPathogene
    List<AgentPathogene> generatedAgents = [];
    if (map['agentsGeneres'] != null) {
      generatedAgents = (map['agentsGeneres'] as List)
          .map((agentMap) => AgentPathogene.fromMap(agentMap as Map<String, dynamic>))
          .toList();
    }

    return BaseVirale(
      id: map['id'] as String,
      nom: map['nom'] as String,
      pointsDeVie: map['pointsDeVie'] as int,
      niveau: map['niveau'] as int,
      agentsGeneres: generatedAgents,
    );
  }

  void subirDegats(int degats) {
    pointsDeVie -= degats;
    if (pointsDeVie < 0) pointsDeVie = 0;
    print('La Base Virale $nom a subi $degats dégâts. PV restants: $pointsDeVie');
  }

  bool estDetruite() => pointsDeVie <= 0;

  // Méthode pour simuler la génération d'un agent pathogène
  AgentPathogene? genererNouvelAgent() {
    if (agentsGeneres.isNotEmpty) {
      // Pour l'exemple, retourne le premier type d'agent, ou un aléatoire
      // Idéalement, vous auriez une logique plus complexe ici
      AgentPathogene agentType = agentsGeneres.first;
      String newId = '${agentType.id}_${DateTime.now().microsecondsSinceEpoch}';

      // Crée une nouvelle instance de l'agent pathogène
      if (agentType is Virus) {
        return Virus(
          id: newId,
          nom: '${agentType.nom}_${niveau}',
          pointsDeVie: agentType.pointsDeVie * niveau,
          attaque: agentType.attaque * niveau,
          defense: agentType.defense * niveau,
          recompense: agentType.recompense,
          tauxDeMutation: agentType.tauxDeMutation,
        );
      } else if (agentType is Bactery) {
        return Bactery(
          id: newId,
          nom: '${agentType.nom}_${niveau}',
          pointsDeVie: agentType.pointsDeVie * niveau,
          attaque: agentType.attaque * niveau,
          defense: agentType.defense * niveau,
          recompense: agentType.recompense,
          resistanceAntibiotique: agentType.resistanceAntibiotique,
        );
      } else if (agentType is Fungus) {
        return Fungus(
          id: newId,
          nom: '${agentType.nom}_${niveau}',
          pointsDeVie: agentType.pointsDeVie * niveau,
          attaque: agentType.attaque * niveau,
          defense: agentType.defense * niveau,
          recompense: agentType.recompense,
          toxicite: agentType.toxicite,
        );
      }
    }
    print('La Base Virale $nom génère un nouvel agent !');
    return null;
  }
}