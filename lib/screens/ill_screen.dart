import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        child: FutureBuilder<int>(
          future: isSent,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show a loading spinner while waiting
            } else if (snapshot.hasError) {
              return Text(
                  'Error: ${snapshot.error}'); // Show error message if something went wrong
            } else {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Container(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (snapshot.data! ==
                            -1) // If isSent is false, show the button
                          ElevatedButton(
                            onPressed: () {
                              // Handle button press
                              illData();
                              setState(() {
                                isSent = checkSent();
                              });
                            },
                            child: Text('Button'),
                          ),
                        if (snapshot.data ==
                            0) // If isSent is true, show the text
                          Text('Your illness is under reveiw.'),
                        if (snapshot.data == 1) Text('You are now illness.'),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
