package com.example.driving_test_prep;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.NonNull;
import androidx.core.content.FileProvider;

import java.io.File;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "driving_test_prep/app_update";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                CHANNEL
        ).setMethodCallHandler((call, result) -> {
            if (!"installApk".equals(call.method)) {
                result.notImplemented();
                return;
            }

            String path = call.argument("path");
            if (path == null || path.trim().isEmpty()) {
                result.error("INVALID_PATH", "Đường dẫn APK đang trống.", null);
                return;
            }

            installApk(path, result);
        });
    }

    private void installApk(String path, MethodChannel.Result result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
                && !getPackageManager().canRequestPackageInstalls()) {
            Intent settingsIntent = new Intent(
                    Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                    Uri.parse("package:" + getPackageName())
            );
            startActivity(settingsIntent);
            result.error(
                    "INSTALL_PERMISSION_REQUIRED",
                    "Cần cấp quyền cài đặt ứng dụng không rõ nguồn gốc.",
                    null
            );
            return;
        }

        File apkFile = new File(path);
        if (!apkFile.exists()) {
            result.error("FILE_NOT_FOUND", "Không tìm thấy file APK.", null);
            return;
        }

        Uri apkUri = FileProvider.getUriForFile(
                this,
                getPackageName() + ".app_update_provider",
                apkFile
        );

        Intent installIntent = new Intent(Intent.ACTION_VIEW);
        installIntent.setDataAndType(apkUri, "application/vnd.android.package-archive");
        installIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        installIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(installIntent);

        result.success(null);
    }
}
