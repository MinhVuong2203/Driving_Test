
import 'package:driving_test_prep/data/models/driving_center_model.dart';
import 'package:driving_test_prep/data/services/external/driving_center_service.dart';
import 'package:driving_test_prep/features/driving_centers/screens/center_detail_screen.dart';

import 'package:flutter/material.dart';

class CenterListScreen extends StatefulWidget {
  const CenterListScreen({super.key});

  @override
  State<CenterListScreen> createState() => _CenterListScreenState();
}

class _CenterListScreenState extends State<CenterListScreen> {
  late Future<List<DrivingCenter>> _centersFuture;

  @override
  void initState() {
    super.initState();
    _centersFuture = DrivingCenterService.fakeData();
  }

  void _reload() {
    setState(() {
      _centersFuture = DrivingCenterService.fakeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A74D4),
        foregroundColor: Colors.white,
        title: const Text(
          'Trung tâm đào tạo lái xe',
          style: TextStyle(fontWeight: FontWeight.w600),
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

      body: FutureBuilder<List<DrivingCenter>>(
        future: _centersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Đang tìm trung tâm gần bạn...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Không tải được dữ liệu'),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: _reload, child: const Text('Thử lại')),
                ],
              ),
            );
          }

          final data = snapshot.data!;

          if (data.isEmpty) {
            return const Center(child: Text('Không tìm thấy trung tâm nào.'));
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1160),
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCenterCard(data[index]),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCenterCard(DrivingCenter center) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CenterDetailScreen(center: center),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ẢNH — fallback khi Overpass không có ảnh
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: center.photo_url.isNotEmpty
                    ? Image.network(
                  center.photo_url,
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imagePlaceholder(),
                )
                    : _imagePlaceholder(),
              ),

              const SizedBox(height: 10),

              // TÊN
              Text(
                center.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 6),

              // ĐỊA CHỈ
              if (center.address.isNotEmpty || center.district.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _buildAddressDisplay(center),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 6),

              // PHONE — chỉ hiện khi có
              if (center.phone_number.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.phone, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      center.phone_number,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),

              const SizedBox(height: 10),

              // RATING + OPENING STATUS
              Row(
                children: [
                  // Rating (ẩn nếu = 0 vì Overpass không có)
                  if (center.rating > 0) ...[
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(center.rating.toStringAsFixed(1)),
                    const SizedBox(width: 6),
                    Text(
                      '${center.review_count} reviews',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(width: 10),
                  ],

                  // Giờ mở cửa (opening_hours từ OSM)
                  if (center.opening_status.isNotEmpty)
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              center.opening_status,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ghép địa chỉ đẹp: address + district + city
  String _buildAddressDisplay(DrivingCenter c) {
    return [c.address, c.district, c.city]
        .where((s) => s.isNotEmpty)
        .join(', ');
  }

  // Placeholder ảnh khi Overpass không trả ảnh
  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 6),
          Text('Trung tâm dạy lái xe', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }
}