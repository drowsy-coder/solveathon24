import 'package:flutter/material.dart';
import 'package:solveathon/screens/dhobi.dart';
import 'package:solveathon/screens/home_screen.dart';
import 'package:solveathon/screens/pdf_chat.dart';
import 'package:solveathon/screens/test.dart';
import 'package:solveathon/screens/complaints.dart';
import 'package:solveathon/screens/food_park.dart';

class StudentNav extends StatefulWidget {
  const StudentNav({super.key});

  @override
  State<StudentNav> createState() => _StudentNavState();
}

class _StudentNavState extends State<StudentNav> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = [
    HomeScreen(),
    const ClothCounterPage(),
    const ComplaintFormScreen(),
    const FoodOrderingScreen()
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
