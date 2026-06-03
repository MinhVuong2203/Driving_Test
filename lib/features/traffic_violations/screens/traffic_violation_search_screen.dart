import 'package:driving_test_prep/data/models/traffic_violation_model.dart';
import 'package:driving_test_prep/data/repository/traffic_violation_repository.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as speech_to_text;

class TrafficViolationSearchScreen extends StatefulWidget {
  const TrafficViolationSearchScreen({super.key});

  @override
  State<TrafficViolationSearchScreen> createState() =>
      _TrafficViolationSearchScreenState();
}

class _TrafficViolationSearchScreenState
    extends State<TrafficViolationSearchScreen> {
  final _keywordController = TextEditingController();
  final _repository = TrafficViolationRepository.localFirst();
  final _speech = speech_to_text.SpeechToText();

  String? _vehicleType;
  List<TrafficViolation> _results = [];
  bool _isLoading = false;
  bool _isListening = false;
  bool _hasSearched = false;
  String? _error;
  String _lastKeyword = '';
  String _voicePreview = '';

  static const _vehicleFilters = [
    _VehicleFilter(label: 'Tất cả', value: null, icon: Icons.apps_rounded),
    _VehicleFilter(
      label: 'Xe máy',
      value: 'motorbike',
      icon: Icons.two_wheeler_rounded,
    ),
    _VehicleFilter(
      label: 'Ô tô',
      value: 'car',
      icon: Icons.directions_car_filled_rounded,
    ),
    _VehicleFilter(
      label: 'Xe đạp',
      value: 'bicycle',
      icon: Icons.directions_bike_rounded,
    ),
    _VehicleFilter(
      label: 'Người đi bộ',
      value: 'pedestrian',
      icon: Icons.directions_walk_rounded,
    ),
    _VehicleFilter(
      label: 'Hành khách',
      value: 'passenger',
      icon: Icons.airline_seat_recline_normal_rounded,
    ),
    _VehicleFilter(
      label: 'Chủ xe',
      value: 'vehicle_owner',
      icon: Icons.assignment_ind_rounded,
    ),
    _VehicleFilter(
      label: 'Xe chuyên dùng',
      value: 'specialized_vehicle',
      icon: Icons.precision_manufacturing_rounded,
    ),
    _VehicleFilter(
      label: 'Xe thô sơ',
      value: 'animal_drawn_vehicle',
      icon: Icons.agriculture_rounded,
    ),
    _VehicleFilter(label: 'Khác', value: 'other', icon: Icons.more_horiz_rounded),
  ];

  @override
  void dispose() {
    _speech.cancel();
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final keyword = _keywordController.text.trim();

    if (keyword.isEmpty && _vehicleType == null) {
      setState(() {
        _hasSearched = true;
        _results = [];
        _error = 'Nhập từ khóa cần tra cứu, ví dụ: vượt đèn đỏ.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _error = null;
      _lastKeyword = keyword;
    });

    try {
      final result = await _repository.search(
        keyword: keyword,
        vehicleType: _vehicleType,
      );

      if (!mounted) return;
      setState(() {
        _results = result.data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _results = [];
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _openDetail(TrafficViolation violation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrafficViolationDetailScreen(
          violationId: violation.id,
          initialViolation: violation,
        ),
      ),
    );
  }

  Future<void> _toggleVoiceSearch() async {
    if (_isListening) {
      await _speech.stop();
      if (mounted) {
        setState(() {
          _isListening = false;
          _voicePreview = '';
        });
      }
      if (_keywordController.text.trim().isNotEmpty) {
        await _search();
      }
      return;
    }

    final available = await _speech.initialize(
      onStatus: (status) {
        if (!mounted) return;
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
            _voicePreview = '';
          });
        }
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _isListening = false;
          _voicePreview = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể nhận giọng nói: ${error.errorMsg}'),
          ),
        );
      },
    );

    if (!available) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thiết bị chưa cho phép dùng micro.')),
      );
      return;
    }

    if (!mounted) return;
    setState(() {
      _isListening = true;
      _voicePreview = '';
    });

    await _speech.listen(
      localeId: 'vi_VN',
      onResult: (result) async {
        if (!mounted) return;

        _keywordController.text = result.recognizedWords;
        setState(() => _voicePreview = result.recognizedWords);
        _keywordController.selection = TextSelection.fromPosition(
          TextPosition(offset: _keywordController.text.length),
        );

        if (result.finalResult && _keywordController.text.trim().isNotEmpty) {
          setState(() {
            _isListening = false;
            _voicePreview = '';
          });
          await _speech.stop();
          await _search();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Tra cứu lỗi'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _VoiceSearchBox(
                    controller: _keywordController,
                    cardColor: cardColor,
                    onSearch: _search,
                    onVoiceSearch: _toggleVoiceSearch,
                    isListening: _isListening,
                  ),
                  const SizedBox(height: 12),
                  _VehicleTypeSelect(
                    value: _vehicleType,
                    filters: _vehicleFilters,
                    cardColor: cardColor,
                    textColor: textColor,
                    onChanged: (value) {
                      setState(() => _vehicleType = value);
                      if (_hasSearched) _search();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildContent(
                textColor: textColor,
                mutedColor: mutedColor,
                cardColor: cardColor,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _isListening
          ? _VoiceListeningBar(
              previewText: _voicePreview,
              onStop: _toggleVoiceSearch,
            )
          : null,
    );
  }

  Widget _buildContent({
    required Color textColor,
    required Color mutedColor,
    required Color cardColor,
  }) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _EmptyLookupState(
        icon: Icons.error_outline_rounded,
        title: 'Chưa có kết quả',
        message: _error!,
        textColor: textColor,
        mutedColor: mutedColor,
      );
    }

    if (!_hasSearched) {
      return _EmptyLookupState(
        icon: Icons.manage_search_rounded,
        title: 'Nhập lỗi cần tra cứu',
        message:
            'Ví dụ: "vượt đèn đỏ", "lấn tuyến", "không đội mũ bảo hiểm".',
        textColor: textColor,
        mutedColor: mutedColor,
      );
    }

    if (_results.isEmpty) {
      return _EmptyLookupState(
        icon: Icons.search_off_rounded,
        title: 'Không tìm thấy lỗi phù hợp',
        message: 'Thử nhập ngắn gọn hơn hoặc đổi loại phương tiện.',
        textColor: textColor,
        mutedColor: mutedColor,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      itemCount: _results.length + 1,
      separatorBuilder: (_, index) => index == 0
          ? const SizedBox(height: 10)
          : Divider(color: mutedColor.withValues(alpha: 0.24), height: 1),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Text(
            _lastKeyword.isEmpty
                ? 'Có ${_results.length} kết quả được tìm thấy'
                : 'Có ${_results.length} kết quả cho "$_lastKeyword"',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          );
        }

        final violation = _results[index - 1];
        return _ViolationResultTile(
          violation: violation,
          cardColor: cardColor,
          textColor: textColor,
          mutedColor: mutedColor,
          onTap: () => _openDetail(violation),
        );
      },
    );
  }
}

