import 'package:driving_test_prep/data/models/vip_package_model.dart';
import 'package:driving_test_prep/data/models/user_vip_model.dart';
import 'dart:io';
import 'package:driving_test_prep/data/repository/vip_repository.dart';
import 'package:driving_test_prep/data/services/external/app_update_service.dart';
import 'package:driving_test_prep/data/services/firebase/user_profile_api_service.dart';
import 'package:driving_test_prep/data/services/firebase/vip_firebase_service.dart';
import 'package:driving_test_prep/data/services/firebase/user_vip_service.dart';
import 'package:driving_test_prep/features/social_network/controller/signout.dart';
import 'package:driving_test_prep/features/vip/widgets/vip_package_card.dart';
import 'package:driving_test_prep/shared/screen/in_app_webview_screen.dart';
import 'package:driving_test_prep/shared/screen/login_view.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:driving_test_prep/shared/utils/constants/app_config.dart';
import 'package:driving_test_prep/shared/widgets/car_animated_button.dart';
import 'package:driving_test_prep/shared/widgets/app_update_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:driving_test_prep/features/profile/screens/feedback_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late final VipRepository _vipRepository;
  late final AppUpdateService _appUpdateService;
  late Future<List<VipPackageModel>> _vipPackagesFuture;
  late Future<UserVipModel?> _currentVipFuture;
  late Future<PackageInfo> _packageInfoFuture;

  String? _selectedPackageId;
  int _currentPackageIndex = 0;
  int? _lastOrderCode;
  bool _isCreatingPayment = false;
  bool _isCheckingPayment = false;
  bool _isCheckingAppVersion = false;
  bool _isUploadingAvatar = false;
  bool _isUpdatingDisplayName = false;
  bool _isSigningOut = false;
  String? _avatarUrl;
  String? _displayName;

  @override
  void initState() {
    super.initState();
    _vipRepository = VipRepository(VipFirebaseService());
    _appUpdateService = AppUpdateService();
    _vipPackagesFuture = _vipRepository.getActiveVipPackages();
    _currentVipFuture = UserVipService().getCurrentUserVip();
    _packageInfoFuture = PackageInfo.fromPlatform();
    _avatarUrl = FirebaseAuth.instance.currentUser?.photoURL;
    _displayName = FirebaseAuth.instance.currentUser?.displayName;
  }

  Future<void> _refreshPackages() async {
    setState(() {
      _vipPackagesFuture = _vipRepository.getActiveVipPackages();
      _currentVipFuture = UserVipService().getCurrentUserVip();
    });
  }

  Future<void> _pay(VipPackageModel package) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showMessage('Vui lòng đăng nhập trước khi thanh toán.');
      return;
    }

    setState(() => _isCreatingPayment = true);
    try {
      final payment = await _vipRepository.createPayOsPayment(
        userId: user.uid,
        packageId: package.id,
      );

      _lastOrderCode = payment.orderCode;
      final uri = Uri.parse(payment.checkoutUrl);
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened) {
        _showMessage('Không mở được trang thanh toán PayOS.');
      }
    } catch (e) {
      _showMessage('Tạo thanh toán thất bại: $e');
    } finally {
      if (mounted) {
        setState(() => _isCreatingPayment = false);
      }
    }
  }

  Future<void> _checkLastPayment() async {
    final orderCode = _lastOrderCode;
    if (orderCode == null) {
      _showMessage('Bạn chưa tạo thanh toán nào trong phiên này.');
      return;
    }

    setState(() => _isCheckingPayment = true);
    try {
      final paid = await _vipRepository.syncPayOsStatus(orderCode);
      if (paid && mounted) {
        setState(() {
          _currentVipFuture = UserVipService().getCurrentUserVip();
        });
      }
      _showMessage(
        paid
            ? 'Thanh toán thành công. Tài khoản đã được cập nhật VIP.'
            : 'Thanh toán chưa hoàn tất.',
      );
    } catch (e) {
      _showMessage('Không kiểm tra được thanh toán: $e');
    } finally {
      if (mounted) {
        setState(() => _isCheckingPayment = false);
      }
    }
  }

  Future<void> _openWebView({
    required String url,
    required String title,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      _showMessage('Liên kết không hợp lệ.');
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InAppWebViewScreen(initialUrl: url, title: title),
      ),
    );
  }

  Future<void> _shareDownloadApp() async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          title: 'Tải ứng dụng Kiến thức lái xe 600',
          subject: 'Tải ứng dụng Kiến thức lái xe 600',
          text:
              'Tải ứng dụng Kiến thức lái xe 600 để ôn thi, luyện đề và trải nghiệm các kỹ năng cần thiết khi tham giao giao thông:\n${AppConfig.downloadAppUrl}',
        ),
      );
    } catch (e) {
      _showMessage('Không chia sẻ được liên kết: $e');
    }
  }

  Future<void> _checkAppVersion() async {
    if (_isCheckingAppVersion) return;

    setState(() => _isCheckingAppVersion = true);
    try {
      final packageInfo = await _packageInfoFuture;
      final updateInfo = await _appUpdateService.checkForUpdate();

      if (!mounted) return;
      if (updateInfo == null) {
        _showMessage('Phiên bản mới nhất hiện tại ${packageInfo.version}');
        return;
      }

      await showAppUpdateDialog(
        context: context,
        service: _appUpdateService,
        updateInfo: updateInfo,
      );
    } catch (_) {
      _showMessage('Không kiểm tra được phiên bản. Vui lòng thử lại.');
    } finally {
      if (mounted) {
        setState(() => _isCheckingAppVersion = false);
      }
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showMessage('Vui lòng đăng nhập để đổi ảnh đại diện.');
      return;
    }

    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (pickedImage == null) return;

    setState(() => _isUploadingAvatar = true);
    try {
      final photoUrl = await UserProfileApiService(
        AppConfig.baseUrl,
      ).uploadAvatar(File(pickedImage.path));

      await user.updatePhotoURL(photoUrl);
      await user.reload();

      if (!mounted) return;
      setState(() => _avatarUrl = photoUrl);
      _showMessage('Đã cập nhật ảnh đại diện.');
    } catch (e) {
      _showMessage('Không đổi được ảnh đại diện: $e');
    } finally {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
      }
    }
  }

  Future<void> _showEditDisplayNameDialog() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showMessage('Vui lòng đăng nhập để đổi tên.');
      return;
    }

    final newDisplayName = await showDialog<String>(
      context: context,
      builder: (_) => _EditDisplayNameDialog(
        initialName: (_displayName ?? user.displayName ?? '').trim(),
      ),
    );

    if (newDisplayName == null) return;
    await _updateDisplayName(newDisplayName);
  }

  Future<void> _updateDisplayName(String displayName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showMessage('Vui lòng đăng nhập để đổi tên.');
      return;
    }

    final trimmedName = displayName.trim();
    if (trimmedName.isEmpty) {
      _showMessage('Tên hiển thị không được để trống.');
      return;
    }

    if (trimmedName == (_displayName ?? user.displayName ?? '').trim()) {
      return;
    }

    setState(() => _isUpdatingDisplayName = true);
    try {
      final updatedName = await UserProfileApiService(
        AppConfig.baseUrl,
      ).updateDisplayName(trimmedName);

      await user.updateDisplayName(updatedName);
      await user.reload();

      if (!mounted) return;
      setState(() => _displayName = updatedName);
      _showMessage('Đã cập nhật tên.');
    } catch (e) {
      _showMessage('Không đổi được tên: $e');
    } finally {
      if (mounted) {
        setState(() => _isUpdatingDisplayName = false);
      }
    }
  }

  Future<void> _handleSignOut() async {
    final confirmed = await _confirmSignOut();
    if (!mounted || !confirmed) return;

    await SignOutController.signOut(
      context: context,
      setSigningOut: (value) {
        if (mounted) setState(() => _isSigningOut = value);
      },
      isMounted: () => mounted,
    );

    if (!mounted) return;
    if (FirebaseAuth.instance.currentUser != null) return;

    setState(() {
      _avatarUrl = null;
      _displayName = null;
      _currentVipFuture = Future<UserVipModel?>.value(null);
    });
  }

  Future<bool> _confirmSignOut() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc muốn đăng xuất khỏi tài khoản này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Hủy'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );

    return result == true;
  }

  Future<void> _openLoginScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (routeContext) {
          return LoginScreen(
            fallbackSuccessScreen: const SizedBox.shrink(),
            onLoginSuccess: (loggedInUser) async {
              if (Navigator.of(routeContext).canPop()) {
                Navigator.of(routeContext).pop();
              }
            },
          );
        },
      ),
    );

    final user = FirebaseAuth.instance.currentUser;
    if (!mounted || user == null) return;

    setState(() {
      _avatarUrl = user.photoURL;
      _displayName = user.displayName;
      _currentVipFuture = UserVipService().getCurrentUserVip();
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  List<VipPackageModel> _filterPackagesForCurrentVip(
    List<VipPackageModel> packages,
    UserVipModel? currentVip,
  ) {
    if (currentVip == null ||
        !currentVip.isActive ||
        currentVip.vipId.isEmpty) {
      return packages;
    }

    final currentPackage = _findCurrentPackage(packages, currentVip.vipId);
    if (currentPackage == null) return packages;

    final currentDays = _packageDays(currentPackage);

    return packages.where((package) {
      final packageDays = _packageDays(package);

      if (packageDays < currentDays) return false;

      if (packageDays == currentDays &&
          package.vipPrice > currentPackage.vipPrice) {
        return false;
      }

      return true;
    }).toList();
  }

  VipPackageModel? _findCurrentPackage(
    List<VipPackageModel> packages,
    String vipId,
  ) {
    for (final package in packages) {
      if (package.id == vipId) return package;
    }

    return null;
  }

  int _packageDays(VipPackageModel package) {
    if (package.isPeriod) return 1 << 30;
    return package.vipTime ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final mutedColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Thông tin'),
        centerTitle: true,
        backgroundColor: isDark
            ? AppColors.darkAppBarBackground
            : AppColors.lightAppBarBackground,
        foregroundColor: isDark
            ? AppColors.darkAppBarText
            : AppColors.lightAppBarText,
        elevation: 0,
        actions: user == null
            ? null
            : [
                IconButton(
                  onPressed: _isSigningOut ? null : _handleSignOut,
                  tooltip: 'Đăng xuất',
                  icon: _isSigningOut
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout_rounded),
                ),
              ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPackages,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              children: [
                FutureBuilder<UserVipModel?>(
                  future: _currentVipFuture,
                  builder: (context, snapshot) {
                    return _UserSummaryCard(
                      user: user,
                      avatarUrl: user == null
                          ? null
                          : _avatarUrl ?? user.photoURL,
                      displayName: user == null
                          ? null
                          : _displayName ?? user.displayName,
                      vip: snapshot.data,
                      textColor: textColor,
                      mutedColor: mutedColor,
                      isDark: isDark,
                      isUploadingAvatar: _isUploadingAvatar,
                      isUpdatingDisplayName: _isUpdatingDisplayName,
                      onAvatarTap: user == null || _isUploadingAvatar
                          ? null
                          : _pickAndUploadAvatar,
                      onEditDisplayNameTap:
                          user == null || _isUpdatingDisplayName
                          ? null
                          : _showEditDisplayNameDialog,
                    );
                  },
                ),
                if (user == null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: _openLoginScreen,
                      icon: const Icon(Icons.login_rounded),
                      label: const Text('Đăng nhập'),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Gói VIP',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _isCheckingPayment ? null : _checkLastPayment,
                      icon: const Icon(Icons.sync_rounded, size: 18),
                      label: Text(
                        _isCheckingPayment ? 'Đang kiểm tra' : 'Kiểm tra',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder<UserVipModel?>(
                  future: _currentVipFuture,
                  builder: (context, vipSnapshot) {
                    return FutureBuilder<List<VipPackageModel>>(
                      future: _vipPackagesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 56),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (snapshot.hasError) {
                          return _ErrorState(
                            message: 'Không tải được gói VIP.',
                            onRetry: _refreshPackages,
                          );
                        }

                        final packages = _filterPackagesForCurrentVip(
                          snapshot.data ?? [],
                          vipSnapshot.data,
                        );
                        if (packages.isEmpty) {
                          return const _EmptyState();
                        }

                        final activeIndex = _currentPackageIndex.clamp(
                          0,
                          packages.length - 1,
                        );

                        final pagerHeight = _vipPackagePagerHeight(context);

                        return Column(
                          children: [
                            SizedBox(
                              height: pagerHeight,
                              child: PageView.builder(
                                itemCount: packages.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPackageIndex = index;
                                    _selectedPackageId = packages[index].id;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  final package = packages[index];

                                  return VipPackageCard(
                                    package: package,
                                    isSelected: true,
                                    isLoading:
                                        _isCreatingPayment &&
                                        (_selectedPackageId == null
                                            ? index == activeIndex
                                            : _selectedPackageId == package.id),
                                    onTap: () {
                                      setState(
                                        () => _selectedPackageId = package.id,
                                      );
                                    },
                                    onPay: () => _pay(package),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                packages.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: index == activeIndex ? 18 : 7,
                                  height: 7,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: index == activeIndex
                                        ? AppColors.primary
                                        : AppColors.lightBorder,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 18),
                _ProfileLinksCard(
                  isDark: isDark,
                  textColor: textColor,
                  mutedColor: mutedColor,
                  onTermsTap: () => _openWebView(
                    url: AppConfig.termsOfUseUrl,
                    title: 'Điều khoản sử dụng',
                  ),
                  onFeedbackTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FeedbackScreen()),
                    );
                  },
                  onContactTap: () => _openWebView(
                    url: AppConfig.developmentTeamUrl,
                    title: 'Liên hệ',
                  ),
                  onPrivacyTap: () => _openWebView(
                    url: AppConfig.privacyPolicyUrl,
                    title: 'Chính sách riêng tư',
                  ),
                ),
                const SizedBox(height: 18),
                _DownloadAppCard(
                  isDark: isDark,
                  textColor: textColor,
                  qrAssetPath: AppConfig.downloadQrAsset,
                  isCheckingVersion: _isCheckingAppVersion,
                  onCheckVersionTap: _checkAppVersion,
                  onShareTap: _shareDownloadApp,
                ),
              ],
            ),
            Positioned(
              right: 16,
              bottom: 10,
              child: SafeArea(
                top: false,
                child: _AppVersionLabel(
                  packageInfoFuture: _packageInfoFuture,
                  mutedColor: mutedColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double _vipPackagePagerHeight(BuildContext context) {
  final textScale = MediaQuery.textScalerOf(context).scale(1);
  final scaledExtra = (textScale - 1).clamp(0.0, 1.0) * 180;

  return 420 + scaledExtra;
}

class _ProfileLinksCard extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final Color mutedColor;
  final VoidCallback onTermsTap;
  final VoidCallback onFeedbackTap;
  final VoidCallback onContactTap;
  final VoidCallback onPrivacyTap;

  const _ProfileLinksCard({
    required this.isDark,
    required this.textColor,
    required this.mutedColor,
    required this.onTermsTap,
    required this.onFeedbackTap,
    required this.onContactTap,
    required this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          _ProfileLinkTile(
            icon: Icons.description_rounded,
            iconColor: AppColors.info,
            title: 'Điều khoản sử dụng',
            subtitle: 'Quy định khi sử dụng ứng dụng Driving Test',
            textColor: textColor,
            mutedColor: mutedColor,
            onTap: onTermsTap,
          ),
          _ProfileDivider(isDark: isDark),
          _ProfileLinkTile(
            icon: Icons.feedback_rounded,
            iconColor: AppColors.primary,
            title: 'Báo lỗi, gửi góp ý',
            subtitle: 'Gửi phản hồi hoặc báo cáo sự cố ứng dụng',
            textColor: textColor,
            mutedColor: mutedColor,
            onTap: onFeedbackTap,
          ),
          _ProfileDivider(isDark: isDark),
          _ProfileLinkTile(
            icon: Icons.support_agent_rounded,
            iconColor: AppColors.success,
            title: 'Liên hệ',
            subtitle: 'Thông tin đội ngũ phát triển và hỗ trợ',
            textColor: textColor,
            mutedColor: mutedColor,
            onTap: onContactTap,
          ),
          _ProfileDivider(isDark: isDark),
          _ProfileLinkTile(
            icon: Icons.privacy_tip_rounded,
            iconColor: AppColors.secondary,
            title: 'Chính sách riêng tư',
            subtitle: 'Cách ứng dụng thu thập và bảo vệ dữ liệu',
            textColor: textColor,
            mutedColor: mutedColor,
            onTap: onPrivacyTap,
          ),
        ],
      ),
    );
  }
}

class _ProfileLinkTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color textColor;
  final Color mutedColor;
  final VoidCallback onTap;

  const _ProfileLinkTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.textColor,
    required this.mutedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(color: mutedColor, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: mutedColor),
          ],
        ),
      ),
    );
  }
}

class _ProfileDivider extends StatelessWidget {
  final bool isDark;

  const _ProfileDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 66),
      child: Divider(
        height: 1,
        thickness: 1,
        color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
      ),
    );
  }
}

