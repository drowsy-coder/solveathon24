// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:solveathon/screens/student_nav.dart';

class LoginPageLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return Future.error('Sign-in cancelled by user');
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final RegExp regExp = RegExp(r'2[A-Za-z0-9]+');
        final String? regNum =
            regExp.firstMatch(user.displayName ?? '')?.group(0);
        String userName = user.displayName ?? 'N/A';
        if (regNum != null) {
          userName = userName.replaceFirst(' $regNum', '').trim();
        }

        await FirebaseFirestore.instance
            .collection('userData')
            .doc(user.uid)
            .set({
          'user': userName,
          'userpfp': user.photoURL ?? 'N/A',
          'useremail': user.email ?? 'N/A',
          'regNum': regNum ?? 'N/A',
        }, SetOptions(merge: true));
      }

      return userCredential;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to sign in with Google. ${e.toString()}'),
        ),
      );
      rethrow;
    }
  }

  Future<void> checkLoggedIn(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const StudentNav(),
        ),
      );
    }
  }
}
