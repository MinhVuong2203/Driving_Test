import 'package:flutter/material.dart';
import '../widgets/exam_version_section.dart';
import '../widgets/gplx_selector_tile.dart';
import '../widgets/scoring_mode_section.dart';
import '../widgets/vibration_toggle_tile.dart';
import '../widgets/delete_history_tile.dart';
import '../widgets/settings_section_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedGplx = 'B';
  bool _scoringAfterSubmit = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // PHIÊN BẢN BỘ ĐỀ THI
          const ExamVersionSection(),

          // HẠNG GPLX
          const SettingsSectionHeader(title: 'HẠNG GPLX'),
          GplxSelectorTile(
            selectedGplx: _selectedGplx,
            onChanged: (value) => setState(() => _selectedGplx = value),
          ),

          const SizedBox(height: 16),

          // CHẾ ĐỘ CHẤM ĐIỂM
          const SettingsSectionHeader(title: 'CHẾ ĐỘ CHẤM ĐIỂM BÀI THI'),
          ScoringModeSection(
            scoringAfterSubmit: _scoringAfterSubmit,
            onChanged: (value) => setState(() => _scoringAfterSubmit = value),
          ),

          const SizedBox(height: 16),

          // RUNG PHẢN HỒI
          const SettingsSectionHeader(title: 'RUNG PHẢN HỒI'),
          VibrationToggleTile(
            enabled: _vibrationEnabled,
            onChanged: (value) => setState(() => _vibrationEnabled = value),
          ),

          const SizedBox(height: 16),

          // DỮ LIỆU
          const SettingsSectionHeader(title: 'DỮ LIỆU'),
          DeleteHistoryTile(
            onTap: () => _showDeleteConfirmDialog(context),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('Xoá dữ liệu lịch sử',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Bạn có chắc chắn muốn xoá tất cả dữ liệu lịch sử ôn tập và làm bài thi thử?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Xoá', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}