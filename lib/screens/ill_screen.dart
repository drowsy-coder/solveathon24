import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';


class IllScreen extends StatefulWidget {
  const IllScreen({super.key});

  @override
  State<IllScreen> createState() => _IllScreenState();
}

Future<int> checkSent() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  final docSnap = await FirebaseFirestore.instance
      .collection('iamill')
      .doc(currentUser!.uid)
      .get();
  if (docSnap.exists && docSnap['isIll'] == 0) {
    return 0;
  }
  if (docSnap.exists && docSnap['isIll'] == 1) {
    return 1;
  }
  if (docSnap.exists && docSnap['isIll'] == -1) {
    return -1;
  } else {
    return -1;
  }
}

void illData() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int day = DateTime.now().day;
  String date = '$day-$month-$year';
  await FirebaseFirestore.instance
      .collection('iamill')
      .doc(currentUser!.uid)
      .set({
    'isIll': 0,
    'useremail': currentUser.email,
    'data': date,
  });
}

class _IllScreenState extends State<IllScreen> {
  Future<int>? isSent;
  @override
  void initState() {
    super.initState();
    setState(() {
      isSent = checkSent();
    });
    // isSent = checkSent();
  }

  @override
  Widget build(BuildContext context) {

    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Illness'),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        onRefresh: () async {
          setState(() {
            isSent = checkSent();
          });
        },

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              color: Color(0xff282828),
              margin: EdgeInsets.all(14),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  '$day/$month/$year',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            FutureBuilder<int>(
              future: isSent,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          const CircularProgressIndicator()); // Show a loading spinner while waiting
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Show error message if something went wrong
                } else {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: snapshot.data! == -1
                        ?
                        // If isSent is false, show the button
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 300,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  illData();
                                  setState(() {
                                    isSent = checkSent();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffa688fa),
                                  // Theme.of(context).priaryColor,
                                  minimumSize: const Size.fromHeight(30),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  shape: CircleBorder(),
                                ),
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  child: Center(
                                    child: const Text(
                                      'Emergency Illness',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : snapshot.data == 0
                            ? // If isSent is true, show the text
                            const Align(
                                alignment: Alignment.center,
                                child: Card(
                                  color: Color(0xff282828),
                                  margin: EdgeInsets.all(14),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child:
                                        Text('Your Situation is under review.'),
                                  ),
                                ),
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/health-svgrepo-com.png',
                                    ),
                                    const Card(
                                      color: Color(0xff282828),
                                      margin: EdgeInsets.all(14),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                            'Your Situtation has been accepted.'),
                                      ),
                                    ),
                                    Card(
                                      color: Color(0xff282828),
                                      margin: EdgeInsets.all(14),
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'You are eligible to get food in your room till ${day + 3}/$month/$year.',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                  );
                }
              },
            ),
          ],

        ),
      ),
    );
  }
}
