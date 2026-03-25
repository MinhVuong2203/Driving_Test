import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../screens/gplx_type_screen.dart';

class GplxSelectorTile extends StatelessWidget {
  final String selectedGplx;
  final ValueChanged<String> onChanged;

  const GplxSelectorTile({
    super.key,
    required this.selectedGplx,
    required this.onChanged,
  });

  String get _displayName {
    const names = {
      'A1': 'Mô tô - A1',
      'A': 'Mô tô - A',
      'B1': 'Mô tô - B1',
      'B': 'Ô tô - B',
      'C1': 'Ô tô - C1',
      'C': 'Ô tô - C',
      'D1': 'Ô tô khách - D1',
      'D2': 'Ô tô khách - D2',
      'D': 'Ô tô khách - D',
    };
    return names[selectedGplx] ?? selectedGplx;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (_) => GplxTypeScreen(currentSelected: selectedGplx),
          ),
        );
        if (result != null) onChanged(result);
      },
      child: Container(
        color:Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'GPLX',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _displayName,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}