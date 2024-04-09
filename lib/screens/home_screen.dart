import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:solveathon/screens/post_list_view.dart';
import 'package:solveathon/screens/test.dart';
import 'package:solveathon/widgets/drawer/info_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Stream<QuerySnapshot> fetchPostsStream() {
    return FirebaseFirestore.instance.collection('posts').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.face),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Face()),
              );
            },
          ),
        ],
      ),
      drawer: const UserProfileDrawer(),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: [Colors.black, Colors.grey[900]!],
          //       ),
          //     ),
          //   ),
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  color: Color(0xff282828),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/vit-logo-only.png',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(width: 20),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'H-TOP',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'For all Hostel needs!',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: PostsListView(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
