# Kiến thức lái xe 600

Ứng dụng Flutter hỗ trợ ôn tập lý thuyết giấy phép lái xe, luyện đề, tra cứu biển báo, tra cứu lỗi vi phạm giao thông, bản đồ trung tâm đào tạo, diễn đàn nội bộ, tài khoản VIP, thông báo nhắc câu sai và nhận diện biển báo bằng AI thông qua backend.

## Tài liệu báo cáo

Bạn có thể xem file báo cáo tại đây:
[Xem file báo cáo PDF](./Kiến%20thức%20lái%20xe%20word.pdf)

## Công nghệ sử dụng

- Flutter cho mobile/web.
- Dart.
- Firebase: `firebase_core`, `firebase_auth`, `cloud_firestore`.
- Drift ORM + SQLite local: lưu dữ liệu câu hỏi, đề thi, biển báo, tiến trình học, lịch sử, câu sai.
- REST API qua package `http`.
- Web admin/public: `https://drivingtestadminfe-production.up.railway.app/`.
- Google Sign-In, Facebook Login.
- Google Mobile Ads/AdMob.
- OpenStreetMap qua `flutter_map` và `latlong2`.
- Geolocation/geocoding.
- Image picker, xử lý ảnh, speech-to-text, local notifications, app links, email OTP qua Gmail SMTP.

## Phiên bản Flutter/Dart

Phiên bản đang dùng khi kiểm tra project:

```bash
Flutter 3.38.3
Dart 3.10.1
DevTools 2.51.1
```

Ràng buộc SDK trong `pubspec.yaml`:

```yaml
environment:
  sdk: ^3.10.1
```

## Package/dependency

Các dependency chính được khai báo trong `pubspec.yaml`:

| Nhóm                   | Package                                                                   |
| ---------------------- | ------------------------------------------------------------------------- |
| Core/UI                | `flutter`, `cupertino_icons`, `flutter_svg`                               |
| Network/API            | `http`, `url_launcher`, `app_links`                                       |
| Firebase               | `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_messaging` |
| Auth                   | `google_sign_in`, `flutter_facebook_auth`                                 |
| Local database         | `drift`, `sqlite3_flutter_libs`, `sqlite3`, `path_provider`, `path`       |
| Media/AI               | `image_picker`, `image`, `speech_to_text`                                 |
| Map/location           | `flutter_map`, `latlong2`, `geolocator`, `geocoding`                      |
| Notification/ads/share | `flutter_local_notifications`, `google_mobile_ads`, `share_plus`          |
| Storage/email          | `shared_preferences`, `mailer`                                            |

Dev dependency:

- `flutter_test`
- `flutter_lints`
- `flutter_launcher_icons`
- `drift_dev`
- `build_runner`

Không cần cài từng package thủ công. Chạy `flutter pub get` để Flutter tải toàn bộ dependency.

## Cài đặt và chạy project

1. Cài Flutter SDK 3.38.3 hoặc phiên bản tương thích Dart `^3.10.1`.
2. Cài Android Studio/Android SDK. Khi build Android cần dùng JDK 17 trở lên.
3. Clone project và mở terminal tại thư mục gốc:

```bash
cd driving_test
flutter pub get
```

4. Kiểm tra thiết bị:

```bash
flutter devices
```

Sau đó chọn thiết bị phù hợp

5. Chạy Android:

```bash
flutter run --dart-define-from-file=dart_defines.env
```

Lưu ý: phải có file dart_defines.env trước khi chạy (đặt ngang hàng với lib)

6. Build APK release:

```bash
 flutter build apk --release --split-per-abi --dart-define-from-file=dart_defines.env
```

7. Nếu thay đổi schema Drift/database hoặc file có annotation cần generate lại:

```bash
dart run build_runner build --delete-conflicting-outputs
```

8. Nếu thay icon app:

```bash
dart run flutter_launcher_icons
```

## Biến môi trường/dart define

Tính năng gửi OTP qua email dùng `String.fromEnvironment`, cần truyền 2 biến sau khi chạy/build:

```env
SENDER_EMAIL=
APP_PASSWORD=
```

Có thể tạo file `dart_defines.env` ở thư mục gốc theo mẫu trên. File này đang được ignore trong git, không nên commit mật khẩu ứng dụng/email thật.

## Tài khoản test

Web admin/public: https://drivingtestadminfe-production.up.railway.app/

