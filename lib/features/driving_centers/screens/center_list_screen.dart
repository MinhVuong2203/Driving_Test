import 'package:driving_test_prep/services/driving_center_service.dart';
import 'package:flutter/material.dart';
import 'package:driving_test_prep/models/driving_center_model.dart';
import 'center_detail_screen.dart';

class CenterListScreen extends StatefulWidget {
  const CenterListScreen({super.key});

  @override
  State<CenterListScreen> createState() => _CenterListScreenState();
}

class _CenterListScreenState extends State<CenterListScreen> {

  late List<DrivingCenter> centers;

  @override
  void initState() {
    super.initState();
    centers = DrivingCenterService.fakeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Trung tâm đào tạo lái xe"),
        centerTitle: true,
      ),

      body: ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: centers.length,

        itemBuilder: (context, index) {
          final center = centers[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),

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

                child: Row(
                  children: [

                    /// ẢNH
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),

                      child: Image.network(

                        center.photo_url.isNotEmpty
                            ? center.photo_url
                            : "https://picsum.photos/200",

                        width: 90,
                        height: 70,
                        fit: BoxFit.cover,

                        /// nếu ảnh lỗi → hiển thị ảnh trung tâm mặc định
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/driving_center.png",
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          );
                        },

                      ),
                    ),

                    const SizedBox(width: 12),

                    /// THÔNG TIN
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Text(
                            center.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            center.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [

                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),

                              const SizedBox(width: 4),

                              Text(center.rating.toString()),

                              const SizedBox(width: 8),

                              Text(
                                "${center.review_count} reviews",
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),

                            ],
                          ),

                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}