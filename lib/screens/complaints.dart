// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class ComplaintFormScreen extends StatelessWidget {
  const ComplaintFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: const Text('Add Complaint'),
          elevation: 0,
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: ComplaintsForm(),
          ),
        ),
      ),
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

    await db.collection('Complaints').add({
      "Category": category,
      "Description": description,
      "Status": 1,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Complaint submitted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Submit a New Complaint',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue[300],
          ),
        ),
        const SizedBox(height: 20),
        DropDownTextField(
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
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: submitComplaint,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[300],
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Submit Complaint',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
