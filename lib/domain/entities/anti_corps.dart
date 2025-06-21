// lib/domain/entities/anti_corps.dart

import 'package:flutter/foundation.dart';

// Enum pour les types d'anticorps si vous voulez les diversifier
enum AntiCorpsType { standard, rapide, lourd, specialise }

class AntiCorps {
  final String id;
  final String userId; // Pour lier l'anticorps à l'utilisateur qui l'a créé
  String nom;
  String description;
  AntiCorpsType type;
  int pointsDeVie;
  int attaque;
  int defense;
  int coutEnergie;
  int coutProteines;
  int coutCellulesSouches; // Nouvelle ressource

  AntiCorps({
    required this.id,
    required this.userId,
    required this.nom,
    this.description = 'Un anticorps standard, prêt au combat.',
    this.type = AntiCorpsType.standard,
    this.pointsDeVie = 50,
    this.attaque = 10,
    this.defense = 5,
    this.coutEnergie = 100,
    this.coutProteines = 50,
    this.coutCellulesSouches = 10, // Coût par défaut
  });

  // Convertit l'objet AntiCorps en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'nom': nom,
      'description': description,
      'type': type.toString().split('.').last, // Stocke le nom de l'enum
      'pointsDeVie': pointsDeVie,
      'attaque': attaque,
      'defense': defense,
      'coutEnergie': coutEnergie,
      'coutProteines': coutProteines,
      'coutCellulesSouches': coutCellulesSouches,
    };
  }

  // Crée un objet AntiCorps à partir d'un Map Firestore
  factory AntiCorps.fromMap(Map<String, dynamic> map) {
    return AntiCorps(
      id: map['id'] as String,
      userId: map['userId'] as String,
      nom: map['nom'] as String,
      description: map['description'] as String,
      type: AntiCorpsType.values.firstWhere(
            (e) => e.toString().split('.').last == map['type'],
        orElse: () => AntiCorpsType.standard,
      ),
      pointsDeVie: map['pointsDeVie'] as int,
      attaque: map['attaque'] as int,
      defense: map['defense'] as int,
      coutEnergie: map['coutEnergie'] as int,
      coutProteines: map['coutProteines'] as int,
      coutCellulesSouches: map['coutCellulesSouches'] as int,
    );
  }

  // Méthodes spécifiques aux anticorps (ex: améliorer, attaquer)
  void ameliorerAttaque(int points) {
    attaque += points;
    print('$nom attaque améliorée à $attaque');
  }
}