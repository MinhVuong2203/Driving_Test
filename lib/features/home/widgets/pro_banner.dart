import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProBanner extends StatelessWidget {
  const ProBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.cyan]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Phiên bản Pro\nLoại bỏ quảng cáo', style: TextStyle(fontSize: 14)),
          ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight
              ),
              child: const Text('Nâng cấp', style: TextStyle(fontSize: 18, color: AppColors.primary))
          )
        ],
      ),
    );
  }


}