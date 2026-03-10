import 'dart:convert';
import 'package:driving_test_prep/models/driving_center_model.dart';
import 'package:http/http.dart' as http;

class DrivingCenterService {

  static Future<List<DrivingCenter>> fetchCenters() async {

    final url = Uri.parse(
        "https://local-business-data.p.rapidapi.com/search?query=day%20lai%20xe%20thu%20duc%20ho%20chi%20minh");

    final response = await http.get(
      url,
      headers: {
        "x-rapidapi-host": "local-business-data.p.rapidapi.com",
        "x-rapidapi-key": "2e6a4570a9mshdf3dc872c924882p1b3ac7jsn9cbf738eacc0"
      },
    );

    if (response.statusCode == 200) {

      final data = json.decode(response.body);

      List list = data["data"];

      return list.map((e) => DrivingCenter.fromJson(e)).toList();
    }

    else {
      print(response.body);
      throw Exception("Failed to load data");
    }
  }

  static List<DrivingCenter> fakeData(){
    return [

      DrivingCenter(
        "Trung tâm đào tạo lái xe Thủ Đức",
        "+84901234501",
        "https:/ffdg.com",
        "https://example.com",
        4.9,
        120,
        "OPERATIONAL",
        "1306 Kha Vạn Cân",
        "Thủ Đức",
        "Hồ Chí Minh",
        "Open",
      ),

      DrivingCenter(
        "Trung tâm lái xe Quận 9",
        "+84901234502",
        "",
        "https://example.com",
        4.7,
        98,
        "OPERATIONAL",
        "Xa Lộ Hà Nội",
        "Quận 9",
        "Hồ Chí Minh",
        "Open",
      ),

      DrivingCenter(
        "Học lái xe An Phú",
        "+84901234503",
        "",
        "https://example.com",
        4.8,
        76,
        "OPERATIONAL",
        "Đường Mai Chí Thọ",
        "Thủ Đức",
        "Hồ Chí Minh",
        "Open",
      ),

      DrivingCenter(
        "Trung tâm lái xe Bình Thạnh",
        "+84901234504",
        "",
        "https://example.com",
        4.6,
        88,
        "OPERATIONAL",
        "Điện Biên Phủ",
        "Bình Thạnh",
        "Hồ Chí Minh",
        "Open",
      ),

      DrivingCenter(
        "Học lái xe Gò Vấp",
        "+84901234505",
        "",
        "https://example.com",
        4.5,
        67,
        "OPERATIONAL",
        "Nguyễn Oanh",
        "Gò Vấp",
        "Hồ Chí Minh",
        "Open",
      ),

      DrivingCenter(
        "Trung tâm lái xe Quận 7",
        "+84901234506",
        "",
        "https://example.com",
        4.8,
        112,
        "OPERATIONAL",
        "Huỳnh Tấn Phát",
        "Quận 7",
        "Hồ Chí Minh",
        "Open",
      ),

      DrivingCenter(
        "Trung tâm lái xe Phú Nhuận",
        "+84901234507",
        "",
        "https://example.com",
        4.7,
        54,
        "OPERATIONAL",
        "Phan Xích Long",
        "Phú Nhuận",
        "Hồ Chí Minh",
        "Open",
      ),

      DrivingCenter(
        "Học lái xe Tân Bình",
        "+84901234508",
        "",
        "https://example.com",
        4.9,
        140,
        "OPERATIONAL",
        "Cộng Hòa",
        "Tân Bình",
        "Hồ Chí Minh",
        "Open",
      ),

      DrivingCenter(
        "Trung tâm lái xe Quận 1",
        "+84901234509",
        "",
        "https://example.com",
        4.8,
        200,
        "OPERATIONAL",
        "Nguyễn Huệ",
        "Quận 1",
        "Hồ Chí Minh",
        "Open",
      ),

      DrivingCenter(
        "Trung tâm lái xe Quận 3",
        "+84901234510",
        "",
        "https://example.com",
        4.6,
        73,
        "OPERATIONAL",
        "Nam Kỳ Khởi Nghĩa",
        "Quận 3",
        "Hồ Chí Minh",
        "Open",
      ),

    ];
  }
}