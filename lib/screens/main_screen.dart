import 'package:flutter/material.dart';
import 'package:quick/constant/colors.dart';
import 'package:quick/screens/add_new_screen.dart';
import 'package:quick/screens/Order_screen.dart';
import 'package:quick/screens/home_screen.dart';
import 'package:quick/screens/profile_screen.dart';
import 'package:quick/screens/Inventory.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //current pade index
  int _currentPageIndex = 0;
  int _refreshKey = 0;

  @override
  Widget build(BuildContext context) {
    //screens list
    final List<Widget> screens = [
      const HomeScreen(),
      InventoryScreen(key: ValueKey(_refreshKey)),
      AddNewScreen(
        onItemAdded: () {
          // Switch to inventory tab and refresh
          setState(() {
            _currentPageIndex = 1;
            _refreshKey++;
          });
        },
        onNavigateBack: () {
          // Navigate back to home tab
          setState(() {
            _currentPageIndex = 0;
          });
        },
      ),
      const OrderScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 253, 242, 242),
        selectedItemColor: buttonColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
            // Refresh inventory screen when navigating to it
            if (index == 1) {
              _refreshKey++;
            }
          });
        },

        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: buttonColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: backgroundColor, size: 24),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Orders',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: screens[_currentPageIndex],
    );
  }
}
