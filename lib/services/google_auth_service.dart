import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Handles Google Sign-In for both Web and Android.
/// Returns the signed-in [UserCredential] on success, or null on cancellation.
/// Throws [FirebaseAuthException] or other exceptions on failure.
class GoogleAuthService {
  /// Web OAuth client ID from Firebase Console → Project Settings → Web client.
  static const _webClientId =
      '821670925029-cprbq48rpd3jjqn868d5pm19pjbob8cc.apps.googleusercontent.com';

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? _webClientId : null,
    scopes: ['email'],
  );

  static Future<UserCredential?> signIn() async {
    if (kIsWeb) {
      // On Web, use Firebase's built-in popup flow — no separate google_sign_in needed.
      final provider = GoogleAuthProvider();
      provider.addScope('email');
      return await FirebaseAuth.instance.signInWithPopup(provider);
    }

    // Android: native Google account picker.
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) return null; // user cancelled

    final GoogleSignInAuthentication auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// Signs out from Google (Android only — Firebase sign-out is handled separately).
  static Future<void> signOut() async {
    if (!kIsWeb) await _googleSignIn.signOut();
  }
}
