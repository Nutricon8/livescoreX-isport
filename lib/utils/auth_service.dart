import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /*
    final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    clientId:
        "363201426829-7u2a31b739178vf2vsd0sudr67372b9f.apps.googleusercontent.com", // Add your Web Client ID
  );

  Future<User?> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled sign-in

      print("Google User: ${googleUser.displayName}");

      // Authenticate the user
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print("Error: Missing Google authentication tokens.");
        return null;
      }

      print("Access Token: ${googleAuth.accessToken}");
      print("ID Token: ${googleAuth.idToken}");

      // Get Auth Credentials
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Store user info in Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'fullName': googleUser.displayName,
        'email': googleUser.email,
        'profilePic': googleUser.photoUrl,
      }, SetOptions(merge: true));

      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }*/

  // Sign up with Email & Password
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store user details in Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  // Sign in with Email & Password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
