import 'package:driving_test_prep/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../features/driving_centers/screens/center_list_screen.dart';

class BottomNavBar extends StatefulWidget {

  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();

}

class _BottomNavBarState extends State<BottomNavBar> {

  int currentIndex = 0;

  final screens = [
    HomeScreen(),

    const CenterListScreen(),

    const Center(
      child: Text(
        "Thông tin",
        style: TextStyle(fontSize: 20),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index) {

          setState(() {

            currentIndex = index;

          });

        },

        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Ôn thi GPLX",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: "Đào tạo lái xe",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "Thông tin",
          ),

        ],

      ),

    );

  }

}