class TrafficViolationDetailScreen extends StatefulWidget {
  final String violationId;
  final TrafficViolation? initialViolation;

  const TrafficViolationDetailScreen({
    super.key,
    required this.violationId,
    this.initialViolation,
  });

  @override
  State<TrafficViolationDetailScreen> createState() =>
      _TrafficViolationDetailScreenState();
}

class _TrafficViolationDetailScreenState
    extends State<TrafficViolationDetailScreen> {
  final _repository = TrafficViolationRepository.localFirst();
  TrafficViolation? _violation;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _violation = widget.initialViolation;
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = widget.initialViolation == null;
      _error = null;
    });

    try {
      final violation = await _repository.getById(widget.violationId);
      if (!mounted) return;
      setState(() {
        _violation = violation;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final violation = _violation;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Chi tiết lỗi'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : violation == null
              ? _EmptyLookupState(
                  icon: Icons.error_outline_rounded,
                  title: 'Không tải được chi tiết',
                  message: _error ?? 'Vui lòng thử lại.',
                  textColor: textColor,
                  mutedColor: mutedColor,
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    _DetailSection(
                      cardColor: cardColor,
                      title: 'Hành vi',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (violation.subjectText.trim().isNotEmpty) ...[
                            Text(
                              violation.subjectText,
                              style: TextStyle(
                                color: mutedColor,
                                fontSize: 15,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          Text(
                            violation.title,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              height: 1.25,
                            ),
                          ),
                          if (violation.fineRangeText.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              violation.fineRangeText,
                              style: const TextStyle(
                                color: AppColors.danger,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                height: 1.3,
                              ),
                            ),
                          ],
                          if (violation.penaltyLegalBasis.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            Text(
                              'Căn cứ pháp lý:',
                              style: TextStyle(
                                color: mutedColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              violation.penaltyLegalBasis,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (violation.hasAdditionalPenalty) ...[
                      const SizedBox(height: 12),
                      _DetailSection(
                        cardColor: cardColor,
                        title: 'Hình thức phạt bổ sung',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (violation.additionalPenaltyText.isNotEmpty)
                              Text(
                                violation.additionalPenaltyText,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  height: 1.45,
                                ),
                              ),
                            if (violation
                                .additionalPenaltyLegalBasis.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Căn cứ pháp lý:',
                                style: TextStyle(
                                  color: mutedColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                violation.additionalPenaltyLegalBasis,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _DetailSection(
                      cardColor: cardColor,
                      title: 'Thông tin áp dụng',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.directions_car_filled_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              violation.vehicleLabel,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _VoiceSearchBox extends StatelessWidget {
  final TextEditingController controller;
  final Color cardColor;
  final VoidCallback onSearch;
  final VoidCallback onVoiceSearch;
  final bool isListening;

  const _VoiceSearchBox({
    required this.controller,
    required this.cardColor,
    required this.onSearch,
    required this.onVoiceSearch,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextField(
          controller: controller,
          onSubmitted: (_) => onSearch(),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            filled: true,
            fillColor: cardColor,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value.text.isNotEmpty)
                  IconButton(
                    tooltip: 'Xóa',
                    icon: const Icon(Icons.close_rounded),
                    onPressed: controller.clear,
                  ),
                IconButton(
                  tooltip: isListening ? 'Dừng nghe' : 'Tìm bằng giọng nói',
                  icon: Icon(
                    isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                    color: isListening ? AppColors.primary : null,
                  ),
                  onPressed: onVoiceSearch,
                ),
              ],
            ),
            hintText: 'Nhập lỗi cần tìm',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }
}

class _VoiceListeningBar extends StatelessWidget {
  final String previewText;
  final VoidCallback onStop;

  const _VoiceListeningBar({
    required this.previewText,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Material(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(18),
          elevation: 10,
          shadowColor: AppColors.black.withValues(alpha: 0.28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mic_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đang nghe...',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        previewText.trim().isEmpty
                            ? 'Nói lỗi cần tra cứu'
                            : previewText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: onStop,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('Dừng'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final Color cardColor;
  final VoidCallback onSearch;
  final VoidCallback onVoiceSearch;
  final bool isListening;

  const _SearchBox({
    required this.controller,
    required this.cardColor,
    required this.onSearch,
    required this.onVoiceSearch,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onSubmitted: (_) => onSearch(),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              filled: true,
              fillColor: cardColor,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => controller.clear(),
              ),
              hintText: 'Nhập lỗi cần tìm',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 52,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            onPressed: onSearch,
            child: const Text('Tìm'),
          ),
        ),
      ],
    );
  }
}

class _ViolationResultTile extends StatelessWidget {
  final TrafficViolation violation;
  final Color cardColor;
  final Color textColor;
  final Color mutedColor;
  final VoidCallback onTap;

  const _ViolationResultTile({
    required this.violation,
    required this.cardColor,
    required this.textColor,
    required this.mutedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (violation.vehicleLabel.isNotEmpty) ...[
                      Text(
                        violation.vehicleLabel,
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      violation.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.28,
                      ),
                    ),
                    if (violation.fineRangeText.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        violation.fineRangeText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final Color cardColor;
  final String title;
  final Widget child;

  const _DetailSection({
    required this.cardColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _EmptyLookupState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color textColor;
  final Color mutedColor;

  const _EmptyLookupState({
    required this.icon,
    required this.title,
    required this.message,
    required this.textColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 46),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedColor,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleTypeSelect extends StatelessWidget {
  static const _allVehicleValue = '__all__';

  final String? value;
  final List<_VehicleFilter> filters;
  final Color cardColor;
  final Color textColor;
  final ValueChanged<String?> onChanged;

  const _VehicleTypeSelect({
    required this.value,
    required this.filters,
    required this.cardColor,
    required this.textColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedValue = value ?? _allVehicleValue;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 56,
      padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          borderRadius: BorderRadius.circular(14),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          menuMaxHeight: 380,
          icon: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          selectedItemBuilder: (context) {
            return filters.map((filter) {
              return _SelectedVehicleLabel(
                label: filter.label,
                icon: filter.icon,
                textColor: textColor,
              );
            }).toList();
          },
          items: filters.map((filter) {
            final itemValue = filter.value ?? _allVehicleValue;
            final selected = itemValue == selectedValue;

            return DropdownMenuItem<String>(
              value: itemValue,
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : AppColors.transparent,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      selected ? Icons.check_rounded : filter.icon,
                      color: selected
                          ? AppColors.primary
                          : textColor.withValues(alpha: 0.62),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    filter.label,
                    style: TextStyle(
                      color: selected ? AppColors.primary : textColor,
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (selected) {
            if (selected == null) return;
            onChanged(selected == _allVehicleValue ? null : selected);
          },
        ),
      ),
    );
  }
}

class _SelectedVehicleLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color textColor;

  const _SelectedVehicleLabel({
    required this.label,
    required this.icon,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Loại phương tiện',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.62),
                  fontSize: 11,
                  height: 1.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VehicleTypeDropdown extends StatelessWidget {
  static const _allVehicleValue = '__all__';

  final String? value;
  final List<_VehicleFilter> filters;
  final Color cardColor;
  final Color textColor;
  final ValueChanged<String?> onChanged;

  const _VehicleTypeDropdown({
    required this.value,
    required this.filters,
    required this.cardColor,
    required this.textColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedValue = value ?? _allVehicleValue;
    final selectedLabel = filters
        .firstWhere(
          (filter) => filter.value == value,
          orElse: () => filters.first,
        )
        .label;

    return PopupMenuButton<String>(
      initialValue: selectedValue,
      offset: const Offset(0, 8),
      elevation: 10,
      constraints: const BoxConstraints(minWidth: 274),
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSurface
          : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (selected) {
        onChanged(selected == _allVehicleValue ? null : selected);
      },
      itemBuilder: (context) => filters
          .map(
            (filter) {
              final itemValue = filter.value ?? _allVehicleValue;
              final selected = itemValue == selectedValue;

              return PopupMenuItem<String>(
              value: itemValue,
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.14)
                          : AppColors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selected
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppColors.primary,
                            size: 20,
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    filter.label,
                    style: TextStyle(
                      color: selected ? AppColors.primary : textColor,
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
            },
          )
          .toList(),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.directions_car_filled_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loại phương tiện',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.62),
                      fontSize: 11,
                      height: 1.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    selectedLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleFilter {
  final String label;
  final String? value;
  final IconData icon;

  const _VehicleFilter({
    required this.label,
    required this.value,
    required this.icon,
  });
}
