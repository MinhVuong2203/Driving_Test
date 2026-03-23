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
├── app/
├── core/
│   ├── database/
│   │   ├── tables/
│   │   ├── daos/
│   │   └── seeds/
│   └── network/
│
├── data/
│   ├── datasource/
│   │   ├── remote/
│   │   └── external/
│   ├── models/
│   ├── mapper/
│   └── repository/
│
├── features/
│   ├── topic/
│   ├── question/
│   ├── exam/
│   └── driving_center/
│
├── shared/
│   ├── widgets/
│   └── utils/
│
└── main.dart
```
```bash
#  Flutter App Structure (Drift + API)
# Tổng quan kiến trúc

App sử dụng **Layered Architecture + Repository Pattern**:
UI → Repository → (Local DB + API)
-------------------------------------------------------

## 📂 Cấu trúc thư mục
### core/

Chứa các thành phần nền tảng dùng chung:

* `database/`: SQLite (Drift), tables, DAO, seed data
* `network/`: cấu hình API (Dio, interceptor, endpoints)

---

### data/

Xử lý toàn bộ dữ liệu của app:

* `datasource/`

  * `remote/`: API server của hệ thống
  * `external/`: API bên thứ 3 (Google, map, ...)
* `models/`: model dùng cho API (JSON)
* `mapper/`: convert giữa API model ↔ Drift (DB)
* `repository/`: lớp trung gian, quyết định lấy dữ liệu từ API hay DB

---

### features/

Chia theo từng chức năng (module):

* topic/
* question/
* exam/
* driving_center/

Mỗi feature chứa UI + state management (Provider/Riverpod/Bloc)

---

### shared/

Dùng chung toàn app:

* `widgets/`: widget reusable
* `utils/`: constants, helper

---

## 🔄 Data Flow

UI (features)
→ Repository
→ (DAO - Drift / Remote API / External API)

---

## 📝 Quy ước

* Drift model chỉ dùng cho database
* API dùng model riêng (`models/`)
* Luôn dùng `mapper` để convert dữ liệu
* Không gọi API trực tiếp trong UI
* Repository là nơi xử lý dữ liệu trung tâm

---

## 🎯 Mục tiêu

* Code rõ ràng, dễ maintain
* Tách biệt DB, API, UI
* Hỗ trợ offline (cache bằng Drift)
```



