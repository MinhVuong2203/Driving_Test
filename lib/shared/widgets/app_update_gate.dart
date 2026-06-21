import 'dart:async';
import 'dart:io';

import 'package:driving_test_prep/data/services/external/app_update_service.dart';
import 'package:driving_test_prep/shared/utils/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppUpdateGate extends StatefulWidget {
  const AppUpdateGate({super.key});

  @override
  State<AppUpdateGate> createState() => _AppUpdateGateState();
}

class _AppUpdateGateState extends State<AppUpdateGate> {
  final AppUpdateService _service = AppUpdateService();
  bool _hasChecked = false;

  String? _formatFileSize(int? bytes) {
    if (bytes == null || bytes <= 0) return null;

    const units = ['B', 'KB', 'MB', 'GB'];
    var size = bytes.toDouble();
    var unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    final digits = unitIndex == 0 ? 0 : 2;
    return '${size.toStringAsFixed(digits)} ${units[unitIndex]}';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_checkForUpdate());
    });
  }

  Future<void> _checkForUpdate() async {
    if (_hasChecked || !Platform.isAndroid) return;
    _hasChecked = true;

    try {
      final updateInfo = await _service.checkForUpdate();
      if (!mounted || updateInfo == null) return;

      await _showUpdateDialog(updateInfo);
    } catch (error, stackTrace) {
      debugPrint('AppUpdate: không thể hiển thị cập nhật: $error');
      debugPrintStack(stackTrace: stackTrace);
      // Không chặn người dùng vào app nếu máy đang mất mạng hoặc manifest lỗi.
    }
  }

  Future<void> _showUpdateDialog(AppUpdateInfo updateInfo) {
    final navigatorContext = appNavigatorKey.currentContext;
    if (navigatorContext == null) {
      debugPrint('AppUpdate: chưa có Navigator context để hiển thị dialog.');
      return Future<void>.value();
    }

    debugPrint('AppUpdate: bắt đầu hiển thị dialog cập nhật.');
    return showDialog<void>(
      context: navigatorContext,
      useRootNavigator: true,
      barrierDismissible: !updateInfo.forceUpdate,
      builder: (dialogContext) {
        var isDownloading = false;
        var progress = 0.0;
        String? message;

        Future<void> startUpdate(
          void Function(void Function()) setDialogState,
        ) async {
          setDialogState(() {
            isDownloading = true;
            message = null;
            progress = 0;
          });

          try {
            final apk = await _service.downloadApk(
              updateInfo,
              onProgress: (receivedBytes, totalBytes) {
                if (totalBytes == null || totalBytes <= 0) return;
                setDialogState(() {
                  progress = receivedBytes / totalBytes;
                });
              },
            );

            await _service.installApk(apk);
            if (!dialogContext.mounted) return;
            Navigator.of(dialogContext).pop();
          } on PlatformException catch (error) {
            setDialogState(() {
              isDownloading = false;
              message = error.code == 'INSTALL_PERMISSION_REQUIRED'
                  ? 'Vui lòng bật quyền cài đặt ứng dụng không rõ nguồn gốc, sau đó quay lại bấm Cập nhật.'
                  : 'Không thể mở trình cài đặt. Vui lòng thử lại.';
            });
          } catch (_) {
            setDialogState(() {
              isDownloading = false;
              message = 'Không thể tải bản cập nhật. Vui lòng kiểm tra mạng.';
            });
          }
        }

        return StatefulBuilder(
          builder: (context, setDialogState) {
            final notes = updateInfo.releaseNotes;
            final updateSize = _formatFileSize(updateInfo.apkSizeBytes);

            return AlertDialog(
              title: Text('Có phiên bản ${updateInfo.versionName}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (updateSize != null) ...[
                    Text('Dung lượng tải xuống: $updateSize'),
                    const SizedBox(height: 12),
                  ],
                  if (notes.isNotEmpty) ...[
                    const Text('Nội dung cập nhật:'),
                    const SizedBox(height: 8),
                    ...notes.map(
                      (note) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('- $note'),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (isDownloading) ...[
                    LinearProgressIndicator(
                      value: progress > 0 && progress < 1 ? progress : null,
                    ),
                    const SizedBox(height: 8),
                    const Text('Đang tải bản cập nhật...'),
                  ],
                  if (message != null) ...[
                    const SizedBox(height: 8),
                    Text(message!, style: const TextStyle(color: Colors.red)),
                  ],
                ],
              ),
              actions: [
                if (!updateInfo.forceUpdate)
                  TextButton(
                    onPressed: isDownloading
                        ? null
                        : () => Navigator.of(dialogContext).pop(),
                    child: const Text('Để sau'),
                  ),
                FilledButton(
                  onPressed: isDownloading
                      ? null
                      : () => unawaited(startUpdate(setDialogState)),
                  child: const Text('Cập nhật'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
