import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static AuthService _instance;

  AuthService._();

  static AuthService get instance {
    if (_instance == null) {
      _instance = AuthService._();
    }
    return _instance;
  }

  bool isLogged() {
    return _auth.currentUser != null;
  }

  Future<bool> signIn() async {
    UserCredential cred = await _signInWithGoogle();
    if (cred == null) return false;
    if (cred.user == null) return false;
    return true;
  }

  Future<UserCredential> _signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await _auth.signInWithPopup(googleProvider);
  }

  void logOut() {
    _auth.signOut();
  }
}
