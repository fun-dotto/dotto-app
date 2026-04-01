import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:dotto/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';

final class FirebaseAuthHelper {
  static const _webClientId = '107577467292-10sqodijnvb7qn0rnjoda8q0tvq4ebrr.apps.googleusercontent.com';

  static Future<void> initialize() {
    return GoogleSignIn.instance.initialize(
      clientId: switch (defaultTargetPlatform) {
        TargetPlatform.iOS => DefaultFirebaseOptions.ios.iosClientId,
        _ => null,
      },
      serverClientId: switch (defaultTargetPlatform) {
        TargetPlatform.android => _webClientId,
        _ => null,
      },
    );
  }

  static Future<UserCredential> _authenticate() async {
    final account = await GoogleSignIn.instance.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw Exception('Google Sign-In の ID token を取得できませんでした');
    }
    final credential = GoogleAuthProvider.credential(idToken: idToken);
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
