import 'package:firebase_auth/firebase_auth.dart';
import 'package:training_journal/Services/firestore_database.dart';
import 'package:training_journal/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    if (user != null) {
      return User(
        id: user.uid,
      );
    } else {
      return null;
    }
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future<String> getCurrentUserUID() async {
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  Future register(
      String email, String password, String name, String username) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid)
          .updateUserData(name, username, 0.0, 0, 0);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteUser() async {
    try {
      FirebaseUser user = await _auth.currentUser();
      return user.delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future reAuthenticateUser(AuthCredential credential) async {
    try {
      FirebaseUser user = await _auth.currentUser();
      return await user.reauthenticateWithCredential(credential);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return Error;
    }
  }
}
