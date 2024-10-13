import 'package:firebase_auth/firebase_auth.dart';
import 'package:nike_store/Model/user_model.dart';
import 'package:nike_store/services/user_db_service.dart';

class Authservice {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final UserDatabaseService userdb = UserDatabaseService();
  User? getCurrentUser() {
    return auth.currentUser;
  }

  Future<User?> registerUserWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await userdb.storeUser(
            UserModel(name: name, email: email), result.user!.uid);
        return user;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return Future.error((e.code));
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      return Future.error((e.code));
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException {
      return;
    }
  }
}
