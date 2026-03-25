import 'package:driving_test_prep/features/driving_centers/screens/center_list_screen.dart';
import 'package:driving_test_prep/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    const CenterListScreen(),
    const Center(child: Text('Thông tin', style: TextStyle(fontSize: 20))),
  ];

  final List<IconData> _icons = const [
    Icons.menu_book,
    Icons.directions_car,
    Icons.info,
  ];

  final List<String> _labels = const [
    'Ôn thi GPLX',
    'Đào tạo lái xe',
    'Thông tin',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == currentIndex) return;
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = screens.length;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 2.0, top: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(itemCount, (index) {
                  final bool isSelected = index == currentIndex;

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onItemTapped(index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          width: isSelected ? 40 : 36,
                          height: isSelected ? 40 : 36,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.35),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Icon(
                            _icons[index],
                            size: 22,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOutCubic,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected ? Colors.blue : Colors.grey,
                          ),
                          child: Text(_labels[index]),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
