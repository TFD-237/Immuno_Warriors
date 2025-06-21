// lib/infrastructure/repositories/user_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immunowarriors/domain/entities/user_profile.dart';
import 'package:immunowarriors/domain/entities/ressources_defensives.dart';
import 'package:immunowarriors/domain/entities/memoire_immunitaire.dart';
import 'package:immunowarriors/domain/entities/laboratoire_recherche.dart';
import 'package:immunowarriors/domain/entities/anti_corps.dart'; // NOUVEL IMPORT
import 'package:immunowarriors/infrastructure/repositories/firestore_service.dart';

class UserRepository {
  final FirestoreService _firestoreService;
  final String _usersCollection = 'users';

  UserRepository(this._firestoreService);

  Future<void> createUserInitialData({
    required String userId,
    required String username,
    required String email,
  }) async {
    final userProfile = UserProfile(
      userId: userId,
      username: username,
      email: email,
      creationDate: DateTime.now(),
      cyberCredits: 500,
      niveau: 1,
      experience: 0,
    );
    await _firestoreService.addDocument(
      _usersCollection,
      userProfile.toMap(),
      docId: userId,
    );

    final initialResources = RessourcesDefensives(userId: userId);
    await _firestoreService.addDocument(
      '$_usersCollection/$userId/user_data',
      initialResources.toMap(),
      docId: 'resources',
    );

    final initialMemory = MemoireImmunitaire(userId: userId);
    await _firestoreService.addDocument(
      '$_usersCollection/$userId/user_data',
      initialMemory.toMap(),
      docId: 'immune_memory',
    );

    final initialLab = LaboratoireRecherche(userId: userId);
    await _firestoreService.addDocument(
      '$_usersCollection/$userId/user_data',
      initialLab.toMap(),
      docId: 'research_lab',
    );
  }

  Stream<UserProfile?> getUserProfileStream(String userId) {
    return _firestoreService.getDocumentStream(_usersCollection, userId).map((data) {
      if (data != null) {
        return UserProfile.fromMap(data);
      }
      return null;
    });
  }

  Stream<RessourcesDefensives?> getResourcesStream(String userId) {
    return _firestoreService.getDocumentStream('$_usersCollection/$userId/user_data', 'resources').map((data) {
      if (data != null) {
        return RessourcesDefensives.fromMap(data);
      }
      return null;
    });
  }

  Future<void> updateUserProfile(String userId, UserProfile profile) async {
    await _firestoreService.updateDocument(_usersCollection, userId, profile.toMap());
  }

  Future<void> updateResources(String userId, RessourcesDefensives resources) async {
    await _firestoreService.updateDocument('$_usersCollection/$userId/user_data', 'resources', resources.toMap());
  }

  Stream<MemoireImmunitaire?> getImmuneMemoryStream(String userId) {
    return _firestoreService.getDocumentStream('$_usersCollection/$userId/user_data', 'immune_memory').map((data) {
      if (data != null) {
        return MemoireImmunitaire.fromMap(data);
      }
      return null;
    });
  }

  Stream<LaboratoireRecherche?> getResearchLabStream(String userId) {
    return _firestoreService.getDocumentStream('$_usersCollection/$userId/user_data', 'research_lab').map((data) {
      if (data != null) {
        return LaboratoireRecherche.fromMap(data);
      }
      return null;
    });
  }

  Future<void> updateImmuneMemory(String userId, MemoireImmunitaire memory) async {
    await _firestoreService.updateDocument('$_usersCollection/$userId/user_data', 'immune_memory', memory.toMap());
  }

  Future<void> updateResearchLab(String userId, LaboratoireRecherche lab) async {
    await _firestoreService.updateDocument('$_usersCollection/$userId/user_data', 'research_lab', lab.toMap());
  }

  // NOUVELLES MÉTHODES POUR LES ANTICORPS
  Future<void> addAntiCorps(String userId, AntiCorps antiCorps) async {
    final collectionPath = '$_usersCollection/$userId/antibodies';
    await _firestoreService.addDocument(
      collectionPath,
      antiCorps.toMap(),
      docId: antiCorps.id,
    );
  }

  Stream<List<AntiCorps>> getAntiCorpsStream(String userId) {
    final collectionPath = '$_usersCollection/$userId/antibodies';
    return _firestoreService.getCollectionStream(collectionPath).map((listMap) {
      return listMap.map((map) => AntiCorps.fromMap(map)).toList();
    });
  }

  Future<void> deleteAntiCorps(String userId, String antiCorpsId) async {
    final collectionPath = '$_usersCollection/$userId/antibodies';
    await _firestoreService.deleteDocument(collectionPath, antiCorpsId);
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return UserRepository(firestoreService);
});