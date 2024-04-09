import 'package:flutter/material.dart';
import 'package:solveathon/cloth/clothitem.dart';

class Test2 extends StatefulWidget {
  const Test2({super.key});

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  final Map<String, int> clothCounts = {};
  final TextEditingController clothCountController = TextEditingController();
  bool submitted = false;
  String? count;

  final List<ClothItem> clothItems = [
    ClothItem(name: 'T-Shirt'),
    ClothItem(name: 'Shirt'),
    ClothItem(name: 'Jeans'),
    ClothItem(name: 'Shorts'),
    // Add more cloth items here
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xff1a222c),
        appBar: AppBar(
          backgroundColor: Color(0xff24303f),
          title: const Text('Today\'s Wash (or next wash)',
              style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Color(0xFF0C44A3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "Wash Date",
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            Container(height: 10),
                            Text(
                              "24/09/2021",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[200]),
                            ),
                            Container(
                              height: 200,
                              child: ListView.builder(
                                itemCount: clothItems.length,
                                itemBuilder: (context, index) {
                                  final clothItem = clothItems[index];
                                  return Container(
                                    // color: Color.fromARGB(255, 3, 65, 115),
                                    child: ClothItemWidget(
                                      clothItem: clothItem,
                                      onIncrement: () {
                                        setState(() {
                                          clothItem.count++;
                                        });
                                      },
                                      onDecrement: () {
                                        setState(() {
                                          if (clothItem.count > 0) {
                                            clothItem.count--;
                                          }
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      submitted == false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.transparent),
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    for (final clothItem in clothItems) {
                                      clothCounts[clothItem.name] =
                                          clothItem.count;
                                    }
                                    //!Send to backend here
                                    setState(() {
                                      submitted = true;
                                      count = clothCountController.text;
                                    });
                                  },
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
                submitted == true
                    ? Card(
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Color(0xFF0C44A3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Receive Date",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                  Text("25/09/2021",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white)),
                                  Text("Cloth Count",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white)),
                                  ...clothCounts.entries.map((entry) {
                                    return Text('${entry.key}: ${entry.value}',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white));
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
