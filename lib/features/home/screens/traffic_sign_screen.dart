import 'package:flutter/material.dart';

class TrafficSign {
  final String code;
  final String name;
  final String description;
  final String category; // 'cam', 'nguy_hiem', 'hieu_lenh', 'chi_dan', 'phu'

  const TrafficSign({
    required this.code,
    required this.name,
    required this.description,
    required this.category,
  });
}

const List<TrafficSign> mockSigns = [
  // BIỂN BÁO CẤM
  TrafficSign(
    code: 'P.101',
    name: 'Đường cấm',
    description:
    'Cấm các loại phương tiện đi lại cả hai hướng, trừ các xe...',
    category: 'cam',
  ),
  TrafficSign(
    code: 'P.102',
    name: 'Cấm đi ngược chiều',
    description:
    'Cấm các loại xe (cơ giới và thô sơ) đi vào theo chiều đặt...',
    category: 'cam',
  ),
  TrafficSign(
    code: 'P.103a',
    name: 'Cấm xe ô tô',
    description:
    'Cấm các loại xe cơ giới kể cả xe máy 3 bánh có thùng đi qua...',
    category: 'cam',
  ),
  TrafficSign(
    code: 'P.103b',
    name: 'Cấm xe ô tô rẽ phải',
    description:
    'Cấm các loại xe cơ giới kể cả xe máy 3 bánh có thùng rẽ phải...',
    category: 'cam',
  ),
  TrafficSign(
    code: 'P.103c',
    name: 'Cấm xe ô tô rẽ trái',
    description:
    'Cấm các loại xe cơ giới kể cả xe máy 3 bánh có thùng rẽ trái...',
    category: 'cam',
  ),
  TrafficSign(
    code: 'P.104',
    name: 'Cấm xe máy',
    description:
    'Cấm các loại xe mô tô, xe máy, xe đạp máy đi vào...',
    category: 'cam',
  ),
  TrafficSign(
    code: 'P.106a',
    name: 'Cấm xe tải',
    description:
    'Cấm các loại ô tô tải đi vào (kể cả ô tô tải có rơ moóc)...',
    category: 'cam',
  ),
  TrafficSign(
    code: 'P.112',
    name: 'Cấm vượt',
    description: 'Cấm tất cả các loại xe cơ giới vượt nhau...',
    category: 'cam',
  ),
  // BIỂN BÁO NGUY HIỂM
  TrafficSign(
    code: 'W.201a',
    name: 'Chỗ ngoặt nguy hiểm vòng trái',
    description:
    'Báo trước sắp đến đoạn đường có chỗ ngoặt nguy hiểm vòng trái...',
    category: 'nguy_hiem',
  ),
  TrafficSign(
    code: 'W.201b',
    name: 'Chỗ ngoặt nguy hiểm vòng phải',
    description:
    'Báo trước sắp đến đoạn đường có chỗ ngoặt nguy hiểm vòng phải...',
    category: 'nguy_hiem',
  ),
  TrafficSign(
    code: 'W.205a',
    name: 'Đường giao nhau cùng cấp',
    description:
    'Báo trước sắp đến chỗ giao nhau giữa hai đường cùng cấp...',
    category: 'nguy_hiem',
  ),
  TrafficSign(
    code: 'W.208',
    name: 'Giao nhau với đường sắt có rào chắn',
    description:
    'Báo trước sắp đến chỗ giao nhau với đường sắt có rào chắn...',
    category: 'nguy_hiem',
  ),
  // BIỂN HIỆU LỆNH
  TrafficSign(
    code: 'R.301',
    name: 'Phải đi vòng chướng ngại vật bên phải',
    description:
    'Buộc người điều khiển phương tiện phải đi vòng sang bên phải...',
    category: 'hieu_lenh',
  ),
  TrafficSign(
    code: 'R.302a',
    name: 'Hướng đi thẳng',
    description:
    'Buộc người điều khiển phương tiện phải đi thẳng...',
    category: 'hieu_lenh',
  ),
  TrafficSign(
    code: 'R.303',
    name: 'Nơi giao nhau chạy theo vòng xuyến',
    description:
    'Buộc các phương tiện phải đi theo chiều mũi tên vòng xuyến...',
    category: 'hieu_lenh',
  ),
  // BIỂN CHỈ DẪN
  TrafficSign(
    code: 'I.407a',
    name: 'Bến xe buýt',
    description: 'Chỉ dẫn vị trí bến xe buýt...',
    category: 'chi_dan',
  ),
  TrafficSign(
    code: 'I.434',
    name: 'Bệnh viện',
    description: 'Chỉ dẫn vị trí bệnh viện hoặc trạm y tế...',
    category: 'chi_dan',
  ),
  // BIỂN PHỤ
  TrafficSign(
    code: 'S.501',
    name: 'Phạm vi tác dụng của biển',
    description:
    'Biển phụ xác định phạm vi tác dụng của biển chính...',
    category: 'phu',
  ),
];

