import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  Stream<String> get onAuthStateChanged {
    return FirebaseAuth.instance.onAuthStateChanged
        .map((FirebaseUser user) => user?.uid);
  }

  Future<String> getUserId() async {
    return (await FirebaseAuth.instance.currentUser()).uid;
  }

  Future getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  Future<String> createUserWithEmailAndPassword(
      String name, String email, String password) async {
    AuthResult authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = authResult.user;
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = name;
    user.updateProfile(userUpdateInfo);
    user.reload();
    return user.uid;
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    AuthResult authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = authResult.user;
    return user.uid;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
