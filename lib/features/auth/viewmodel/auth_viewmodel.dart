import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/services/firebase_service.dart';

class AuthViewModel extends GetxController {
  final FirebaseService _firebase;

  AuthViewModel(this._firebase);

  final Rxn<User> user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    user.value = _firebase.auth.currentUser;
    _firebase.auth.authStateChanges().listen((u) {
      user.value = u;
      update();
    });
  }

  Future<void> signInAnon() async {
    if (_firebase.auth.currentUser == null) {
      await _firebase.signInAnonymously();
    }
  }
}
