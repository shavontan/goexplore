import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

bool isVerified() {
  User user = FirebaseAuth.instance.currentUser as User;

  if (user.emailVerified) {
    return true;
  } else {
    print ("unverified email!!!!!!");
  }
  return false;
}

Future<bool> register(String email, String password) async {
  try{
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User user = firebaseAuth.currentUser as User;
    user.sendEmailVerification();
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
    return false;
  } catch (e) {
    print(e.toString());
    return false;
  }
}
