import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:driving_test_prep/shared/widgets/app_walkthrough_overlay.dart';
import 'package:flutter/material.dart';
import 'package:driving_test_prep/features/driving_centers/screens/center_list_screen.dart';
import 'package:driving_test_prep/features/home/screens/home_screen.dart';
import 'package:driving_test_prep/features/profile/screens/info_screen.dart';
import 'package:driving_test_prep/features/recognition_ai/screens/recognition_home_screen.dart';
import 'package:driving_test_prep/shared/widgets/account_status_gate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/social_network/screens/email_login_screen.dart';
import '../../features/social_network/screens/home_feed_screen.dart';
import '../screen/login_view.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  static const _walkthroughSeenKey = 'has_seen_app_walkthrough_v3';

  int currentIndex = 2;
  final Set<int> _openedTabs = {2};
  bool _showWalkthrough = false;
  int _walkthroughIndex = 0;

  final List<AppWalkthroughStep> _walkthroughSteps = const [
    AppWalkthroughStep(
      title: 'Trung tâm đào tạo',
      description:
          'Trung tâm đào tạo uy tín khắp cả nước và bắt đầu lộ trình chinh phục GPLX.',
      assetPath: 'assets/icons/walkthrough-dao-tao.svg',
      navSlot: 0,
    ),
    AppWalkthroughStep(
      title: 'Ôn luyện mỗi ngày',
      description:
          'Làm đề, học câu sai và theo dõi tiến độ để nắm chắc lý thuyết trước kỳ thi.',
      assetPath: 'assets/icons/walkthrough-on-luyen.svg',
      navSlot: 2,
    ),
    AppWalkthroughStep(
      title: 'AI nhận diện biển báo',
      description:
          'Chụp hoặc chọn ảnh biển báo để AI phân tích và gợi ý ý nghĩa nhanh chóng.',
      assetPath: 'assets/icons/walkthrough-quet-ma.svg',
      navSlot: 1,
    ),
    AppWalkthroughStep(
      title: 'Mạng xã hội',
      description:
          'Đặt câu hỏi, chia sẻ kinh nghiệm và học cùng cộng đồng người thi GPLX.',
      assetPath: 'assets/icons/walkthrough-mang-xa-hoi.svg',
      navSlot: 3,
    ),
    AppWalkthroughStep(
      title: 'Thông tin cá nhân',
      description:
          'Quản lý hồ sơ, trạng thái tài khoản và các thông tin cá nhân của bạn.',
      icon: Icons.person_rounded,
      navSlot: 4,
    ),
    AppWalkthroughStep(
      title: 'Chọn hạng GPLX',
      description:
          'Vào cài đặt để chọn hạng GPLX phù hợp, app sẽ điều chỉnh nội dung ôn luyện theo lựa chọn của bạn.',
      icon: Icons.settings_rounded,
      target: AppWalkthroughTarget.settingsButton,
    ),
    AppWalkthroughStep(
      title: 'Chế độ sáng/tối',
      description:
          'Đổi nhanh giao diện sáng hoặc tối để học thoải mái hơn trong mọi điều kiện ánh sáng.',
      icon: Icons.light_mode_rounded,
      target: AppWalkthroughTarget.themeButton,
    ),
  ];

  @override
  void initState() {
    super.initState();
    print('AppWalkthrough: BottomNavBar initState');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWalkthroughState();
    });
  }

  Future<void> _loadWalkthroughState() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool(_walkthroughSeenKey) ?? false;
    print('AppWalkthrough: $_walkthroughSeenKey hasSeen=$hasSeen');
    if (!mounted || hasSeen) return;

    setState(() {
      currentIndex = 2;
      _openedTabs.add(2);
      _showWalkthrough = true;
      _walkthroughIndex = 0;
    });
    print('AppWalkthrough: shown');
  }

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
    Icons.comment_rounded,
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
    if (_showWalkthrough) return;
    if (index == currentIndex) return;
    setState(() {
      _openedTabs.add(index);
      currentIndex = index;
    });
  }

  Future<void> _completeWalkthrough() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_walkthroughSeenKey, true);
    if (!mounted) return;

    setState(() {
      _showWalkthrough = false;
      _walkthroughIndex = 0;
      currentIndex = 2;
      _openedTabs.add(2);
    });
  }

  void _goToNextWalkthroughStep() {
    if (_walkthroughIndex == _walkthroughSteps.length - 1) {
      _completeWalkthrough();
      return;
    }

    setState(() {
      _walkthroughIndex++;
      currentIndex = 2;
      _openedTabs.add(2);
    });
  }

  void _goToPreviousWalkthroughStep() {
    if (_walkthroughIndex == 0) return;

    setState(() {
      _walkthroughIndex--;
      currentIndex = 2;
      _openedTabs.add(2);
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
    return Stack(
      children: [
        Scaffold(
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
        ),
        if (_showWalkthrough)
          Positioned.fill(
            child: AppWalkthroughOverlay(
              steps: _walkthroughSteps,
              currentStep: _walkthroughIndex,
              onNext: _goToNextWalkthroughStep,
              onBack: _goToPreviousWalkthroughStep,
              onSkip: _completeWalkthrough,
            ),
          ),
      ],
    );
  }
}
