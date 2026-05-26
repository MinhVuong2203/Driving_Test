import 'package:driving_test_prep/data/models/driving_center_model.dart';
import 'package:driving_test_prep/data/repository/DrivingCenterRepository.dart';
import 'package:driving_test_prep/features/driving_centers/screens/center_detail_screen.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:driving_test_prep/shared/utils/constants/province_loader.dart';
import 'package:flutter/material.dart';

class CenterListScreen extends StatefulWidget {
  const CenterListScreen({super.key});

  @override
  State<CenterListScreen> createState() => _CenterListScreenState();
}

class _CenterListScreenState extends State<CenterListScreen> {
  final DrivingCenterRepository _repository = DrivingCenterRepository();
  final ScrollController _scrollController = ScrollController();

  static const int _pageSize = 10;

  final List<DrivingCenter> _centers = [];

  String? _selectedProvince;
  List<String> _provinces = [];
  int _currentPage = 0;
  int _totalCenters = 0;
  int _requestSerial = 0;
  bool _hasMore = true;
  bool _isInitialLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _backgroundColor =>
      _isDark ? AppColors.darkBackground : AppColors.lightBackground;

  Color get _surfaceColor =>
      _isDark ? AppColors.darkSurface : AppColors.lightSurface;

  Color get _textPrimaryColor =>
      _isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  Color get _textSecondaryColor =>
      _isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  Color get _textMutedColor =>
      _isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

  Color get _iconColor => _isDark ? AppColors.iconDark : AppColors.iconLight;

  Color get _inputBackgroundColor =>
      _isDark ? AppColors.darkInputBackground : AppColors.lightInputBackground;

  Color get _inputBorderColor =>
      _isDark ? AppColors.darkInputBorder : AppColors.lightInputBorder;

  Color get _chipBackgroundColor =>
      _isDark ? AppColors.darkChipBackground : AppColors.lightChipBackground;

  Color get _chipTextColor =>
      _isDark ? AppColors.darkChipText : AppColors.lightChipText;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _initProvinceData();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _initProvinceData() async {
    debugPrint('🔄 Bắt đầu load danh sách tỉnh/thành từ utils...');

    final provinces = await ProvinceLoader.loadProvinceNames(
      useDisplayName: false,
    );

    debugPrint('✅ Load xong danh sách tỉnh/thành. Số lượng: ${provinces.length}');

    if (!mounted) return;

    setState(() {
      _provinces = provinces;
      _selectedProvince = provinces.isNotEmpty ? provinces.first : null;

      debugPrint('🎯 Tỉnh/thành đang chọn: $_selectedProvince');

    });

    _loadByProvince(reset: true);
  }