| Loại tài khoản      | Email/Tên đăng nhập       | Mật khẩu |
| ------------------- | ------------------------- | -------- |
| Tài khoản thường    | 1982donua@gmail.com       | 123123   |
| Tài khoản VIP       | minhnguyen14536@gmail.com | 123123   |
| Tài khoản web/admin | vuonghihihihi@gmail.com   | 123123   |

## Cấu hình quan trọng

- Firebase project hiện tại: `myapp-8fb3f`.
- App khởi tạo Firebase tại `lib/main.dart` bằng `lib/firebase_options.dart`.
- Android cần file `android/app/google-services.json`.
- Backend API đang được cấu hình tại `lib/shared/utils/constants/app_config.dart`.
- Public/admin web URL cũng được cấu hình tại `AppConfig.publicPageBaseUrl`.
- AdMob trong AndroidManifest đang dùng test App ID của Google. Một số vị trí quảng cáo lấy config từ API, nếu API lỗi sẽ fallback về test ad unit.
- App có dùng quyền Internet, camera, microphone, location và notification.

## Lưu ý để project hoạt động

- Nên chạy trên Android trước vì Firebase options đã cấu hình Android/iOS/Web; Windows/macOS/Linux chưa được cấu hình trong `firebase_options.dart`.
- Cần kết nối mạng để dùng đăng nhập Firebase, mạng xã hội, VIP/PayOS, đồng bộ vi phạm, nhận diện biển báo, upload ảnh, thông báo và các API backend.
- Tính năng đăng ký OTP chỉ gửi được email khi truyền đúng `SENDER_EMAIL` và `APP_PASSWORD`.
- Google/Facebook Login cần cấu hình đúng SHA-1/SHA-256, OAuth redirect và app id/token trên Firebase Console/Facebook Developer nếu đổi package name hoặc Firebase project.
- Nếu build Android lỗi Gradle/JVM, kiểm tra lại Java đang dùng là JDK 17 trở lên.
- Dữ liệu câu hỏi, đề thi, hạng bằng, biển báo và tỉnh/thành được đóng gói trong thư mục `assets/json` và ảnh trong `assets/images`; không xóa các asset đã khai báo trong `pubspec.yaml`.

## Project sử dụng Firebase và SQLite

Nhóm đã cấu hình sẵn file `google-services.json` cho Android.
Thông tin collection/document mẫu cần có để hệ thống hoạt động:

### Firebase Firestore

| Collection           | Mục đích lưu trữ                                           |
| -------------------- | ---------------------------------------------------------- |
| `users`              | Thông tin người dùng, email, vai trò, trạng thái tài khoản |
| `posts`              | Bài viết cộng đồng của người dùng                          |
| `comments`           | Bình luận trong các bài viết                               |
| `vipPackages`        | Danh sách gói VIP, giá, thời hạn, trạng thái               |
| `paymentOrders`      | Thông tin giao dịch thanh toán VIP                         |
| `notifications`      | Thông báo gửi đến người dùng                               |
| `drivingCenters`     | Thông tin trung tâm đào tạo lái xe                         |
| `Traffic_violations` | Dữ liệu lỗi vi phạm giao thông                             |
| `moderationKeywords` | Từ khóa dùng để kiểm duyệt nội dung                        |

### SQLite local

| Bảng                  | Mục đích lưu trữ                                            |
| --------------------- | ----------------------------------------------------------- |
| `questions`           | Nội dung 600 câu hỏi GPLX                                   |
| `topics`              | Danh sách chủ đề ôn tập                                     |
| `ranks`               | Các hạng giấy phép lái xe                                   |
| `exam_sets`           | Thông tin các bộ đề thi                                     |
| `exam_set_questions`  | Liên kết câu hỏi với từng bộ đề                             |
| `exam_history`        | Lịch sử làm bài thi của người dùng                          |
| `user_answers`        | Đáp án người dùng đã chọn                                   |
| `wrong_questions`     | Các câu hỏi người dùng trả lời sai                          |
| `saved_questions`     | Các câu hỏi người dùng đã lưu                               |
| `traffic_signs`       | Dữ liệu biển báo giao thông                                 |
| `traffic_violations`  | Dữ liệu lỗi vi phạm giao thông                              |
| `driving_centers`     | Dữ liệu trung tâm đào tạo lái xe                            |
| `recognition_history` | Lịch sử nhận diện biển báo bằng AI                          |
| `setting`             | Cấu hình cá nhân như hạng GPLX, giao diện, chế độ chấm điểm |

Script tạo database, Dữ liệu mẫu cần thiết, File cấu hình kết nối đã setup sẵn trong project
