// import 'package:flutter/material.dart';

// class Test3 extends StatelessWidget {
//   const Test3({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Complaint Screen'),
//         ),
//         body: const Center(
//           child: Text('Hello, Flutter! 3'),
//         ),
//       ),
//     );
//   }
// }
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class Complaints extends StatelessWidget {
  const Complaints({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Add Complaint'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20), // Add spacing
                Container(
                  width: 380,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black, // Change background color
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ComplaintsForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ComplaintsForm extends StatefulWidget {
  const ComplaintsForm({super.key});

  @override
  _ComplaintsFormState createState() => _ComplaintsFormState();
}

class _ComplaintsFormState extends State<ComplaintsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _deScriptionController = TextEditingController();
  final TextEditingController _CategoryController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  late MultiValueDropDownController _cntMulti;

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    _cntMulti = MultiValueDropDownController();
    super.initState();
  }

  @override
  void dispose() {
    _cnt.dispose();
    _cntMulti.dispose();
    super.dispose();
  }

  bool _deScriptionFocused = false;
  bool _CategoryFocused = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<DropDownValueModel> categoryList = [
    const DropDownValueModel(name: 'AC', value: 'AC'),
    const DropDownValueModel(name: 'Mosquito', value: 'Mosquito'),
    const DropDownValueModel(name: 'Wifi', value: 'Wifi'),
    const DropDownValueModel(name: 'Food', value: 'Food'),
  ];
  void submitcomplaint() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

// Create a reference to a document
    final DocumentReference ref = db
        .collection('Complaints_saumya')
        .doc('22BCE1293${_CategoryController.text.trim()}');
    final DocumentSnapshot doc = await ref.get();
    if (doc.exists && (doc.data() as Map<String, dynamic>)['Status'] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complaint already made'),
        ),
      );
    } else {
      Map<String, dynamic> data = {
        "Registration": "22BCE1293",
        "Room": "115",
        "Category": _CategoryController.text.trim(),
        "deScription": _deScriptionController.text.trim(),
        "Status": 1,
      };
      await ref.set(data);
    }
  }

  // void _submitComplaint() async {
  //   if (_formKey.currentState!.validate()) {
  //     final User? user = FirebaseAuth.instance.currentUser;

  //     if (user != null) {
  //       final String userId = user.uid;
  //       final String Category = _CategoryController.text.trim();
  //       final String deScription = _deScriptionController.text.trim();

  //       try {
  //         // CollectionReference complaints =
  //         // FirebaseFirestore.instance.collection('complaints');
  //         Map<String, dynamic> data = {
  //           "userId": userId,
  //           "Category": Category,
  //           "deScription": deScription,
  //         };
  //         // await complaints.add(data);
  //         _deScriptionController.clear();
  //         _CategoryController.clear();
  //       } catch (error) {
  //         print('Error: $error');
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropDownTextField(
            textFieldDecoration: const InputDecoration(
              icon: Icon(
                Icons.category,
                color: Colors.blue,
              ),
            ),
            // controller: _cnt, // Use the SingleValueDropDownController
            clearOption: true,
            searchDecoration: const InputDecoration(
              hintText: 'Select a category',
            ),
            validator: (value) {
              if (value == null) {
                return 'Please select a category';
              } else {
                return null;
              }
            },
            dropDownItemCount: categoryList.length,
            dropDownList: categoryList,
            onChanged: (val) {
              _CategoryController.text = val?.value;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _deScriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: _deScriptionFocused ? 3 : 1,
                  color: Colors.green,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              filled: true,
              fillColor: Colors.grey[900],
              icon: const Icon(
                Icons.email,
                color: Colors.green,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter';
              }
              return null;
            },
            onTap: () {
              setState(() {
                _deScriptionFocused = true;
                _CategoryFocused = false;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: submitcomplaint,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.amberAccent),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
