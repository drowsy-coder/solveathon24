import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HealthCentreScreen extends StatefulWidget {
  const HealthCentreScreen({super.key});

  @override
  State<HealthCentreScreen> createState() => _HealthCentreScreenState();
}

class _HealthCentreScreenState extends State<HealthCentreScreen> {
  Future<List> fetchdocs() async {
    List userMeds = [];
    final docs = await FirebaseFirestore.instance.collection('doctor').get();
    for (var doc in docs.docs) {
      if (doc['registrationId'] == '22bce1182') {
        print(doc.data());
        userMeds.add(doc.data());
      }
    }
    return userMeds;
  }

  Future<List>? userMedsfuture;
  @override
  void initState() {
    userMedsfuture = fetchdocs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(userMeds[1]);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Health Centre'),
        ),
        body: Center(
          child: FutureBuilder<List>(
            future: userMedsfuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    child: Card(
                      color: Color(0xff282828),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(snapshot.data![index]['date']))}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Problems: ${snapshot.data![index]['problems']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Medicines:",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List<Widget>.generate(
                                snapshot.data![index]['medicines'].length,
                                (i) => Text(
                                  "${snapshot.data![index]['medicines'][i]}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
