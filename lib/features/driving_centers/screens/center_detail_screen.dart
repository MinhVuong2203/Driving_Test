import 'package:driving_test_prep/data/models/driving_center_model.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CenterDetailScreen extends StatelessWidget {
  final DrivingCenter center;

  const CenterDetailScreen({super.key, required this.center});

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  Color _backgroundColor(BuildContext context) =>
      _isDark(context) ? AppColors.darkBackground : AppColors.lightBackground;

  Color _cardColor(BuildContext context) =>
      _isDark(context) ? AppColors.cardDark : AppColors.lightSurface;

  Color _primaryTextColor(BuildContext context) =>
      _isDark(context) ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  Color _mutedTextColor(BuildContext context) =>
      _isDark(context) ? AppColors.darkTextMuted : AppColors.lightTextMuted;

  Color _borderColor(BuildContext context) =>
      _isDark(context) ? AppColors.darkBorder : AppColors.lightBorder;

  Color _chipBackgroundColor(BuildContext context) => _isDark(context)
      ? AppColors.darkChipBackground
      : AppColors.lightChipBackground;

  Color _chipTextColor(BuildContext context) =>
      _isDark(context) ? AppColors.darkChipText : AppColors.lightChipText;

  Color _placeholderColor(BuildContext context) =>
      _isDark(context) ? AppColors.darkInputBackground : AppColors.primaryLight;

  Color _placeholderIconColor(BuildContext context) =>
      _isDark(context) ? AppColors.darkIconDisabled : AppColors.iconLight;

  Color _shadowColor(BuildContext context) =>
      _isDark(context) ? AppColors.darkShadow : AppColors.lightShadow;

  Future<void> _openAddressInMaps(BuildContext context) async {
    final address = center.displayAddress.trim();
    if (address.isEmpty) return;

    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': address,
    });

    await _launchExternal(context, uri, 'Khong mo duoc Google Maps.');
  }

  Future<void> _openWebsite(BuildContext context) async {
    final website = center.website.trim();
    if (website.isEmpty) return;

    final normalizedUrl = website.startsWith(RegExp(r'https?://'))
        ? website
        : 'https://$website';
    final uri = Uri.tryParse(normalizedUrl);

    if (uri == null || !uri.hasScheme) {
      _showMessage(context, 'Lien ket website khong hop le.');
      return;
    }

    await _launchExternal(context, uri, 'Khong mo duoc website.');
  }

  Future<void> _callPhoneNumber(BuildContext context) async {
    final phoneNumber = center.phoneNumber.trim().replaceAll(
      RegExp(r'[\s().-]'),
      '',
    );
    if (phoneNumber.isEmpty) return;

    await _launchExternal(
      context,
      Uri(scheme: 'tel', path: phoneNumber),
      'Khong mo duoc ung dung goi dien.',
    );
  }

  Future<void> _launchExternal(
    BuildContext context,
    Uri uri,
    String errorMessage,
  ) async {
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!context.mounted) return;
      if (!opened) {
        _showMessage(context, errorMessage);
      }
    } catch (_) {
      if (context.mounted) {
        _showMessage(context, errorMessage);
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor(context),
      appBar: AppBar(
        backgroundColor: _isDark(context)
            ? AppColors.darkAppBarBackground
            : AppColors.lightAppBarBackground,
        foregroundColor: _isDark(context)
            ? AppColors.darkAppBarIcon
            : AppColors.lightAppBarIcon,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
        title: Text(
          center.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _isDark(context)
                ? AppColors.darkAppBarText
                : AppColors.lightAppBarText,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildImage(context),
              const SizedBox(height: 16),
              _buildMainCard(context),
              const SizedBox(height: 12),
              _buildContactCard(context),
              const SizedBox(height: 12),
              _buildStatusCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: center.hasPhoto
          ? Image.network(
              center.photoUrl,
              height: 230,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _imagePlaceholder(context),
            )
          : _imagePlaceholder(context),
    );
  }

  Widget _imagePlaceholder(BuildContext context) {
    return Container(
      height: 230,
      width: double.infinity,
      color: _placeholderColor(context),
      child: Center(
        child: Icon(
          Icons.directions_car,
          size: 70,
          color: _placeholderIconColor(context),
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    return _card(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            center.name,
            style: TextStyle(
              color: _primaryTextColor(context),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (center.rating > 0)
                _chip(
                  context,
                  Icons.star,
                  '${center.rating.toStringAsFixed(1)} sao',
                ),
              if (center.reviewCount > 0)
                _chip(
                  context,
                  Icons.reviews_outlined,
                  '${center.reviewCount} đánh giá',
                ),
              if (center.city.isNotEmpty)
                _chip(context, Icons.location_city, center.city),
            ],
          ),
          const SizedBox(height: 16),
          _infoRow(
            context: context,
            icon: Icons.location_on_outlined,
            label: 'Địa chỉ',
            value: center.displayAddress,
            onTap: center.displayAddress.trim().isNotEmpty
                ? () => _openAddressInMaps(context)
                : null,
          ),
          if (center.district.isNotEmpty) ...[
            const SizedBox(height: 12),
            _infoRow(
              context: context,
              icon: Icons.map_outlined,
              label: 'Khu vực',
              value: center.district,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return _card(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin liên hệ',
            style: TextStyle(
              color: _primaryTextColor(context),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          _infoRow(
            context: context,
            icon: Icons.phone_outlined,
            label: 'Số điện thoại',
            value: center.hasPhone ? center.phoneNumber : 'Chưa có dữ liệu',
          ),
          const SizedBox(height: 12),
          _infoRow(
            context: context,
            icon: Icons.language_outlined,
            label: 'Website',
            value: center.hasWebsite ? center.website : 'Chưa có dữ liệu',
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return _card(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trạng thái hoạt động',
            style: TextStyle(
              color: _primaryTextColor(context),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          _infoRow(
            context: context,
            icon: Icons.access_time,
            label: 'Giờ mở cửa',
            value: center.openingStatus.isNotEmpty
                ? center.openingStatus
                : 'Chưa có dữ liệu',
          ),
          const SizedBox(height: 12),
          _infoRow(
            context: context,
            icon: Icons.verified_outlined,
            label: 'Trạng thái',
            value: center.businessStatus.isNotEmpty
                ? center.businessStatus
                : 'Chưa có dữ liệu',
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor(context), width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 6),
            color: _shadowColor(context),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _chip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _chipBackgroundColor(context),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: _chipTextColor(context)),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: _chipTextColor(context),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback? _actionForInfoRow(BuildContext context, IconData icon) {
    if (icon == Icons.location_on_outlined &&
        center.displayAddress.trim().isNotEmpty) {
      return () => _openAddressInMaps(context);
    }

    if (icon == Icons.phone_outlined && center.hasPhone) {
      return () => _callPhoneNumber(context);
    }

    if (icon == Icons.language_outlined && center.hasWebsite) {
      return () => _openWebsite(context);
    }

    return null;
  }

  Widget _infoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    final inferredOnTap = onTap ?? _actionForInfoRow(context, icon);
    final isActionable = inferredOnTap != null;
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: _mutedTextColor(context),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value.isNotEmpty ? value : 'Chưa có dữ liệu',
                style: TextStyle(
                  color: isActionable
                      ? AppColors.primary
                      : _primaryTextColor(context),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        if (isActionable) ...[
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right_rounded,
            size: 22,
            color: _mutedTextColor(context),
          ),
        ],
      ],
    );

    if (!isActionable) return row;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: inferredOnTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: row,
        ),
      ),
    );
  }
}
