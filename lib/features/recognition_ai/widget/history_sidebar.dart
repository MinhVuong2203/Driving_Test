import 'dart:io';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../core/database/app_database.dart';

class HistorySidebar extends StatelessWidget {
  final List<RecognitionHistoryData> historyList;
  final RecognitionHistoryData? selectedHistory;
  final Function(RecognitionHistoryData) onHistoryTap;
  final VoidCallback onDeleteAll;

  const HistorySidebar({
    super.key,
    required this.historyList,
    this.selectedHistory,
    required this.onHistoryTap,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 286, // 👈 FIX HEIGHT giống ảnh
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: historyList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  return _buildHistoryItem(historyList[index], index);
                },
              ),
            ),
          ),
          if (historyList.isNotEmpty)
            IconButton(
              onPressed: onDeleteAll,
              icon: const Icon(Icons.delete, color: Colors.red, size: 26),
              constraints: const BoxConstraints(),
            )
        ]
      ),
    );
  }


  Widget _buildHistoryItem(RecognitionHistoryData history, int index) {
    final isSelected = selectedHistory?.id == history.id;

    return GestureDetector(
      onTap: () => onHistoryTap(history),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF6B6B)
                : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFFFF6B6B).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Image
              AspectRatio(
                aspectRatio: 1,
                child: Image.file(
                  File(history.imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade800,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.white54,
                      ),
                    );
                  },
                ),
              ),

              // Overlay when selected
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFFF6B6B).withOpacity(0.3),
                          const Color(0xFFFFE66D).withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),

              // Check icon when selected
              if (isSelected)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),

              // Index number
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_outlined,
            size: 48,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'Chưa có\nlịch sử',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

}
