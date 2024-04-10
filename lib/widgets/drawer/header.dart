// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:solveathon/widgets/drawer/info_row.dart';

class CustomDrawerHeader extends StatefulWidget {
  // ignore: use_super_parameters
  const CustomDrawerHeader({Key? key}) : super(key: key);

  @override
  _CustomDrawerHeaderState createState() => _CustomDrawerHeaderState();
}

class _CustomDrawerHeaderState extends State<CustomDrawerHeader> {
  late Future<Map<String, dynamic>?> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = getUserData();
  }

  Future<Map<String, dynamic>?> getUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.email != null) {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('userData')
          .where('useremail', isEqualTo: currentUser.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('Error fetching user data'));
        }

        final userData = snapshot.data!;
        print(
            "thisssssssssssssssssssssssssssssssssssssss" + userData['userpfp']);
        final String avatarImage = userData['userpfp'] ??
            'https://lh3.googleusercontent.com/a/ACg8ocK_ETy3mYoXUB5oH_jrHCXd6OyNX6vJPTd2hY_y87dJ4xLvwBk=s96-c"';
        final String userName = userData['user'] ?? 'N/A';
        final String regNo = userData['regNum'] ?? 'N/A';

        return Container(
          padding: const EdgeInsets.only(
              top: 48.0, bottom: 16.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(avatarImage),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(height: 10),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    userName,
                    textStyle: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    speed: const Duration(milliseconds: 70),
                  ),
                ],
                totalRepeatCount: 1,
              ),
              const SizedBox(height: 10),
              InfoRow(
                icon: Icons.credit_card,
                label: 'Reg. No',
                value: regNo,
                iconColor: Colors.amber.shade400,
              ),
              InfoRow(
                icon: Icons.meeting_room,
                label: 'Room Number',
                value: 'A-519',
                iconColor: Colors.lightGreenAccent.shade400,
              ),
              InfoRow(
                icon: Icons.restaurant,
                label: 'Mess',
                value: 'Veg - CRCL',
                iconColor: Colors.blue.shade400,
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.white54, thickness: 1.0),
            ],
          ),
        );
      },
    );
  }
}
