import 'package:driving_test_prep/models/driving_center_model.dart';
import 'package:flutter/material.dart';

class CenterDetailScreen extends StatelessWidget {

  final DrivingCenter center;

  const CenterDetailScreen({super.key, required this.center});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: Text(center.name)),

      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1160),
          child: Padding(
            padding: EdgeInsets.all(16),
          
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          
              children: [
          
                Center(
                    child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 700),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(center.photo_url),
                    ),
                  ),
                ),
          
                SizedBox(height: 20),
          
                Text(
                  center.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
          
                SizedBox(height: 10),
          
                Text("Địa chỉ: ${center.address}"),
                // Text("Quận: ${center.district}"),
                // Text("Thành phố: ${center.city}"),
                SizedBox(height: 10),
                Text("SĐT: ${center.phone_number}"),
          
                SizedBox(height: 10),
          
                Text("Uy tín: ${center.rating} ⭐"),
                SizedBox(height: 10),
                Text("Tổng lượt đánh giá: ${center.review_count}"),
          
                SizedBox(height: 10),
          
                Text("Website: ${center.website}"),
          
                SizedBox(height: 10),
          
                Text("Trạng thái: ${center.opening_status}")
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}