  Future<void> _loadByProvince({bool reset = true}) async {
    final province = _selectedProvince;

    if (province == null || province.trim().isEmpty) {
      setState(() {
        _centers.clear();
        _currentPage = 0;
        _totalCenters = 0;
        _hasMore = false;
        _isInitialLoading = false;
        _isLoadingMore = false;
        _errorMessage = null;
      });
      return;
    }

    if (!reset && (!_hasMore || _isLoadingMore || _isInitialLoading)) {
      return;
    }

    final requestId = ++_requestSerial;
    final nextPage = reset ? 1 : _currentPage + 1;

    if (reset && _scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }

    setState(() {
      if (reset) {
        _centers.clear();
        _currentPage = 0;
        _totalCenters = 0;
        _hasMore = true;
        _isInitialLoading = true;
      } else {
        _isLoadingMore = true;
      }

      _errorMessage = null;
    });

    try {
      final result = await _repository.getCentersByProvince(
        province,
        page: nextPage,
        pageSize: _pageSize,
      );

      if (!mounted || requestId != _requestSerial) return;

      setState(() {
        _centers.addAll(result.items);
        _currentPage = result.page;
        _totalCenters = result.total;
        _hasMore = result.hasMore;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted || requestId != _requestSerial) return;

      setState(() {
        _errorMessage = e.toString();
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _reload() {
    _loadByProvince(reset: true);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 260) {
      _loadByProvince(reset: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
        _isDark ? AppColors.darkAppBarBackground : AppColors.secondary,
        foregroundColor: AppColors.white,
        title: const Text(
          'Trung tâm đào tạo lái xe',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại',
            onPressed: _reload,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProvinceFilter(),
          Expanded(
            child: _buildCenterContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildProvinceFilter() {
    return Container(
      width: double.infinity,
      color: _surfaceColor,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: DropdownButtonFormField<String>(
            value: _selectedProvince,
            isExpanded: true,
            dropdownColor: _isDark
                ? AppColors.darkSelectMenuBackground
                : AppColors.lightSelectMenuBackground,
            iconEnabledColor: _iconColor,
            style: TextStyle(
              color: _isDark
                  ? AppColors.darkSelectText
                  : AppColors.lightSelectText,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              labelText: 'Tỉnh / Thành phố',
              labelStyle: TextStyle(color: _textSecondaryColor),
              prefixIcon: Icon(
                Icons.location_city_outlined,
                color: _iconColor,
              ),
              filled: true,
              fillColor: _inputBackgroundColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: _inputBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.4,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.danger),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
            items: _provinces.map((province) {
              return DropdownMenuItem<String>(
                value: province,
                child: Text(
                  province,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _selectedProvince = value;
              });

              _loadByProvince(reset: true);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCenterContent() {
    if (_isInitialLoading && _centers.isEmpty) {
      return _buildLoadingState();
    }

    if (_errorMessage != null && _centers.isEmpty) {
      return _buildErrorState();
    }

    if (_centers.isEmpty) {
      return _buildEmptyState();
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          itemCount: _centers.length + 1,
          itemBuilder: (context, index) {
            if (index == _centers.length) {
              return _buildListFooter();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildCenterCard(_centers[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListFooter() {
    if (_isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null && _hasMore) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 4),
        child: Center(
          child: TextButton.icon(
            onPressed: () => _loadByProvince(reset: false),
            icon: const Icon(Icons.refresh),
            label: const Text('Thá»­ láº¡i'),
          ),
        ),
      );
    }

    if (!_hasMore && _totalCenters > _pageSize) {
      return const SizedBox(height: 8);
    }

    return const SizedBox(height: 4);
  }

  Widget _buildCenterCard(DrivingCenter center) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: _isDark ? AppColors.cardDark : AppColors.lightSurface,
      shadowColor: _isDark ? AppColors.darkShadow : AppColors.lightShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: _isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CenterDetailScreen(center: center),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCenterImage(center),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCenterInfo(center),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterImage(DrivingCenter center) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: center.photoUrl.isNotEmpty
          ? Image.network(
        center.photoUrl,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(),
      )
          : _imagePlaceholder(),
    );
  }

  Widget _buildCenterInfo(DrivingCenter center) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final chipMaxWidth = constraints.maxWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              center.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _textPrimaryColor,
                fontWeight: FontWeight.w800,
                fontSize: 15.5,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 7),
            if (_buildAddressDisplay(center).isNotEmpty)
              _infoRow(
                icon: Icons.location_on_outlined,
                text: _buildAddressDisplay(center),
                maxLines: 2,
              ),
            if (center.phoneNumber.isNotEmpty) ...[
              const SizedBox(height: 5),
              _infoRow(
                icon: Icons.phone_outlined,
                text: center.phoneNumber,
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (center.rating > 0)
                  _chip(
                    icon: Icons.star,
                    text:
                    '${center.rating.toStringAsFixed(1)} (${center.reviewCount})',
                    maxWidth: chipMaxWidth * 0.48,
                  ),
                if (center.openingStatus.isNotEmpty)
                  _chip(
                    icon: Icons.access_time,
                    text: center.openingStatus,
                    maxWidth: chipMaxWidth,
                  ),
                if (center.city.isNotEmpty)
                  _chip(
                    icon: Icons.location_city_outlined,
                    text: center.city,
                    maxWidth: chipMaxWidth * 0.65,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String text,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: _iconColor),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _textSecondaryColor,
              fontSize: 13,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip({
    required IconData icon,
    required String text,
    double? maxWidth,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _chipBackgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: _isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: _chipTextColor,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  color: _chipTextColor,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            'Đang tải danh sách trung tâm...',
            style: TextStyle(color: _textSecondaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 52, color: _textMutedColor),
            const SizedBox(height: 12),
            Text(
              'Không tải được dữ liệu',
              style: TextStyle(
                color: _textPrimaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vui lòng kiểm tra kết nối hoặc thử lại sau.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _textSecondaryColor),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: _reload,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final provinceName = _selectedProvince ?? '';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 54,
              color: _textMutedColor,
            ),
            const SizedBox(height: 12),
            Text(
              provinceName.isEmpty
                  ? 'Không có dữ liệu tỉnh/thành phố'
                  : 'Không tìm thấy trung tâm ở $provinceName',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textPrimaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bạn có thể chọn tỉnh/thành phố khác hoặc tải lại dữ liệu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _textSecondaryColor),
            ),
          ],
        ),
      ),
    );
  }

  String _buildAddressDisplay(DrivingCenter c) {
    return [c.address, c.district, c.city]
        .where((s) => s.trim().isNotEmpty)
        .join(', ');
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: _isDark ? AppColors.darkSurface : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Icon(
        Icons.directions_car,
        size: 34,
        color: _isDark ? AppColors.darkIconDisabled : AppColors.primary,
      ),
    );
  }
}
