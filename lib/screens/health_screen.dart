import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HealthCentreScreen extends StatefulWidget {
  const HealthCentreScreen({super.key});

  @override
  State<HealthCentreScreen> createState() => _HealthCentreScreenState();
}

class _HealthCentreScreenState extends State<HealthCentreScreen> {
  Future<List> fetchUserRegNumAndDocs() async {
    List userMeds = [];
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userEmail = currentUser.email;
      final userData = await FirebaseFirestore.instance
          .collection('userData')
          .where('useremail', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userData.docs.isNotEmpty) {
        final userRegNum = userData.docs.first.data()['regNum'];

        final docs = await FirebaseFirestore.instance
            .collection('doctor')
            .where('registrationId', isEqualTo: userRegNum)
            .get();

        for (var doc in docs.docs) {
          userMeds.add(doc.data());
        }
      }
    }
    return userMeds;
  }

  Future<List>? userMedsFuture;

  @override
  void initState() {
    super.initState();
    userMedsFuture = fetchUserRegNumAndDocs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Centre'),
      ),
      body: Center(
        child: FutureBuilder<List>(
          future: userMedsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return const Text('No data found',
                  style: TextStyle(color: Colors.white));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                DateFormat('yyyy-MM-dd').format(DateTime.parse(
                                    snapshot.data![index]['date'])),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.report_problem,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Problems: ${snapshot.data![index]['problems']}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            children: [
                              Icon(Icons.medical_services, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                "Medicines:",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 34),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List<Widget>.generate(
                                snapshot.data![index]['medicines'].length,
                                (i) => Text(
                                  snapshot.data![index]['medicines'][i],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
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
      ),
    );
  }
}
