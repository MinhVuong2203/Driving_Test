ÔN LUYỆN GPLX
Ứng dụng mobile phục vụ cho ôn thi GPLX với 600 câu hỏi phục vụ cho tất cả các loại bằng lái

```bash
- Màn hình chính
 + Home: Tổng quan tiến độ học, truy cập nhanh các tính năng
- Ôn luyện
 + Danh sách chủ đề: Hiển thị các chủ đề câu hỏi (biển báo, sa hình, luật giao thông...)
 + Làm bài theo chủ đề: Giao diện câu hỏi trắc nghiệm, có giải thích đáp án
 + Kết quả bài làm: Điểm số, số câu đúng/sai, gợi ý ôn lại
 + Danh sách câu sai: Tổng hợp các câu đã làm sai để ôn lại
- Thi thử
 + Cài đặt đề thi: Chọn số câu, thời gian, loại bằng (A1, B1, B2...)
 + Thi thử: Giao diện mô phỏng phòng thi thật, đếm giờ, cảnh báo câu điểm liệt
 + Kết quả thi thử: Điểm số, xếp loại đậu/rớt, phân tích chi tiết từng câu
- Thống kê
 + Thống kê tổng quan: Biểu đồ tỉ lệ đúng/sai theo chủ đề, streak học hàng ngày
 + Lịch sử làm bài: Danh sách các lần thi thử đã thực hiện
- Tìm trung tâm
 + Bản đồ trung tâm: Hiển thị các trung tâm dạy lái xe gần vị trí người dùng
 + Chi tiết trung tâm: Thông tin, đánh giá, số điện thoại, chỉ đường
- Hỗ trợ AI
 + Nhận diện biển báo: Chụp ảnh biển báo ngoài đường, app giải thích ngay
 + Hỏi đáp AI: Chat với AI để giải thích câu hỏi khó hiểu
- Cộng đồng
 + Feed cộng đồng: Chia sẻ tips, kinh nghiệm lái xe giữa người dùng
 + Chi tiết bài đăng: Xem và bình luận bài chia sẻ
- Cá nhân & Cài đặt
 + Hồ sơ cá nhân: Thông tin người dùng, huy hiệu đạt được
 + Cài đặt: Thông báo, giao diện (dark/light mode).
```
Cấu trúc file 
```bash
lib/
├── apps/
├── database/
├── features/
│   ├── home/
│   │   ├── screens/
│   │   └── widgets/
│   ├── driving_center/
│   │   ├── screens/
│   │   └── widgets/
│   └── practice/
│       ├── screens/
│       └── widgets/
├── models/
├── services/
├── utils/
├── widgets/
└── main.dart
```
main.dart
  Điểm khởi chạy của ứng dụng (runApp)
  Cấu hình MaterialApp, theme, routes,...

apps/
  Chứa cấu hình cấp cao của ứng dụng
  routing (AppRouter)
  theme (AppTheme)
  constants toàn app

features/ 
  Chia theo từng chức năng (feature-based)
  Mỗi feature là một module độc lập, bao gồm đầy đủ UI, logic và dữ liệu liên quan.

models/
  Chứa các model (data class)
  Dùng để: mapping JSON từ API, lưu trữ dữ liệu

services/
  Xử lý logic giao tiếp bên ngoài
  API call (HTTP)
  Firebase
  Authentication service

utils/
  Các hàm tiện ích dùng chung
  format date
  validate input
  helper functions
  main color

widgets/
  Chứa các widget tái sử dụng, các widgets dùng chung



