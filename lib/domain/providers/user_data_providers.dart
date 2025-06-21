// lib/domain/providers/user_data_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immunowarriors/domain/entities/user_profile.dart';
import 'package:immunowarriors/domain/entities/ressources_defensives.dart';
import 'package:immunowarriors/infrastructure/repositories/user_repository.dart';
import 'package:immunowarriors/domain/providers/auth_provider.dart';

import '../entities/laboratoire_recherche.dart';
import '../entities/memoire_immunitaire.dart'; // Pour obtenir l'ID utilisateur

// Provider pour le Stream du profil utilisateur
final userProfileStreamProvider = StreamProvider.autoDispose<UserProfile?>((ref) {
  final currentUser = ref.watch(firebaseAuthProvider).currentUser;
  final userId = currentUser?.uid;

  if (userId == null) {
    return Stream.value(null); // Pas d'utilisateur connecté, pas de profil
  }

  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getUserProfileStream(userId);
});

// Provider pour le Stream des ressources défensives de l'utilisateur
final userResourcesStreamProvider = StreamProvider.autoDispose<RessourcesDefensives?>((ref) {
  final currentUser = ref.watch(firebaseAuthProvider).currentUser;
  final userId = currentUser?.uid;

  if (userId == null) {
    return Stream.value(null); // Pas d'utilisateur connecté, pas de ressources
  }

  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getResourcesStream(userId);
});

// Vous pouvez ajouter d'autres providers similaires pour MemoireImmunitaire et LaboratoireRecherche si nécessaire
final userImmuneMemoryStreamProvider = StreamProvider.autoDispose<MemoireImmunitaire?>((ref) {
  final currentUser = ref.watch(firebaseAuthProvider).currentUser;
  final userId = currentUser?.uid;

  if (userId == null) {
    return Stream.value(null);
  }

  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getImmuneMemoryStream(userId);
});

final userResearchLabStreamProvider = StreamProvider.autoDispose<LaboratoireRecherche?>((ref) {
  final currentUser = ref.watch(firebaseAuthProvider).currentUser;
  final userId = currentUser?.uid;

  if (userId == null) {
    return Stream.value(null);
  }

  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getResearchLabStream(userId);
});