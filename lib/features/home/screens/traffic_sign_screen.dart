import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/traffic_signs_dao.dart';
import 'package:flutter/material.dart';

// ============================================================
// SIGN ICON WIDGET — hỗ trợ theme sáng/tối
// ============================================================
class SignIconWidget extends StatelessWidget {
  final String category;
  final String code;

  const SignIconWidget(
      {super.key, required this.category, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildIcon(),
    );
  }

  Widget _buildIcon() {
    switch (category) {
      case 'cam':
        return Padding(
          padding: const EdgeInsets.all(4),
          child: CustomPaint(painter: _CamSignPainter(code: code)),
        );
      case 'canh-bao':
        return Padding(
          padding: const EdgeInsets.all(4),
          child: CustomPaint(painter: _CanhBaoSignPainter()),
        );
      case 'hieu-lenh':
        return Center(
          child: Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1565C0),
            ),
            child: const Icon(Icons.arrow_upward, color: Colors.white, size: 28),
          ),
        );
      case 'chi-dan':
        return Center(
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.info_outline, color: Colors.white, size: 28),
          ),
        );
      case 'tren-cao-toc':
        return Center(
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.speed, color: Colors.white, size: 28),
          ),
        );
      case 'phu':
      default:
        return Center(
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, color: Colors.black45, size: 26),
          ),
        );
    }
  }
}

class _CamSignPainter extends CustomPainter {
  final String code;
  _CamSignPainter({required this.code});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 1;

    canvas.drawCircle(center, outerRadius,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);

    canvas.drawCircle(center, outerRadius,
        Paint()
          ..color = const Color(0xFFD32F2F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.14);

    if (code == 'P.102') {
      canvas.drawCircle(center, outerRadius * 0.55,
          Paint()..color = const Color(0xFFD32F2F));
      canvas.drawRect(
          Rect.fromCenter(
              center: center,
              width: size.width * 0.55,
              height: size.height * 0.18),
          Paint()..color = Colors.white);
    } else if (code != 'P.101') {
      final lp = Paint()
        ..color = const Color(0xFFD32F2F)
        ..strokeWidth = size.width * 0.09
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(size.width * 0.28, size.height * 0.28),
          Offset(size.width * 0.72, size.height * 0.72), lp);
      canvas.drawLine(Offset(size.width * 0.72, size.height * 0.28),
          Offset(size.width * 0.28, size.height * 0.72), lp);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CanhBaoSignPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 2)
      ..lineTo(size.width - 2, size.height - 2)
      ..lineTo(2, size.height - 2)
      ..close();

