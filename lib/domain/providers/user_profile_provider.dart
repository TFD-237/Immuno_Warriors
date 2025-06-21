import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immunowarriors/domain/entities/user_profile.dart';
import 'package:immunowarriors/domain/entities/ressources_defensives.dart';
import 'package:immunowarriors/domain/entities/memoire_immunitaire.dart';
import 'package:immunowarriors/domain/entities/laboratoire_recherche.dart';

/// Provider pour le profil utilisateur.
/// Pour l'instant, il retourne un profil factice.
/// Il sera connecté à Firestore et aux autres entités plus tard.
final userProfileProvider = StateProvider<UserProfile>((ref) {
  // Ceci est un profil factice pour commencer.
  // Il sera remplacé par la logique de chargement depuis Firestore.
  return UserProfile(
    userId: 'guest_user_id',
    nomUtilisateur: 'ImmunoWarrior Alpha',
    ressources: RessourcesDefensives(),
    memoireImmunitaire: MemoireImmunitaire(),
    laboRecherche: LaboratoireRecherche(),
  );
});

// Un exemple de provider pour accéder aux ressources spécifiques
final userResourcesProvider = Provider<RessourcesDefensives>((ref) {
  final userProfile = ref.watch(userProfileProvider);
  return userProfile.ressources;
});