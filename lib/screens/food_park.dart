// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solveathon/login/login_method.dart';
import 'package:solveathon/login/login_ui.dart';

class FoodOrderingScreen extends StatefulWidget {
  const FoodOrderingScreen({super.key});

  @override
  _FoodOrderingScreenState createState() => _FoodOrderingScreenState();
}

class _FoodOrderingScreenState extends State<FoodOrderingScreen> {
  List<FoodItem> foodItems = [
    FoodItem(
      id: '1',
      name: 'Chicken Curry',
      subtitle: 'Delicious Indian gravy',
      category: 'Gravy',
      price: 59,
      imageUrl:
          'https://images.immediate.co.uk/production/volatile/sites/30/2021/02/butter-chicken-ac2ff98.jpg?quality=90&resize=440,400',
    ),
    FoodItem(
      id: '2',
      name: 'Chocolate Cake',
      subtitle: 'Rich and creamy',
      category: 'Dessert',
      price: 35,
      imageUrl:
          'https://sallysbakingaddiction.com/wp-content/uploads/2013/04/triple-chocolate-cake-4.jpg',
    ),
    FoodItem(
      id: '3',
      name: 'Spring Rolls',
      subtitle: 'Crispy and golden',
      category: 'Chinese',
      price: 29,
      imageUrl:
          'https://redhousespice.com/wp-content/uploads/2021/12/whole-spring-rolls-and-halved-ones-scaled.jpg',
    ),
  ];

  Map<String, int> selectedQuantities = {};
  String filter = 'All';

  @override
  Widget build(BuildContext context) {
    List<FoodItem> filteredItems = filter == 'All'
        ? foodItems
        : foodItems.where((item) => item.category == filter).toList();
    ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.grey[900]!],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Food Park'),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginPageUI(logic: LoginPageLogic())),
                );
              },
            ),
          ],
// Dark themed AppBar
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: Colors.grey.shade700, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  dropdownColor: Color(0xff282828),
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade900),
                    ),
                  ),
                  value: filter,
                  icon: Icon(Icons.arrow_drop_down,
                      color: theme.primaryColorLight), // Lighter icon color
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      color: theme
                          .primaryColorLight), // Lighter text color for readability
                  onChanged: (String? newValue) {
                    setState(() {
                      filter = newValue!;
                    });
                  },
                  items: <String>['All', 'Gravy', 'Dessert', 'Chinese']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return Card(
                    color: Color(0xff282828),
                    margin: const EdgeInsets.all(8),
                    elevation: 4,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 120,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    item.subtitle,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    '₹${item.price}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.remove,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      selectedQuantities.update(item.id,
                                          (value) => value > 0 ? value - 1 : 0,
                                          ifAbsent: () => 0);
                                    });
                                  },
                                ),
                                Text('${selectedQuantities[item.id] ?? 0}'),
                                IconButton(
                                  icon: const Icon(Icons.add,
                                      color: Color(0xffa688fa)),
                                  onPressed: () {
                                    setState(() {
                                      selectedQuantities.update(
                                          item.id, (value) => value + 1,
                                          ifAbsent: () => 1);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: submitOrder,
          backgroundColor: Color(0xffa688fa),
          child: const Icon(Icons.check),
        ),
      ),
    );
  }

  void submitOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final orderItems = selectedQuantities.entries.map((e) {
        final item = foodItems.firstWhere((item) => item.id == e.key);
        return {
          'id': item.id,
          'name': item.name,
          'quantity': e.value,
          'price': item.price,
          'totalPrice': item.price * e.value,
        };
      }).toList();

      final totalCost = orderItems.fold<double>(
          0.0,
          (previousValue, element) =>
              previousValue + (element['totalPrice'] as double));
      await FirebaseFirestore.instance.collection('foodpark').add({
        'userId': user.uid,
        'items': orderItems,
        'totalCost': totalCost,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Reset selections
      setState(() {
        selectedQuantities.clear();
      });

      // Show confirmation
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Order Submitted'),
          content: const Text('Your order has been submitted successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}

class FoodItem {
  final String id;
  final String name;
  final String subtitle;
  final String category;
  final double price;
  final String imageUrl;

  FoodItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.price,
    required this.imageUrl,
  });
}
