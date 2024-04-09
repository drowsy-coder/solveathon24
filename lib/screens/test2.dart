import 'package:flutter/material.dart';

class Test2 extends StatefulWidget {
  const Test2({super.key});

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  final TextEditingController clothCountController = TextEditingController();
  bool submitted = false;
  String? count;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Today\'s Wash (or next wash)'),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                child: Card(
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          "Wash Date",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const Text("24/09/2021"),
                        TextField(
                          controller: clothCountController,
                          decoration: InputDecoration(
                            label: Text("Enter Cloth Count:"),
                          ),
                          enabled: !submitted,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Handle submit logic here
                            print('Cloth count: ${clothCountController.text}');
                            setState(() {
                              submitted = true;
                              count = clothCountController.text;
                            });
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              submitted == true
                  ? Card(
                      color: Colors.grey[300],
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "Receive Date",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Text("25/09/2021"),
                            Text(count!),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              // const Text(
              //   "Wash Date",
              //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              // ),
              // const Text("24/09/2021"),
              // Expanded(
              //   child: Container(),
              // ),
              // const Text(
              //   "Receive Date",
              //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              // ),
              // const Text("25/09/2021"),
              // Expanded(
              //   child: Container(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
