// lib/domain/entities/ressources_defensives.dart

import 'package:flutter/foundation.dart';

class RessourcesDefensives {
  final String userId; // Pour lier ces ressources à un utilisateur spécifique
  int energie;
  int proteines;
  int cellulesSouches; // Pour la recherche et la fabrication d'anticorps

  RessourcesDefensives({
    required this.userId,
    this.energie = 1000,
    this.proteines = 500,
    this.cellulesSouches = 100,
  });

  // Convertit l'objet RessourcesDefensives en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'energie': energie,
      'proteines': proteines,
      'cellulesSouches': cellulesSouches,
    };
  }

  // Crée un objet RessourcesDefensives à partir d'un Map Firestore
  factory RessourcesDefensives.fromMap(Map<String, dynamic> map) {
    return RessourcesDefensives(
      userId: map['userId'] as String,
      energie: map['energie'] as int,
      proteines: map['proteines'] as int,
      cellulesSouches: map['cellulesSouches'] as int,
    );
  }

  // Méthodes pour gérer les ressources
  void addEnergie(int amount) {
    energie += amount;
    print('Énergie ajoutée. Total: $energie');
  }

  bool consumeEnergie(int amount) {
    if (energie >= amount) {
      energie -= amount;
      print('Énergie consommée. Restant: $energie');
      return true;
    }
    print('Manque d\'énergie.');
    return false;
  }

  void addProteines(int amount) {
    proteines += amount;
    print('Protéines ajoutées. Total: $proteines');
  }

  bool consumeProteines(int amount) {
    if (proteines >= amount) {
      proteines -= amount;
      print('Protéines consommées. Restant: $proteines');
      return true;
    }
    print('Manque de protéines.');
    return false;
  }

  void addCellulesSouches(int amount) {
    cellulesSouches += amount;
    print('Cellules souches ajoutées. Total: $cellulesSouches');
  }

  bool consumeCellulesSouches(int amount) {
    if (cellulesSouches >= amount) {
      cellulesSouches -= amount;
      print('Cellules souches consommées. Restant: $cellulesSouches');
      return true;
    }
    print('Manque de cellules souches.');
    return false;
  }
}