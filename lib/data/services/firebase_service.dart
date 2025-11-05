import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth auth;
  final FirebaseFirestore store;

  FirebaseService({required this.auth, required this.store});

  Future<UserCredential> signInAnonymously() => auth.signInAnonymously();

  CollectionReference<Map<String, dynamic>> tasksCollection(String uid) =>
      store.collection('users').doc(uid).collection('tasks');
}
