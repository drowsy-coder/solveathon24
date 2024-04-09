// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ClothItem {
  final String name;
  final String iconPath;
  int count;

  ClothItem({required this.name, required this.iconPath, this.count = 0});
}

class ClothCounterPage extends StatefulWidget {
  const ClothCounterPage({super.key});

  @override
  _ClothCounterPageState createState() => _ClothCounterPageState();
}

class _ClothCounterPageState extends State<ClothCounterPage> {
  final List<ClothItem> clothItems = [
    ClothItem(name: 'T-Shirt', iconPath: 'assets/4305443.png'),
    ClothItem(name: 'Socks', iconPath: 'assets/2161101.png'),
    ClothItem(name: 'Jeans', iconPath: 'assets/1176990.png'),
  ];

  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int day = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Laundry Day'),
        backgroundColor: Colors.transparent,
      ),
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
            children: [
              Card(
                margin: const EdgeInsets.all(12.0),
                color: const Color(0xff282828),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.meeting_room, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Text(
                            'Room Number: 101',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Date Row
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Colors.greenAccent),
                          const SizedBox(width: 10),
                          Text(
                            'Chhota Dhobi Date: $day/$month/$year',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: clothItems.length,
                  itemBuilder: (context, index) {
                    final item = clothItems[index];
                    return Card(
                      color: Color(0xff282828),
                      margin: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 13.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        leading: Image.asset(
                          item.iconPath,
                          width: 40,
                          color: Colors.white70,
                        ),
                        title: Text(item.name,
                            style: const TextStyle(color: Colors.white)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.redAccent),
                              onPressed: () => setState(() => item.count =
                                  item.count > 0 ? item.count - 1 : 0),
                            ),
                            Text('${item.count}',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Color(0xffa688fa)),
                              onPressed: () => setState(() => item.count++),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffa688fa),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    // Handle submit action
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Submission Successful'),
                          content: const Text(
                              'Your laundry count has been submitted.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Submit',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
