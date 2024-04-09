// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solveathon/face/authenticate_face/authenticate_face_view.dart';
import 'package:solveathon/face/common/utils/custom_snackbar.dart';
import 'package:solveathon/face/common/utils/screen_size_util.dart';
import 'package:solveathon/face/register_face/register_face_view.dart';

class Face extends StatefulWidget {
  const Face({super.key});

  @override
  _FaceState createState() => _FaceState();
}

class _FaceState extends State<Face> {
  bool isUserRegistered = false;

  @override
  void initState() {
    super.initState();
    checkIfUserIsRegistered();
  }

  void checkIfUserIsRegistered() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('face')
          .doc(currentUser.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          setState(() {
            isUserRegistered = true;
          });
        }
      }).catchError((error) {
        print('Error checking user registration: $error');
      });
    }
  }

  void initializeUtilContexts(BuildContext context) {
    ScreenSizeUtil.context = context;
    CustomSnackBar.context = context;
  }

  @override
  Widget build(BuildContext context) {
    initializeUtilContexts(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance System 🚨"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/Checklist Background Removed.png'),
            const SizedBox(height: 20),
            if (!isUserRegistered)
              CardButton(
                text: "Register User",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RegisterFaceView(),
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),
            CardButton(
              text: "Mark Attendance",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AuthenticateFaceView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CardButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // gradient: const LinearGradient(
            //   colors: [Colors.green, Colors.red],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