class SignIconWidget extends StatelessWidget {
  final String category;
  final String code;

  const SignIconWidget({
    super.key,
    required this.category,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    switch (category) {
      case 'cam':
        return SizedBox(
          width: 64,
          height: 64,
          child: CustomPaint(painter: _CamSignPainter(code: code)),
        );
      case 'nguy_hiem':
        return SizedBox(
          width: 64,
          height: 64,
          child: CustomPaint(painter: _NguyhiemSignPainter()),
        );
      case 'hieu_lenh':
        return Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF1565C0),
          ),
          child:
          const Icon(Icons.arrow_upward, color: Colors.white, size: 32),
        );
      case 'chi_dan':
        return Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0),
            borderRadius: BorderRadius.circular(6),
          ),
          child:
          const Icon(Icons.info_outline, color: Colors.white, size: 32),
        );
      case 'phu':
      default:
        return Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black54, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.add, color: Colors.black54, size: 28),
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

    // Nền trắng
    canvas.drawCircle(
      center,
      outerRadius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    // Viền đỏ dày
    canvas.drawCircle(
      center,
      outerRadius,
      Paint()
        ..color = const Color(0xFFD32F2F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.13,
    );

    final innerPaint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..style = PaintingStyle.fill;

    if (code == 'P.102') {
      // Thanh ngang trắng trên nền đỏ
      canvas.drawCircle(
          center, outerRadius * 0.55, Paint()..color = const Color(0xFFD32F2F));
      final rect = Rect.fromCenter(
        center: center,
        width: size.width * 0.55,
        height: size.height * 0.18,
      );
      canvas.drawRect(rect, Paint()..color = Colors.white);
    } else if (code != 'P.101') {
      // Gạch chéo generic
      final linePaint = Paint()
        ..color = const Color(0xFFD32F2F)
        ..strokeWidth = size.width * 0.09
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(size.width * 0.28, size.height * 0.28),
        Offset(size.width * 0.72, size.height * 0.72),
        linePaint,
      );
      canvas.drawLine(
        Offset(size.width * 0.72, size.height * 0.28),
        Offset(size.width * 0.28, size.height * 0.72),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NguyhiemSignPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 2)
      ..lineTo(size.width - 2, size.height - 2)
      ..lineTo(2, size.height - 2)
      ..close();

    canvas.drawPath(path, Paint()..color = Colors.white);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFD32F2F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final tp = TextPainter(
      text: const TextSpan(
        text: '!',
        style: TextStyle(
          color: Color(0xFFD32F2F),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(
        (size.width - tp.width) / 2,
        (size.height - tp.height) / 2 + 5,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TrafficSignsScreen extends StatefulWidget {
  const TrafficSignsScreen({super.key});

  @override
  State<TrafficSignsScreen> createState() => _TrafficSignsScreenState();
}

class _TrafficSignsScreenState extends State<TrafficSignsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  static const _tabs = [
    {'label': 'BIỂN BÁO CẤM', 'key': 'cam'},
    {'label': 'BIỂN BÁO NGUY HIỂM', 'key': 'nguy_hiem'},
    {'label': 'BIỂN HIỆU LỆNH', 'key': 'hieu_lenh'},
    {'label': 'BIỂN CHỈ DẪN', 'key': 'chi_dan'},
    {'label': 'BIỂN PHỤ', 'key': 'phu'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<TrafficSign> _filterSigns(String category) {
    return mockSigns.where((s) {
      final matchCategory = s.category == category;
      if (_searchQuery.isEmpty) return matchCategory;
      final q = _searchQuery.toLowerCase();
      return matchCategory &&
          (s.name.toLowerCase().contains(q) ||
              s.code.toLowerCase().contains(q) ||
              s.description.toLowerCase().contains(q));
    }).toList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm biển báo...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black45),
          ),
          onChanged: (v) => setState(() => _searchQuery = v),
        )
            : const Text('Biển báo giao thông'),
        centerTitle: !_isSearching,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
            tooltip: _isSearching ? 'Đóng tìm kiếm' : 'Tìm kiếm',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.blue,
          indicatorWeight: 2.5,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          tabs: _tabs.map((t) => Tab(text: t['label'])).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((t) {
          final signs = _filterSigns(t['key']!);
          if (signs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.black26),
                  SizedBox(height: 12),
                  Text(
                    'Không tìm thấy biển báo nào.',
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: signs.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 1, indent: 96, endIndent: 0),
            itemBuilder: (context, index) {
              final sign = signs[index];
              return InkWell(
                onTap: () {
                  // TODO: Navigate to detail screen
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SignIconWidget(
                        category: sign.category,
                        code: sign.code,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sign.code,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              sign.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              sign.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}