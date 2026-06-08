# Kiến thức lái xe 600

Ứng dụng Flutter hỗ trợ ôn tập lý thuyết giấy phép lái xe, luyện đề, tra cứu biển báo, tra cứu lỗi vi phạm giao thông, bản đồ trung tâm đào tạo, diễn đàn nội bộ, tài khoản VIP, thông báo nhắc câu sai và nhận diện biển báo bằng AI thông qua backend.

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

5. Chạy Android:

```bash
flutter run -d android --dart-define-from-file=dart_defines.env
```

6. Chạy web:

```bash
flutter run -d chrome --dart-define-from-file=dart_defines.env
```

7. Build APK release:

```bash
 flutter build apk --release --split-per-abi --dart-define-from-file=dart_defines.env
```

8. Nếu thay đổi schema Drift/database hoặc file có annotation cần generate lại:

```bash
dart run build_runner build --delete-conflicting-outputs
```

9. Nếu thay icon app:

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

| Loại tài khoản      | Email/Tên đăng nhập | Mật khẩu | Ghi chú |
| ------------------- | ------------------- | -------- | ------- |
| Tài khoản thường    |                     |          |         |
| Tài khoản VIP       |                     |          |         |
| Tài khoản web/admin |                     |          |         |

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
- Nếu chạy iOS, cần kiểm tra/bổ sung quyền trong `ios/Runner/Info.plist` cho camera, thư viện ảnh và vị trí vì app có dùng `image_picker` và `geolocator`.
- Nếu build Android lỗi Gradle/JVM, kiểm tra lại Java đang dùng là JDK 17 trở lên.
- Dữ liệu câu hỏi, đề thi, hạng bằng, biển báo và tỉnh/thành được đóng gói trong thư mục `assets/json` và ảnh trong `assets/images`; không xóa các asset đã khai báo trong `pubspec.yaml`.