    canvas.drawPath(path, Paint()..color = const Color(0xFFFFF9C4));
    canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFFD32F2F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5);

    final tp = TextPainter(
      text: const TextSpan(
          text: '!',
          style: TextStyle(
              color: Color(0xFFD32F2F),
              fontSize: 30,
              fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas,
        Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2 + 6));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// SCREEN
// ============================================================
class TrafficSignsScreen extends StatefulWidget {
  const TrafficSignsScreen({super.key});

  @override
  State<TrafficSignsScreen> createState() => _TrafficSignsScreenState();
}

class _TrafficSignsScreenState extends State<TrafficSignsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final db = DBProvider().db;
  late final TrafficSignsDao _dao;

  bool _isSearching = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final Map<String, List<TrafficSign>> _data = {
    'cam': [],
    'canh-bao': [],
    'chi-dan': [],
    'hieu-lenh': [],
    'phu': [],
    'tren-cao-toc': [],
  };
  bool _isLoading = true;

  static const _tabs = [
    {'label': 'BIỂN CẤM', 'key': 'cam'},
    {'label': 'CẢNH BÁO', 'key': 'canh-bao'},
    {'label': 'CHỈ DẪN', 'key': 'chi-dan'},
    {'label': 'HIỆU LỆNH', 'key': 'hieu-lenh'},
    {'label': 'BIỂN PHỤ', 'key': 'phu'},
    {'label': 'CAO TỐC', 'key': 'tren-cao-toc'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _dao = TrafficSignsDao(db);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    final results = await Future.wait(
      _tabs.map((t) => _dao.getByCategory(t['key']!)),
    );
    if (!mounted) return;
    setState(() {
      for (int i = 0; i < _tabs.length; i++) {
        _data[_tabs[i]['key']!] = results[i];
      }
      _isLoading = false;
    });
  }

  Future<void> _loadSearch(String query) async {
    if (query.trim().isEmpty) {
      await _loadAll();
      return;
    }
    setState(() => _isLoading = true);
    final results = await Future.wait(
      _tabs.map((t) => _dao.searchInCategory(t['key']!, query.trim())),
    );
    if (!mounted) return;
    setState(() {
      for (int i = 0; i < _tabs.length; i++) {
        _data[_tabs[i]['key']!] = results[i];
      }
      _isLoading = false;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
        _loadAll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm biển báo...',
            border: InputBorder.none,
            hintStyle:
            TextStyle(color: onSurface.withOpacity(0.4)),
          ),
          style: TextStyle(color: onSurface),
          onChanged: (v) {
            _searchQuery = v;
            _loadSearch(v);
          },
        )
            : const Text('Biển báo giao thông'),
        centerTitle: !_isSearching,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: Colors.blue,
          unselectedLabelColor: onSurface.withOpacity(0.45),
          indicatorColor: Colors.blue,
          indicatorWeight: 2.5,
          labelStyle:
          const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          padding: const EdgeInsets.only(right: 8),
          tabs: _tabs.map((t) => Tab(text: t['label'])).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: _tabs
            .map((t) => _buildList(_data[t['key']!] ?? [], onSurface))
            .toList(),
      ),
    );
  }

  Widget _buildList(List<TrafficSign> signs, Color onSurface) {
    if (signs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off,
                size: 56, color: onSurface.withOpacity(0.2)),
            const SizedBox(height: 12),
            Text(
              'Không tìm thấy biển báo nào.',
              style: TextStyle(
                  color: onSurface.withOpacity(0.3), fontSize: 15),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: signs.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 104,
        endIndent: 16,
        color: onSurface.withOpacity(0.08),
      ),
      itemBuilder: (context, index) {
        final sign = signs[index];
        return InkWell(
          onTap: () => _showSignDetail(context, sign),
          splashColor: Colors.blue.withOpacity(0.08),
          highlightColor: Colors.blue.withOpacity(0.04),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon biển báo - hiển thị ảnh thật từ assets
                if (sign.imageUrl != null && sign.imageUrl!.isNotEmpty)
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        sign.imageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return SignIconWidget(
                              category: sign.category, code: sign.signId);
                        },
                      ),
                    ),
                  )
                else
                  SignIconWidget(
                      category: sign.category, code: sign.signId),
                const SizedBox(width: 14),
                // Nội dung
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mã biển
                      Text(
                        sign.signId,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Tên biển
                      Text(
                        sign.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: onSurface,
                          height: 1.3,
                        ),
                      ),
                      // Mô tả
                      if (sign.description != null &&
                          sign.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          sign.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: onSurface.withOpacity(0.6),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right,
                    color: onSurface.withOpacity(0.3)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSignDetail(BuildContext context, TrafficSign sign) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nút đóng
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () => Navigator.of(ctx).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(height: 8),
                // Ảnh biển báo
                if (sign.imageUrl != null && sign.imageUrl!.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: Image.asset(
                      sign.imageUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return SignIconWidget(
                          category: sign.category,
                          code: sign.signId,
                        );
                      },
                    ),
                  )
                else
                  SizedBox(
                    height: 200,
                    child: SignIconWidget(
                      category: sign.category,
                      code: sign.signId,
                    ),
                  ),
                const SizedBox(height: 16),
                // Mã biển
                Text(
                  sign.signId,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                // Tên biển
                Text(
                  sign.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                // Mô tả
                if (sign.description != null &&
                    sign.description!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    sign.description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}