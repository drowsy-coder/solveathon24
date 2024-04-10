// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class ComplaintFormScreen extends StatelessWidget {
  const ComplaintFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Add Complaint'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: const ComplaintsForm(),
    );
  }
}

class ComplaintsForm extends StatefulWidget {
  const ComplaintsForm({super.key});

  @override
  State<ComplaintsForm> createState() => _ComplaintsFormState();
}

class _ComplaintsFormState extends State<ComplaintsForm> {
  final TextEditingController _descriptionController = TextEditingController();
  final SingleValueDropDownController _categoryController =
      SingleValueDropDownController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void submitComplaint() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final String category = _categoryController.dropDownValue?.value ?? '';
    final String description = _descriptionController.text.trim();

    if (category.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;

    final DocumentReference ref =
        db.collection('Complaints').doc('22BCE1293_$category');
    Map<String, dynamic> data = {
      "Registration": "22BCE1293",
      "Room": "115",
      "Category": category,
      "description": description,
      "Status": 1,
      "Date": "$year-$month-$day",
    };
    await ref.set(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Complaint submitted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Stack(
    //   children: [
    //     Positioned.fill(
    //       child: Container(
    //         decoration: BoxDecoration(
    //           gradient: LinearGradient(
    //             begin: Alignment.topCenter,
    //             end: Alignment.bottomCenter,
    //             colors: [Colors.black, Colors.grey[900]!],
    //           ),
    //         ),
    //       ),
    //     ),
    return Column(
      children: [
        // const Padding(
        //   padding: EdgeInsets.all(8),
        //   child: Text(
        //     'Submit a New Complaint',
        //     style: TextStyle(
        //       fontSize: 24,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        const SizedBox(height: 12),
        Card(
          color: Color(0xff282828),
          margin: EdgeInsets.all(14),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                DropDownTextField(
                  controller: _categoryController,
                  clearOption: false,
                  textFieldDecoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  dropDownList: const [
                    DropDownValueModel(name: 'AC', value: 'AC'),
                    DropDownValueModel(name: 'Mosquito', value: 'Mosquito'),
                    DropDownValueModel(name: 'Wifi', value: 'Wifi'),
                    DropDownValueModel(name: 'Food', value: 'Food'),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              submitComplaint();
              FocusScope.of(context).unfocus();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffa688fa),
              // Theme.of(context).primaryColor,
              minimumSize: const Size.fromHeight(50),
              // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(12),
              // ),
            ),
            child: const Text(
              'Submit Complaint',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
    // ],
    // );
  }
}
