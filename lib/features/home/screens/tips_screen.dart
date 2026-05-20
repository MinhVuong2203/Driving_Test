import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      {
        'title': 'Mẹo thi lý thuyết - Nhận biết biển báo',
        'content': '1. Biển báo cấm (Viền đỏ, nền trắng): Cấm thực hiện.\n'
            '2. Biển báo nguy hiểm (Tam giác vàng, viền đỏ): Chú ý nguy hiểm phía trước.\n'
            '3. Biển hiệu lệnh (Tròn xanh): Bắt buộc phải thi hành.\n'
            '4. Biển chỉ dẫn (Vuông/Chữ nhật xanh): Hướng dẫn, chỉ dẫn đường.',
      },
      {
        'title': 'Mẹo thi lý thuyết - Sa hình',
        'content': '1. Xe ưu tiên: Chữa cháy > Quân sự > Công an > Cứu thương.\n'
            '2. Đường ưu tiên: Xe trên đường ưu tiên được đi trước.\n'
            '3. Tại ngã tư không có biển báo/đèn tín hiệu: Nhường đường cho xe đi đến từ bên phải.\n'
            '4. Hướng rẽ: Rẽ phải > Đi thẳng > Rẽ trái.',
      },
      {
        'title': 'Mẹo thi thực hành - Vòng số 8',
        'content': '1. Giữ ga đều, không nên tăng giảm ga đột ngột.\n'
            '2. Mắt nhìn xa về hướng đi, không nhìn chằm chằm vào bánh xe.\n'
            '3. Hơi nghiêng người theo xe khi vòng cua để giữ thăng bằng tốt hơn.',
      },
      {
        'title': 'Mẹo chung',
        'content': '1. Đọc kỹ câu hỏi, đặc biệt chú ý các từ "không được", "bắt buộc".\n'
            '2. Nếu có câu hỏi về tốc độ trong khu đông dân cư, xe máy là 40km/h.\n'
            '3. Đối với các đáp án có từ "tất cả các ý trên", cần đọc lại kỹ để chắc chắn.',
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mẹo thi GPLX'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              title: Text(
                tip['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    tip['content']!,
                    style: const TextStyle(height: 1.5, fontSize: 15),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
