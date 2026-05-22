import 'package:driving_test_prep/data/models/vip_package_model.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:driving_test_prep/shared/widgets/car_animated_button.dart';
import 'package:flutter/material.dart';

class VipPackageCard extends StatelessWidget {
  final VipPackageModel package;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onPay;

  const VipPackageCard({
    super.key,
    required this.package,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final themeColor = _themeColor(package.colorTheme);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? themeColor : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? themeColor.withOpacity(0.16) : AppColors.lightShadow,
              blurRadius: isSelected ? 18 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.workspace_premium_rounded, color: themeColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.vipName,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        package.durationLabel,
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: themeColor, size: 22),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatPrice(package.vipPrice),
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (package.priceInline != null && package.priceInline! > package.vipPrice) ...[
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      _formatPrice(package.priceInline!),
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 13,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            ...package.descript.take(4).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_rounded, color: themeColor, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 13.5,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            if (isSelected) ...[
              const SizedBox(height: 8),
              CarAnimatedButton(
                text: isLoading ? 'Đang tạo thanh toán...' : 'Thanh toán PayOS',
                onPressed: onPay,
                isEnabled: !isLoading,
                primaryColor: themeColor,
                secondaryColor: AppColors.success,
                width: double.infinity,
                height: 50,
                borderRadius: 8,
                icon: const Icon(Icons.payments_rounded, color: AppColors.white, size: 20),
                textStyle: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _formatPrice(double price) {
    final value = price.round().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < value.length; i++) {
      final remaining = value.length - i;
      buffer.write(value[i]);
      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write('.');
      }
    }
    return '${buffer}đ';
  }

  static Color _themeColor(String theme) {
    switch (theme.toLowerCase()) {
      case 'purple':
        return AppColors.secondary;
      case 'gold':
        return AppColors.warning;
      case 'platinum':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }
}
