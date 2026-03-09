import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/driving_centers/screens/center_list_screen.dart';

class BottomNavBar extends StatefulWidget {

  final int index;

  const BottomNavBar({super.key, required this.index});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();

}

class _BottomNavBarState extends State<BottomNavBar> {

  late int currentIndex;

  final screens = [

    const Center(child: Text("Ôn luyện GPLX")),

    const CenterListScreen(),

    const Center(child: Text("Thông tin")),

  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index) {

          setState(() {
            currentIndex = index;
          });

          if (index == 0) context.go("/practice");
          if (index == 1) context.go("/centers");
          if (index == 2) context.go("/info");

        },

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