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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Day'),
      ),
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  SizedBox(height: 16),
                  // Date Row
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.greenAccent),
                      SizedBox(width: 10),
                      Text(
                        'Chhota Dhobi Date: 24/09/2021',
                        style: TextStyle(
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
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
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
                          onPressed: () => setState(() =>
                              item.count = item.count > 0 ? item.count - 1 : 0),
                        ),
                        Text('${item.count}',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline,
                              color: Colors.greenAccent),
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
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                // Handle submit action
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Submission Successful'),
                      content:
                          const Text('Your laundry count has been submitted.'),
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
              child: const Text('Submit', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
