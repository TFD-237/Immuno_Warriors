// lib/domain/entities/memoire_immunitaire.dart

import 'package:flutter/foundation.dart';
import 'package:immunowarriors/domain/entities/agent_pathogene.dart'; // Importez si MemoireImmunitaire fait référence à AgentPathogene

class MemoireImmunitaire {
  final String userId; // Pour lier à un utilisateur
  final List<String> pathogenesVaincusIds; // IDs des pathogènes déjà rencontrés/vaincus
  final Map<String, int> immuniteSpecifique; // Ex: {'virus_grippe_numerique': 5, 'bacterie_blindee': 3}

  MemoireImmunitaire({
    required this.userId,
    this.pathogenesVaincusIds = const [],
    this.immuniteSpecifique = const {},
  });

  // Convertit l'objet MemoireImmunitaire en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'pathogenesVaincusIds': pathogenesVaincusIds,
      'immuniteSpecifique': immuniteSpecifique,
    };
  }

  // Crée un objet MemoireImmunitaire à partir d'un Map Firestore
  factory MemoireImmunitaire.fromMap(Map<String, dynamic> map) {
    return MemoireImmunitaire(
      userId: map['userId'] as String,
      pathogenesVaincusIds: List<String>.from(map['pathogenesVaincusIds'] as List),
      immuniteSpecifique: Map<String, int>.from(map['immuniteSpecifique'] as Map),
    );
  }

  // Méthodes pour gérer la mémoire immunitaire
  void enregistrerVictoire(String agentPathogeneId) {
    if (!pathogenesVaincusIds.contains(agentPathogeneId)) {
      pathogenesVaincusIds.add(agentPathogeneId);
      print('Mémoire immunitaire mise à jour: $agentPathogeneId vaincu.');
    }
    // Augmenter l'immunité spécifique si nécessaire
    immuniteSpecifique.update(agentPathogeneId, (value) => value + 1, ifAbsent: () => 1);
  }

  int getImmunitePour(String agentPathogeneId) {
    return immuniteSpecifique[agentPathogeneId] ?? 0;
  }
}