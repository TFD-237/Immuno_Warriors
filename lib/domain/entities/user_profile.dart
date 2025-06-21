// lib/domain/entities/user_profile.dart

import 'package:flutter/foundation.dart';

class UserProfile {
  final String userId; // L'UID Firebase de l'utilisateur
  String username;
  String email;
  DateTime creationDate;
  int cyberCredits; // Monnaie du jeu
  int niveau; // Niveau du joueur
  int experience; // Points d'expérience

  UserProfile({
    required this.userId,
    required this.username,
    required this.email,
    required this.creationDate,
    this.cyberCredits = 0,
    this.niveau = 1,
    this.experience = 0,
  });

  // Convertit l'objet UserProfile en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'creationDate': creationDate.toIso8601String(), // Convertir DateTime en String
      'cyberCredits': cyberCredits,
      'niveau': niveau,
      'experience': experience,
    };
  }

  // Crée un objet UserProfile à partir d'un Map Firestore
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userId: map['userId'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      creationDate: DateTime.parse(map['creationDate'] as String), // Reconvertir String en DateTime
      cyberCredits: map['cyberCredits'] as int,
      niveau: map['niveau'] as int,
      experience: map['experience'] as int,
    );
  }

  // Méthodes pour mettre à jour le profil (exemple)
  void addExperience(int amount) {
    experience += amount;
    // Logique pour passer au niveau supérieur si l'expérience atteint un seuil
    print('Expérience ajoutée. Exp: $experience');
  }

  void addCyberCredits(int amount) {
    cyberCredits += amount;
    print('CyberCrédits ajoutés. CC: $cyberCredits');
  }

  void removeCyberCredits(int amount) {
    cyberCredits -= amount;
    if (cyberCredits < 0) cyberCredits = 0;
    print('CyberCrédits dépensés. CC: $cyberCredits');
  }
}