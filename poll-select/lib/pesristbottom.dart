import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pollselect/create_poll.dart';
import 'package:pollselect/home_page.dart';
import 'package:pollselect/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistentBottomNavBar extends StatefulWidget {
  const PersistentBottomNavBar({super.key});

  @override
  PersistentBottomNavBarState createState() => PersistentBottomNavBarState();
}

class PersistentBottomNavBarState extends State<PersistentBottomNavBar> {
  int _selectedIndex = 0;

  // List of pages to display in the IndexedStack
  final List<Widget> _pages = [
    const HomePage(),
    const QuestionForm(),
    const Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex(); // Load the saved index when the app starts
  }

  // Load the selected index from SharedPreferences
  Future<void> _loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex =
          prefs.getInt('selectedIndex') ?? 0; // Default to 0 if not found
    });
  }

  // Function to handle tap on BottomNavigationBar
  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'selectedIndex', _selectedIndex); // Save the selected index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false, // Removes default back button
        title: Text(
          'Polling App',
          style: GoogleFonts.dancingScript(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Poll',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PersistentBottomNavBar(),
  ));
}
