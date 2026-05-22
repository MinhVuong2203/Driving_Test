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
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final mutedColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final themeColor = _themeColor(package.colorTheme);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: themeColor, width: 1.4),
          boxShadow: [
            BoxShadow(
              color: themeColor.withOpacity(0.16),
              blurRadius: 18,
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
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    color: themeColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    package.vipName,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Icon(Icons.swipe_rounded, color: themeColor, size: 22),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatPrice(package.vipPrice),
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (package.priceInline != null &&
                    package.priceInline! > package.vipPrice) ...[
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
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.schedule_rounded, color: themeColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  package.durationLabel,
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...package.descript
                .take(4)
                .map(
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
            SizedBox(height: 14),
            CarAnimatedButton(
              text: isLoading ? 'Đang tạo thanh toán...' : 'Thanh toán',
              onPressed: onPay,
              isEnabled: !isLoading,
              primaryColor: themeColor,
              secondaryColor: _sameToneGradientEnd(themeColor),
              width: double.infinity,
              height: 50,
              borderRadius: 8,
              icon: const Icon(
                Icons.payments_rounded,
                color: AppColors.white,
                size: 20,
              ),
              textStyle: const TextStyle(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
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
        return const Color.fromARGB(255, 119, 9, 245);
      case 'gold':
        return AppColors.warning;
      case 'platinum':
        return const Color.fromARGB(255, 176, 2, 199);
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      default:
        return AppColors.primary;
    }
  }

  static Color _sameToneGradientEnd(Color color) {
    return Color.lerp(color, Colors.black, 0.18) ?? color;
  }
}
