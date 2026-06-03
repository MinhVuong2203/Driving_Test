import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:driving_test_prep/features/driving_centers/screens/center_list_screen.dart';
import 'package:driving_test_prep/features/home/screens/home_screen.dart';
import 'package:driving_test_prep/features/profile/screens/info_screen.dart';
import 'package:driving_test_prep/features/recognition_ai/screens/recognition_home_screen.dart';
import 'package:driving_test_prep/shared/widgets/account_status_gate.dart';
import '../../features/social_network/screens/email_login_screen.dart';
import '../../features/social_network/screens/home_feed_screen.dart';
import '../screen/login_view.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 2;
  final Set<int> _openedTabs = {2};

  List<Widget> get screens => [
    _openedTabs.contains(0)
        ? const CenterListScreen()
        : const SizedBox.shrink(),

    _openedTabs.contains(1)
        ? AccountStatusGate(
            featureName: 'Nhận dạng biển báo',
            unauthenticatedChild: LoginScreen(
              onLoginSuccess: (_) async {
                if (!mounted) return;
                setState(
                  () {},
                ); // login xong -> rebuild để hiện RecognitionHomeScreen
              },
              fallbackSuccessScreen: const SizedBox.shrink(),
            ),
            child: RecognitionHomeScreen(onUpgradeVip: () => _onItemTapped(4)),
          )
        : const SizedBox.shrink(),

    HomeScreen(onUpgradeVip: () => _onItemTapped(4)),

    _openedTabs.contains(3)
        ? const AccountStatusGate(
            featureName: 'Diễn đàn',
            unauthenticatedChild: EmailLoginScreen(),
            child: HomeFeedScreen(),
          )
        : const SizedBox.shrink(),
    _openedTabs.contains(4) ? const InfoScreen() : const SizedBox.shrink(),
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
    'Diễn đàn',
    'Thông tin',
  ];

  Future<void> _onItemTapped(int index) async {
    if (index == currentIndex) return;
    setState(() {
      _openedTabs.add(index);
      currentIndex = index;
    });
  }

  Widget _buildItem(int index) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70, //  FIX CỐ ĐỊNH WIDTH (QUAN TRỌNG)
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.1 : 1.0,
              child: Icon(
                _icons[index],
                size: 22,
                color: isSelected
                    ? Colors.blue
                    : Theme.of(context).brightness == Brightness.dark
                    ? AppColors.iconDark
                    : AppColors.iconLight,
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
      body: IndexedStack(index: currentIndex, children: screens),

      floatingActionButton: SizedBox(
        width: 44,
        height: 44,
        child: FloatingActionButton(
          onPressed: () => _onItemTapped(2),
          backgroundColor: Colors.blue,
          elevation: 6,
          child: const Icon(Icons.menu_book, color: AppColors.iconDark),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: SafeArea(
        bottom: false,
        child: BottomAppBar(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.navigationBarDark
              : AppColors.navigationBarLight,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          elevation: 10,
          height: 52,
          padding: EdgeInsets.only(top: 12),
          child: OverflowBox(
            maxHeight: double.infinity,
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildItem(0),
                  _buildItem(1),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 14,
                      left: 10,
                      right: 10,
                    ),
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
