// lib/domain/entities/agent_pathogene.dart

import 'package:flutter/foundation.dart';

abstract class AgentPathogene {
  final String id;
  final String nom;
  final String type; // Ex: 'Virus', 'Bactery', 'Fungus'
  int pointsDeVie;
  final int attaque;
  final int defense;
  final Map<String, int> recompense;

  AgentPathogene({
    required this.id,
    required this.nom,
    required this.type,
    required this.pointsDeVie,
    required this.attaque,
    required this.defense,
    required this.recompense,
  });

  // Convertit l'objet AgentPathogene en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'type': type,
      'pointsDeVie': pointsDeVie,
      'attaque': attaque,
      'defense': defense,
      'recompense': recompense,
    };
  }

  // Méthode factory pour créer un AgentPathogene à partir d'un Map Firestore
  factory AgentPathogene.fromMap(Map<String, dynamic> map) {
    // Cette méthode doit être intelligente pour instancier la bonne sous-classe
    // en fonction du champ 'type'.
    switch (map['type']) {
      case 'Virus':
        return Virus.fromMap(map);
      case 'Bactery':
        return Bactery.fromMap(map);
      case 'Fungus':
        return Fungus.fromMap(map);
      default:
        throw Exception('Type d\'agent pathogène inconnu : ${map['type']}');
    }
  }

  void subirDegats(int degats) {
    pointsDeVie -= degats;
    if (pointsDeVie < 0) pointsDeVie = 0;
    print('$nom a subi $degats dégâts. PV restants: $pointsDeVie');
  }

  int attaquer() {
    return attaque;
  }

  bool estDetruit() => pointsDeVie <= 0;
}

// Classe concrète pour un Virus
class Virus extends AgentPathogene {
  final double tauxDeMutation;

  Virus({
    required String id,
    required String nom,
    required int pointsDeVie,
    required int attaque,
    required int defense,
    required Map<String, int> recompense,
    this.tauxDeMutation = 0.1,
  }) : super(
    id: id,
    nom: nom,
    type: 'Virus',
    pointsDeVie: pointsDeVie,
    attaque: attaque,
    defense: defense,
    recompense: recompense,
  );

  // Constructeur factory pour créer un Virus à partir d'un Map
  factory Virus.fromMap(Map<String, dynamic> map) {
    return Virus(
      id: map['id'] as String,
      nom: map['nom'] as String,
      pointsDeVie: map['pointsDeVie'] as int,
      attaque: map['attaque'] as int,
      defense: map['defense'] as int,
      recompense: Map<String, int>.from(map['recompense'] as Map),
      tauxDeMutation: map['tauxDeMutation'] as double,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(), // Inclut les propriétés de la classe parente
      'tauxDeMutation': tauxDeMutation,
    };
  }

  @override
  int attaquer() {
    print('$nom (Virus) lance une attaque furtive!');
    return super.attaquer();
  }
}

// Classe concrète pour une Bactérie
class Bactery extends AgentPathogene {
  final double resistanceAntibiotique;

  Bactery({
    required String id,
    required String nom,
    required int pointsDeVie,
    required int attaque,
    required int defense,
    required Map<String, int> recompense,
    this.resistanceAntibiotique = 0.2,
  }) : super(
    id: id,
    nom: nom,
    type: 'Bactery',
    pointsDeVie: pointsDeVie,
    attaque: attaque,
    defense: defense,
    recompense: recompense,
  );

  // Constructeur factory pour créer une Bactery à partir d'un Map
  factory Bactery.fromMap(Map<String, dynamic> map) {
    return Bactery(
      id: map['id'] as String,
      nom: map['nom'] as String,
      pointsDeVie: map['pointsDeVie'] as int,
      attaque: map['attaque'] as int,
      defense: map['defense'] as int,
      recompense: Map<String, int>.from(map['recompense'] as Map),
      resistanceAntibiotique: map['resistanceAntibiotique'] as double,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'resistanceAntibiotique': resistanceAntibiotique,
    };
  }

  @override
  void subirDegats(int degats) {
    int degatsEffectifs = (degats * (1 - resistanceAntibiotique)).toInt();
    super.subirDegats(degatsEffectifs);
    print('$nom (Bactérie) sa résistance a réduit les dégâts !');
  }
}

// Classe concrète pour un Champignon
class Fungus extends AgentPathogene {
  final int toxicite;

  Fungus({
    required String id,
    required String nom,
    required int pointsDeVie,
    required int attaque,
    required int defense,
    required Map<String, int> recompense,
    this.toxicite = 5,
  }) : super(
    id: id,
    nom: nom,
    type: 'Fungus',
    pointsDeVie: pointsDeVie,
    attaque: attaque,
    defense: defense,
    recompense: recompense,
  );

  // Constructeur factory pour créer un Fungus à partir d'un Map
  factory Fungus.fromMap(Map<String, dynamic> map) {
    return Fungus(
      id: map['id'] as String,
      nom: map['nom'] as String,
      pointsDeVie: map['pointsDeVie'] as int,
      attaque: map['attaque'] as int,
      defense: map['defense'] as int,
      recompense: Map<String, int>.from(map['recompense'] as Map),
      toxicite: map['toxicite'] as int,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'toxicite': toxicite,
    };
  }

  @override
  int attaquer() {
    print('$nom (Champignon) libère des spores toxiques !');
    return super.attaquer() + toxicite;
  }
}