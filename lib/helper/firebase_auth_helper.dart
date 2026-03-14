import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final class FirebaseAuthHelper {
  static Future<UserCredential> _authenticate() async {
    final account = await GoogleSignIn.instance.authenticate();
    final credential = GoogleAuthProvider.credential(idToken: account.authentication.idToken);
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<User> signIn() async {
    final credential = await _authenticate();
    final user = credential.user;
    if (user == null) {
      throw Exception('User is null');
    }
    if (user.email == null) {
      await user.delete();
      throw Exception('User email is null');
    }
    return user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
  }
}
