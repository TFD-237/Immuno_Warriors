// lib/infrastructure/repositories/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Un Provider pour l'instance de Firestore
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  // Méthode générique pour récupérer un document par son ID
  Stream<Map<String, dynamic>?> getDocumentStream(String collectionPath, String docId) {
    return _firestore.collection(collectionPath).doc(docId).snapshots().map((snapshot) {
      return snapshot.data();
    });
  }

  // Méthode générique pour récupérer tous les documents d'une collection
  Stream<List<Map<String, dynamic>>> getCollectionStream(String collectionPath) {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Méthode générique pour ajouter un nouveau document
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data, {String? docId}) async {
    if (docId != null) {
      await _firestore.collection(collectionPath).doc(docId).set(data);
    } else {
      await _firestore.collection(collectionPath).add(data);
    }
  }

  // Méthode générique pour mettre à jour un document
  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).doc(docId).update(data);
  }

  // Méthode générique pour supprimer un document
  Future<void> deleteDocument(String collectionPath, String docId) async {
    await _firestore.collection(collectionPath).doc(docId).delete();
  }
}

// Provider pour le FirestoreService
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return FirestoreService(firestore);
});