import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:driving_test_prep/features/driving_centers/screens/center_list_screen.dart';
import 'package:driving_test_prep/features/home/screens/home_screen.dart';
import 'package:driving_test_prep/features/recognition_ai/screens/recognition_home_screen.dart';
import '../../features/social_network/screens/email_login_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 2;

  final List<Widget> screens = [
    const CenterListScreen(),
    RecognitionHomeScreen(),
    HomeScreen(),
    EmailLoginScreen(),
    const Center(child: Text('Thông tin', style: TextStyle(fontSize: 20))),
  ];

  final List<IconData> _icons = const [
    Icons.directions_car,
    Icons.qr_code_scanner,
    Icons.menu_book,
    Icons.facebook,
    Icons.info,
  ];

  final List<String> _labels = const [
    'Đào tạo',
    'Quét',
    'Ôn thi',
    'Mạng xã hội',
    'Thông tin',
  ];

  void _onItemTapped(int index) {
    if (index == currentIndex) return;
    setState(() {
      currentIndex = index;
    });
  }

  Widget _buildItem(int index) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70, // 👈 FIX CỐ ĐỊNH WIDTH (QUAN TRỌNG)
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.2 : 1.0,
              child: Icon(
                _icons[index],
                color: isSelected ? Colors.blue : Theme.of(context).brightness == Brightness.dark ? AppColors.iconDark : AppColors.iconLight,
              ),
            ),

            const SizedBox(height: 2),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 1 : 0,
              child: Text(
                _labels[index],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      floatingActionButton: SizedBox(
        width: 44,
        height: 44,
        child: FloatingActionButton(
          onPressed: () => _onItemTapped(2),
          backgroundColor: Colors.blue,
          elevation: 6,
          child: const Icon(
              Icons.menu_book,
              size: 24,
              color: AppColors.iconDark,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 👇 Bottom bar có lõm
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        removeTop: true,
        child: BottomAppBar(
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.navigationBarDark : AppColors.navigationBarLight,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          elevation: 10,
          child: SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildItem(0),
                  _buildItem(1),
                  Padding(
                    padding: EdgeInsets.only(top: 8, left: 10, right: 10),
                    child: Text(
                      'Ôn luyện',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: currentIndex == 2 ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                  _buildItem(3),
                  _buildItem(4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}