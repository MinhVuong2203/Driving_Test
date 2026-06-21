import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_test_prep/shared/utils/constants/app_colors.dart';
import 'package:driving_test_prep/shared/utils/constants/app_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  static const _spamWindow = Duration(minutes: 30);
  static const _maxFeedbacksInWindow = 3;

  final TextEditingController _contentController = TextEditingController();

  bool _isSending = false;
  bool _isValid = false;
  late Future<List<_FeedbackItem>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _loadHistory();
    _contentController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _contentController.removeListener(_validateInput);
    _contentController.dispose();
    super.dispose();
  }

  void _validateInput() {
    final text = _contentController.text.trim();
    final isValid = text.length >= 10;
    if (isValid != _isValid) {
      setState(() {
        _isValid = isValid;
      });
    }
  }

  Future<String?> _spamWarningFor(User? user, String content) async {
    if (user == null) {
      return 'Bạn cần đăng nhập để gửi phản hồi.';
    }

    List<_FeedbackItem> feedbacks;
    try {
      feedbacks = await _loadHistory();
    } catch (_) {
      return null;
    }

    final now = DateTime.now();
    final normalizedContent = _normalizeContent(content);
    var recentCount = 0;

    for (final item in feedbacks) {
      final createdAt = item.createdAt;

      if (createdAt != null && now.difference(createdAt) <= _spamWindow) {
        recentCount++;
      }

      if (_normalizeContent(item.content) == normalizedContent) {
        return 'Bạn đã gửi nội dung này rồi. Hãy bổ sung thêm chi tiết nếu cần.';
      }
    }

    if (recentCount >= _maxFeedbacksInWindow) {
      return 'Bạn đã gửi nhiều phản hồi trong 30 phút gần đây. Vui lòng thử lại sau.';
    }

    return null;
  }

  Future<Map<String, String>> _authHeaders(User user) async {
    final token = await user.getIdToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<_FeedbackItem>> _loadHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final response = await http
          .get(
            Uri.parse('${AppConfig.baseUrl}/api/Feedback/my'),
            headers: await _authHeaders(user),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Bạn cần đăng nhập để xem lịch sử phản hồi.');
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Lịch sử phản hồi tạm thời chưa tải được.');
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! List) return [];

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(_FeedbackItem.fromJson)
          .toList(growable: false);
    } catch (_) {
      return [];
    }
  }

  Future<void> _submitFeedback() async {
    if (!_isValid || _isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final feedbackContent = _contentController.text.trim();
      final spamWarning = await _spamWarningFor(user, feedbackContent);

      if (spamWarning != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(spamWarning),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }

      final platformName = Platform.isAndroid ? 'Android' : 'iOS';
      final response = await http
          .post(
            Uri.parse('${AppConfig.baseUrl}/api/Feedback/submit'),
            headers: await _authHeaders(user!),
            body: jsonEncode({
              'content': feedbackContent,
              'displayName': user.displayName ?? '',
              'email': user.email ?? '',
              'platform': platformName,
            }),
          )
          .timeout(const Duration(seconds: 35));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(_errorMessageFromResponse(response));
      }

      if (!mounted) return;

      _contentController.clear();
      FocusScope.of(context).unfocus();
      setState(() {
        _historyFuture = _loadHistory();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cảm ơn bạn đã gửi góp ý. Chúng tôi sẽ phản hồi ngay trên màn hình này.',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gửi góp ý thất bại: $e. Vui lòng thử lại sau.'),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final mutedColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Góp ý ứng dụng',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [
            _FeedbackIntroCard(
              isDark: isDark,
              textColor: textColor,
              mutedColor: mutedColor,
              borderColor: borderColor,
            ),
            const SizedBox(height: 14),
            _FeedbackComposer(
              controller: _contentController,
              isDark: isDark,
              isSending: _isSending,
              isValid: _isValid,
              textColor: textColor,
              mutedColor: mutedColor,
              borderColor: borderColor,
              onSubmit: _submitFeedback,
            ),
            const SizedBox(height: 22),
            Text(
              'Lịch sử phản hồi',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            _FeedbackHistory(
              historyFuture: _historyFuture,
              isDark: isDark,
              textColor: textColor,
              mutedColor: mutedColor,
              borderColor: borderColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackIntroCard extends StatelessWidget {
  const _FeedbackIntroCard({
    required this.isDark,
    required this.textColor,
    required this.mutedColor,
    required this.borderColor,
  });

  final bool isDark;
  final Color textColor;
  final Color mutedColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bạn cần góp ý gì?',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Hãy mô tả lỗi, trải nghiệm chưa ổn hoặc đề xuất tính năng. Đội ngũ quản trị có thể trả lời trực tiếp tại đây.',
                  style: TextStyle(color: mutedColor, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackComposer extends StatelessWidget {
  const _FeedbackComposer({
    required this.controller,
    required this.isDark,
    required this.isSending,
    required this.isValid,
    required this.textColor,
    required this.mutedColor,
    required this.borderColor,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool isDark;
  final bool isSending;
  final bool isValid;
  final Color textColor;
  final Color mutedColor;
  final Color borderColor;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nội dung phản hồi',
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            minLines: 5,
            maxLines: 9,
            maxLength: 800,
            keyboardType: TextInputType.multiline,
            style: TextStyle(color: textColor, fontSize: 15, height: 1.45),
            decoration: InputDecoration(
              hintText: 'Ví dụ: App bị chậm khi mở đề thi số 3...',
              hintStyle: TextStyle(color: mutedColor.withValues(alpha: 0.72)),
              filled: true,
              fillColor: isDark
                  ? AppColors.darkInputBackground
                  : AppColors.lightInputBackground,
              counterStyle: TextStyle(color: mutedColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tối thiểu 10 ký tự. Tối đa 3 phản hồi trong 30 phút để hạn chế spam.',
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: isValid && !isSending ? onSubmit : null,
                icon: isSending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(isSending ? 'Đang gửi' : 'Gửi'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: isDark
                      ? AppColors.darkButtonDisabled
                      : AppColors.lightButtonDisabled,
                  minimumSize: const Size(98, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeedbackHistory extends StatelessWidget {
  const _FeedbackHistory({
    required this.historyFuture,
    required this.isDark,
    required this.textColor,
    required this.mutedColor,
    required this.borderColor,
  });

  final Future<List<_FeedbackItem>> historyFuture;
  final bool isDark;
  final Color textColor;
  final Color mutedColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_FeedbackItem>>(
      future: historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(28),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return _EmptyHistory(
            message:
                'Lịch sử phản hồi tạm thời chưa tải được. Bạn vẫn có thể gửi góp ý.',
            isDark: isDark,
            mutedColor: mutedColor,
            borderColor: borderColor,
          );
        }

        final items = snapshot.data ?? [];

        final sortedItems = [...items]
          ..sort((a, b) {
            final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bDate.compareTo(aDate);
          });

        if (sortedItems.isEmpty) {
          return _EmptyHistory(
            message: 'Bạn chưa gửi phản hồi nào.',
            isDark: isDark,
            mutedColor: mutedColor,
            borderColor: borderColor,
          );
        }

        return Column(
          children: [
            for (final item in sortedItems) ...[
              _FeedbackHistoryCard(
                item: item,
                isDark: isDark,
                textColor: textColor,
                mutedColor: mutedColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }
}

class _FeedbackHistoryCard extends StatelessWidget {
  const _FeedbackHistoryCard({
    required this.item,
    required this.isDark,
    required this.textColor,
    required this.mutedColor,
    required this.borderColor,
  });

  final _FeedbackItem item;
  final bool isDark;
  final Color textColor;
  final Color mutedColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final hasReply = item.replies.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.content,
                  style: TextStyle(color: textColor, height: 1.5),
                ),
              ),
              const SizedBox(width: 10),
              _StatusChip(status: item.status, hasReply: hasReply),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${_formatDate(item.createdAt)} • ${item.platform}',
            style: TextStyle(color: mutedColor, fontSize: 12.5),
          ),
          if (hasReply)
            for (final reply in item.replies) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: isDark ? 0.14 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.admin_panel_settings_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _replyTitle(reply.source),
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      reply.content,
                      style: TextStyle(color: textColor, height: 1.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(reply.createdAt),
                      style: TextStyle(color: mutedColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.hasReply});

  final String status;
  final bool hasReply;

  @override
  Widget build(BuildContext context) {
    final effectiveStatus = hasReply ? 'replied' : status;
    final color = switch (effectiveStatus) {
      'replied' => AppColors.success,
      'spam' => AppColors.danger,
      _ => AppColors.warning,
    };
    final label = switch (effectiveStatus) {
      'replied' => 'Đã trả lời',
      'spam' => 'Đang kiểm tra',
      _ => 'Đã nhận',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({
    required this.message,
    required this.isDark,
    required this.mutedColor,
    required this.borderColor,
  });

  final String message;
  final bool isDark;
  final Color mutedColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: mutedColor, height: 1.45),
      ),
    );
  }
}

class _FeedbackItem {
  const _FeedbackItem({
    required this.content,
    required this.platform,
    required this.status,
    required this.replies,
    required this.createdAt,
  });

  final String content;
  final String platform;
  final String status;
  final List<_FeedbackReplyItem> replies;
  final DateTime? createdAt;

  static _FeedbackItem fromJson(Map<String, dynamic> data) {
    final rawReplies = data['replies'];
    final replies = rawReplies is List
        ? rawReplies
              .whereType<Map>()
              .map((item) => _FeedbackReplyItem.fromMap(item))
              .where((item) => item.content.trim().isNotEmpty)
              .toList(growable: false)
        : <_FeedbackReplyItem>[];

    return _FeedbackItem(
      content: data['content'] as String? ?? '',
      platform: data['platform'] as String? ?? 'Khác',
      status: data['status'] as String? ?? 'open',
      replies: replies,
      createdAt: _dateFrom(data['timestamp']),
    );
  }

  // ignore: unused_element
  static _FeedbackItem fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final reply = data['reply'];
    final rawReplies = data['replies'];
    final replies = rawReplies is List
        ? rawReplies
              .whereType<Map>()
              .map((item) => _FeedbackReplyItem.fromMap(item))
              .where((item) => item.content.trim().isNotEmpty)
              .toList(growable: false)
        : <_FeedbackReplyItem>[];

    final legacyReplyText =
        data['replyText'] as String? ??
        (reply is Map<String, dynamic>
            ? reply['content'] as String? ?? ''
            : '');
    final fallbackReplies = legacyReplyText.trim().isNotEmpty && replies.isEmpty
        ? [
            _FeedbackReplyItem(
              content: legacyReplyText,
              source:
                  data['replySource'] as String? ??
                  (reply is Map<String, dynamic>
                      ? reply['source'] as String? ?? 'manual'
                      : 'manual'),
              createdAt: _dateFrom(
                data['repliedAt'] ??
                    (reply is Map<String, dynamic> ? reply['repliedAt'] : null),
              ),
            ),
          ]
        : <_FeedbackReplyItem>[];

    return _FeedbackItem(
      content: data['content'] as String? ?? '',
      platform: data['platform'] as String? ?? 'Khác',
      status: data['status'] as String? ?? 'open',
      replies: [...replies, ...fallbackReplies],
      createdAt: _dateFrom(data['timestamp']),
    );
  }
}

class _FeedbackReplyItem {
  const _FeedbackReplyItem({
    required this.content,
    required this.source,
    required this.createdAt,
  });

  final String content;
  final String source;
  final DateTime? createdAt;

  static _FeedbackReplyItem fromMap(Map<dynamic, dynamic> data) {
    return _FeedbackReplyItem(
      content: data['content'] as String? ?? '',
      source: data['source'] as String? ?? 'manual',
      createdAt: _dateFrom(data['createdAt'] ?? data['repliedAt']),
    );
  }
}

DateTime? _dateFrom(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    return parsed;
  }
  return null;
}

String _formatDate(DateTime? value) {
  if (value == null) return 'Chưa có thời gian';
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/'
      '${value.year} '
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}

String _replyTitle(String source) {
  return switch (source) {
    'auto_ai' => 'AI tự động phản hồi',
    'ai' => 'AI hỗ trợ phản hồi',
    _ => 'Phản hồi từ quản trị viên',
  };
}

String _errorMessageFromResponse(http.Response response) {
  try {
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is Map && decoded['message'] is String) {
      return decoded['message'] as String;
    }
  } catch (_) {
    // Fall through to generic message.
  }

  return 'Không thể gửi phản hồi.';
}

String _normalizeContent(String value) {
  return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
}
