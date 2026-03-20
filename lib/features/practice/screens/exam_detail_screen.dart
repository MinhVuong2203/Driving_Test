import 'package:driving_test_prep/features/practice/widgets/info_row.dart';
import 'package:driving_test_prep/features/practice/widgets/start_button.dart';
import 'package:driving_test_prep/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ExamDetailScreen extends StatefulWidget {
  const ExamDetailScreen({super.key});

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen>{
  bool isChecked1 = true;
  bool isChecked2 = false;
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thi thử lý thuyết - hạng B',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              /// Box thông tin
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Số lượng câu hỏi', style: TextStyle(fontSize: 16),),
                        Text('30 câu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary))
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Thời gian làm bài', style: TextStyle(fontSize: 16),),
                        Text('20 phút', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary))
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Điểm đậu tối thiểu', style: TextStyle(fontSize: 16),),
                        Text('27/30 câu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary))
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'CHẾ ĐỘ CHẤM ĐIỂM BÀI THI',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked1 = true;
                          isChecked2 = false;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Chấm điểm sau khi nộp bài', style: TextStyle(fontSize: 16)),
                          Text(
                            isChecked1 ? '✔' : '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked1 = false;
                          isChecked2 = true;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Chấm điểm nhanh khi chọn đáp án', style: TextStyle(fontSize: 16)),
                          Text(
                            isChecked2 ? '✔' : '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),

              const Spacer(),

              StartButton(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bắt đầu làm bài')),
                  );
                },
              ),

              SizedBox(height: 20)

            ],
          ),
        ),
      );

  }
}
