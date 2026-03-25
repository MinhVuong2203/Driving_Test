import 'package:flutter/material.dart';
import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/daos/setting_dao.dart';
import 'package:driving_test_prep/data/repository/setting_reponsitory.dart';
import 'package:driving_test_prep/apps/app.dart';
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
  bool _isLoaded = false;

  bool get _darkModeEnabled => themeNotifier.value == 0;

  SettingRepository get _repo =>
      SettingRepository(SettingDao(DBProvider().db));

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final setting = await _repo.getSetting();
    if (setting != null) {
      setState(() {
        _selectedGplx = setting.rankId ?? 'B';
        _scoringAfterSubmit = setting.models == 0;
        _vibrationEnabled = setting.vibration == 1;
        _isLoaded = true;
      });
    } else {
      setState(() => _isLoaded = true);
    }
  }

  Future<void> _onGplxChanged(String value) async {
    setState(() => _selectedGplx = value);
    await _repo.updateRankId(value);
  }

  Future<void> _onScoringChanged(bool value) async {
    setState(() => _scoringAfterSubmit = value);
    await _repo.updateModels(value ? 0 : 1);
  }

  Future<void> _onVibrationChanged(bool value) async {
    setState(() => _vibrationEnabled = value);
    await _repo.updateVibration(value ? 1 : 0);
  }

  Future<void> _onThemeChanged(bool isDark) async {
    final newMode = isDark ? 0 : 1;
    themeNotifier.value = newMode;
    await _repo.updateMode(newMode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cài đặt',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const ExamVersionSection(),

          const SettingsSectionHeader(title: 'HẠNG GPLX'),
          GplxSelectorTile(
            selectedGplx: _selectedGplx,
            onChanged: _onGplxChanged,
          ),

          const SizedBox(height: 16),

          const SettingsSectionHeader(title: 'CHẾ ĐỘ CHẤM ĐIỂM BÀI THI'),
          ScoringModeSection(
            scoringAfterSubmit: _scoringAfterSubmit,
            onChanged: _onScoringChanged,
          ),

          const SizedBox(height: 16),

          const SettingsSectionHeader(title: 'RUNG PHẢN HỒI'),
          VibrationToggleTile(
            enabled: _vibrationEnabled,
            onChanged: _onVibrationChanged,
          ),

          const SizedBox(height: 16),

          const SettingsSectionHeader(title: 'GIAO DIỆN'),
          SwitchListTile(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            secondary: Icon(
              _darkModeEnabled
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
            ),
            title: Text(
              _darkModeEnabled ? 'Chế độ tối' : 'Chế độ sáng',
              style: const TextStyle(fontSize: 16),
            ),
            subtitle: Text(
              _darkModeEnabled
                  ? 'Đang sử dụng giao diện tối'
                  : 'Đang sử dụng giao diện sáng',
              style: const TextStyle(fontSize: 12),
            ),
            value: _darkModeEnabled,
            onChanged: _onThemeChanged,
            activeColor: Colors.blue,
          ),

          const SizedBox(height: 16),

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
        title: const Text('Xoá dữ liệu lịch sử'),
        content: const Text(
          'Bạn có chắc chắn muốn xoá tất cả dữ liệu lịch sử ôn tập và làm bài thi thử?',
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