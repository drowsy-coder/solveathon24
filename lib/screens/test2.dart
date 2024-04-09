import 'package:flutter/material.dart';

class Test2 extends StatelessWidget {
  const Test2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Basic Flutter Screen'),
        ),
        body: const Center(
          child: Text('Hello, Flutter! 2'),
        ),
      ),
    );
  }
}
