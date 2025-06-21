// lib/domain/entities/laboratoire_recherche.dart

import 'package:flutter/foundation.dart';

class LaboratoireRecherche {
  final String userId; // Pour lier à un utilisateur
  int niveauLaboratoire;
  Map<String, int> recherchesDebloquees; // Ex: {'antiCorps_T_evolue': 1, 'booster_energie': 1}
  Map<String, DateTime> recherchesEnCours; // Ex: {'recherche_xyz': date_fin}

  LaboratoireRecherche({
    required this.userId,
    this.niveauLaboratoire = 1,
    this.recherchesDebloquees = const {},
    this.recherchesEnCours = const {},
  });

  // Convertit l'objet LaboratoireRecherche en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'niveauLaboratoire': niveauLaboratoire,
      'recherchesDebloquees': recherchesDebloquees,
      // Convertir DateTime en String pour Firestore
      'recherchesEnCours': recherchesEnCours.map((key, value) => MapEntry(key, value.toIso8601String())),
    };
  }

  // Crée un objet LaboratoireRecherche à partir d'un Map Firestore
  factory LaboratoireRecherche.fromMap(Map<String, dynamic> map) {
    // Reconvertir String en DateTime pour les recherches en cours
    Map<String, DateTime> parsedRecherchesEnCours = {};
    if (map['recherchesEnCours'] != null) {
      (map['recherchesEnCours'] as Map).forEach((key, value) {
        parsedRecherchesEnCours[key as String] = DateTime.parse(value as String);
      });
    }

    return LaboratoireRecherche(
      userId: map['userId'] as String,
      niveauLaboratoire: map['niveauLaboratoire'] as int,
      recherchesDebloquees: Map<String, int>.from(map['recherchesDebloquees'] as Map),
      recherchesEnCours: parsedRecherchesEnCours,
    );
  }

  // Méthodes pour gérer le laboratoire
  void ameliorerLaboratoire() {
    niveauLaboratoire++;
    print('Laboratoire amélioré au niveau $niveauLaboratoire');
  }

  void demarrerRecherche(String rechercheId, DateTime dateFin) {
    recherchesEnCours[rechercheId] = dateFin;
    print('Recherche "$rechercheId" démarrée, finira le $dateFin');
  }

  void debloquerRecherche(String rechercheId) {
    recherchesDebloquees.update(rechercheId, (value) => value + 1, ifAbsent: () => 1);
    recherchesEnCours.remove(rechercheId); // Supprime de la liste des recherches en cours
    print('Recherche "$rechercheId" débloquée.');
  }
}