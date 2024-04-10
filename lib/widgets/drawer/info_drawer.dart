// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solveathon/login/login_method.dart';
import 'package:solveathon/login/login_ui.dart';
import 'package:solveathon/screens/health_screen.dart';
import 'package:solveathon/screens/ill_screen.dart';
import 'package:solveathon/screens/pdf_chat.dart';
import 'package:solveathon/widgets/drawer/header.dart';

class UserProfileDrawer extends StatefulWidget {
  const UserProfileDrawer({super.key});

  @override
  _UserProfileDrawerState createState() => _UserProfileDrawerState();
}

class _UserProfileDrawerState extends State<UserProfileDrawer> {
  late Future<Map<String, dynamic>?> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchUserData();
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('userData')
          .where('useremail', isEqualTo: user.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C2C2E),
              Color(0xFF1B1B1D),
            ],
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const CustomDrawerHeader(),
                      _buildOptionTile(
                          Icons.health_and_safety, 'Health Centre Record', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HealthCentreScreen()),
                        );
                      }),
                      _buildOptionTile(Icons.medication_outlined, 'I AM ILL',
                          () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const IllScreen()),
                        );
                      }),
                      _buildOptionTile(
                          Icons.chat_bubble_outline, 'Regulations ChatBOT',
                          () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatBotScreen()),
                        );
                      }),
                      _buildOptionTile(Icons.exit_to_app, 'Logout', () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginPageUI(logic: LoginPageLogic())),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
      tileColor: Colors.transparent,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      trailing: const Icon(Icons.chevron_right, color: Colors.white),
    );
  }
}
