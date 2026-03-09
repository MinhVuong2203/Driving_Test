import 'package:driving_test_prep/features/driving_centers/screens/center_detail_screen.dart';
import 'package:driving_test_prep/models/driving_center_model.dart';
import 'package:driving_test_prep/services/driving_center_service.dart';
import 'package:flutter/material.dart';

class CenterListScreen extends StatefulWidget {
  const CenterListScreen({super.key});

  @override
  State<CenterListScreen> createState() => _CenterListScreenState();
}

class _CenterListScreenState extends State<CenterListScreen> {

  late Future<List<DrivingCenter>> centers;

  @override
  void initState() {
    super.initState();
    // centers = DrivingCenterService.fetchCenters();
    centers = Future.value(DrivingCenterService.fakeData());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          child: Center(child: const Text("Trung tâm đào tạo lái xe")),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(0),
          color: Color.fromRGBO(26, 116, 212, 1),
          
        ),
        centerTitle: true
      ),

      body: FutureBuilder<List<DrivingCenter>>(

        future: centers,

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Lỗi tải dữ liệu"));
          }

          final data = snapshot.data!;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1160),

              child: LayoutBuilder(
                builder: (context, constraints) {

                  /// WEB → GRID 3 CỘT
                  if (constraints.maxWidth > 800) {

                    return GridView.builder(

                      padding: const EdgeInsets.only(top: 10),

                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(

                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.3,

                      ),

                      itemCount: data.length,

                      itemBuilder: (context, index) {

                        final center = data[index];

                        return _buildCenterCard(center);

                      },
                    );
                  }

                  /// MOBILE → LIST
                  else {

                    return ListView.builder(

                      padding: const EdgeInsets.all(20),

                      itemCount: data.length,

                      itemBuilder: (context, index) {

                        final center = data[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildCenterCard(center),
                        );

                      },
                    );
                  }

                },
              ),
            ),
          );
        },
      ),
    );
  }

  /// CARD UI CHUNG
  Widget _buildCenterCard(DrivingCenter center) {

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

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

              /// ẢNH
              ClipRRect(
                borderRadius: BorderRadius.circular(10),

                child: Image.network(
                  center.photo_url,
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {

                    return Container(
                      height: 140,
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.image),
                      ),
                    );

                  },
                ),
              ),

              const SizedBox(height: 10),

              /// TÊN
              Text(
                center.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 6),

              /// ĐỊA CHỈ
              Text(
                center.address,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 10),

              /// RATING
              Row(
                children: [

                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 18,
                  ),

                  const SizedBox(width: 4),

                  Text(center.rating.toString()),

                  const SizedBox(width: 10),

                  Text(
                    "${center.review_count} reviews",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}