class _DownloadAppCard extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final String qrAssetPath;
  final bool isCheckingVersion;
  final VoidCallback onCheckVersionTap;
  final VoidCallback onShareTap;

  const _DownloadAppCard({
    required this.isDark,
    required this.textColor,
    required this.qrAssetPath,
    required this.isCheckingVersion,
    required this.onCheckVersionTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tải ứng dụng',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: SvgPicture.asset(
              qrAssetPath,
              width: double.infinity,
              height: 220,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isCheckingVersion ? null : onCheckVersionTap,
                  icon: isCheckingVersion
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.system_update_alt_rounded, size: 18),
                  label: Text(
                    isCheckingVersion ? 'Đang kiểm tra' : 'Kiểm tra phiên bản',
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onShareTap,
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text('Share'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppVersionLabel extends StatelessWidget {
  final Future<PackageInfo> packageInfoFuture;
  final Color mutedColor;

  const _AppVersionLabel({
    required this.packageInfoFuture,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: packageInfoFuture,
      builder: (context, snapshot) {
        final version = snapshot.data?.version;
        if (version == null || version.trim().isEmpty) {
          return const SizedBox.shrink();
        }

        return Text(
          'Phiên bản $version',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: mutedColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }
}

class _UserSummaryCard extends StatelessWidget {
  final User? user;
  final String? avatarUrl;
  final String? displayName;
  final UserVipModel? vip;
  final Color textColor;
  final Color mutedColor;
  final bool isDark;
  final bool isUploadingAvatar;
  final bool isUpdatingDisplayName;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onEditDisplayNameTap;

  const _UserSummaryCard({
    required this.user,
    required this.avatarUrl,
    required this.displayName,
    required this.vip,
    required this.textColor,
    required this.mutedColor,
    required this.isDark,
    required this.isUploadingAvatar,
    required this.isUpdatingDisplayName,
    required this.onAvatarTap,
    required this.onEditDisplayNameTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: SizedBox(
              width: 70,
              height: 70,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primaryLight,
                      backgroundImage:
                          avatarUrl != null && avatarUrl!.trim().isNotEmpty
                          ? NetworkImage(avatarUrl!)
                          : null,
                      child: avatarUrl == null || avatarUrl!.trim().isEmpty
                          ? Icon(
                              Icons.person_rounded,
                              color: AppColors.primary,
                              size: 30,
                            )
                          : null,
                    ),
                  ),
                  if (isUploadingAvatar)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        displayName?.trim().isNotEmpty == true
                            ? displayName!.trim()
                            : 'Khách',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 34,
                      height: 34,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onEditDisplayNameTap,
                        tooltip: 'Sửa tên',
                        icon: isUpdatingDisplayName
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                Icons.edit_rounded,
                                color: mutedColor,
                                size: 18,
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  user?.email ?? 'Đăng nhập để kích hoạt VIP sau thanh toán',
                  style: TextStyle(color: mutedColor, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                if (vip != null) ...[
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium_rounded,
                          color: AppColors.warning,
                          size: 18,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          vip!.name.isEmpty ? 'Gói VIP' : vip!.name,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          vip!.durationLabel,
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Expanded(
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [

                        //       const SizedBox(height: 2),

                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditDisplayNameDialog extends StatefulWidget {
  final String initialName;

  const _EditDisplayNameDialog({required this.initialName});

  @override
  State<_EditDisplayNameDialog> createState() => _EditDisplayNameDialogState();
}

class _EditDisplayNameDialogState extends State<_EditDisplayNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sửa tên'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 80,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          labelText: 'Tên hiển thị',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Lưu')),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.danger,
            size: 42,
          ),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          CarAnimatedButton(
            text: 'Tải lại',
            onPressed: onRetry,
            primaryColor: AppColors.primary,
            secondaryColor: AppColors.secondary,
            width: 170,
            height: 46,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 48),
      child: Center(child: Text('Chưa có gói VIP khả dụng.')),
    );
  }
}
