import 'package:driving_test_prep/data/models/vip_package_model.dart';
import 'package:driving_test_prep/data/repository/vip_repository.dart';
import 'package:driving_test_prep/data/services/firebase/vip_firebase_service.dart';
import 'package:driving_test_prep/features/vip/widgets/vip_package_card.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:driving_test_prep/shared/widgets/car_animated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late final VipRepository _vipRepository;
  late Future<List<VipPackageModel>> _vipPackagesFuture;

  String? _selectedPackageId;
  int? _lastOrderCode;
  bool _isCreatingPayment = false;
  bool _isCheckingPayment = false;

  @override
  void initState() {
    super.initState();
    _vipRepository = VipRepository(VipFirebaseService());
    _vipPackagesFuture = _vipRepository.getActiveVipPackages();
  }

  Future<void> _refreshPackages() async {
    setState(() {
      _vipPackagesFuture = _vipRepository.getActiveVipPackages();
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

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Thông tin'),
        backgroundColor: isDark ? AppColors.darkAppBarBackground : AppColors.lightAppBarBackground,
        foregroundColor: isDark ? AppColors.darkAppBarText : AppColors.lightAppBarText,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPackages,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
          children: [
            _UserSummaryCard(
              user: user,
              textColor: textColor,
              mutedColor: mutedColor,
              isDark: isDark,
            ),
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
                  label: Text(_isCheckingPayment ? 'Đang kiểm tra' : 'Kiểm tra'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<VipPackageModel>>(
              future: _vipPackagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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

                final packages = snapshot.data ?? [];
                if (packages.isEmpty) {
                  return const _EmptyState();
                }

                final selectedId = _selectedPackageId ?? packages.first.id;

                return Column(
                  children: packages
                      .map(
                        (package) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: VipPackageCard(
                            package: package,
                            isSelected: package.id == selectedId,
                            isLoading: _isCreatingPayment && package.id == selectedId,
                            onTap: () {
                              setState(() => _selectedPackageId = package.id);
                            },
                            onPay: () => _pay(package),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _UserSummaryCard extends StatelessWidget {
  final User? user;
  final Color textColor;
  final Color mutedColor;
  final bool isDark;

  const _UserSummaryCard({
    required this.user,
    required this.textColor,
    required this.mutedColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: AppColors.primaryLight,
            backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child: user?.photoURL == null
                ? Icon(Icons.person_rounded, color: AppColors.primary, size: 30)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? 'Khách',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  user?.email ?? 'Đăng nhập để kích hoạt VIP sau thanh toán',
                  style: TextStyle(color: mutedColor, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 42),
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
      child: Center(
        child: Text('Chưa có gói VIP khả dụng.'),
      ),
    );
  }
}
