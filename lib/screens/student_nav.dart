import 'package:flutter/material.dart';
import 'package:solveathon/screens/test.dart';
import 'package:solveathon/screens/test2.dart';
import 'package:solveathon/screens/test3.dart';
import 'package:solveathon/screens/test4.dart';

class StudentNav extends StatefulWidget {
  const StudentNav({super.key});

  @override
  State<StudentNav> createState() => _StudentNavState();
}

class _StudentNavState extends State<StudentNav> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = [
    const Face(),
    const Test2(),
    const Test3(),
    const Test4()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_laundry_service),
            label: 'Chhota Dhobi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Complaint',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Mess',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.deepPurple,
        type: BottomNavigationBarType.shifting,
        elevation: 20.0,
        iconSize: 30,
        showUnselectedLabels: false,
        selectedFontSize: 15,
        unselectedFontSize: 12,
        onTap: _onItemTapped,
      ),
    );
  }
}
