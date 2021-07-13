import 'package:e_bucket/different_types/email_auth_types.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthentication {
  Future<bool> signUp({required String email, required String pwd}) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pwd);
      print('UserCredential: ${userCredential.additionalUserInfo}');

      await userCredential.user!.sendEmailVerification();

      return true;
    } catch (e) {
      print('Sign Up Error: ${e.toString()}');
      return false;
    }
  }

  Future<EmailVerificationTypes> logIn(
      {required String email, required String pwd}) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);

      print('UserCredential: ${userCredential.additionalUserInfo}');

      if (userCredential.user!.emailVerified)
        return EmailVerificationTypes.EmailVerified;

      await FirebaseAuth.instance.signOut();
      return EmailVerificationTypes.NotEmailVerified;
    } catch (e) {
      print('Email LogIn Error: ${e.toString()}');
      return EmailVerificationTypes.Error;
    }
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Email Logout Error: ${e.toString()}');
    }
  }
}
