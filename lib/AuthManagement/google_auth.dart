import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> signInWithGoogle() async {
    try {
      if (!await _googleSignIn.isSignedIn()) {
        final user = await _googleSignIn.signIn();
        if (user == null)
          print("Google Sign In Not Completed");
        else {
          final GoogleSignInAuthentication googleAuth =
              await user.authentication;

          final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          final UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(oAuthCredential);

          print(
              'User Credential is: ${userCredential.user}   ${userCredential.additionalUserInfo}');
          return true;
        }
        return false;
      } else {
        print("Already Logged In");
        await logOut();
        return false;
      }
    } catch (e) {
      print("Google LogIn Error: ${e.toString()}");
      return false;
    }
  }

  Future<bool> logOut() async {
    try {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}