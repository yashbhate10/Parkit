import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String username, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save the username in Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "username": username,
        "email": email,
        "createdAt": DateTime.now(),
      });

      return userCredential.user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
