import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/repository/comment_api_repository.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';
import 'social_colors.dart';

class CommentBottomSheet extends StatefulWidget {
  const CommentBottomSheet({
    super.key,
    required this.post,
    required this.commentApiRepo,
    required this.isAdmin,
    required this.onCommentAdded,
  });

  final PostModel post;
  final CommentApiRepository commentApiRepo;
  final bool isAdmin;
  final VoidCallback onCommentAdded;

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  final List<CommentModel> _comments = <CommentModel>[];

  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    try {
      final result = await widget.commentApiRepo.getComments(
        widget.post.postId,
      );

      if (!mounted) return;

      setState(() {
        _comments
          ..clear()
          ..addAll(result);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải bình luận: $e')),
      );
    }
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _isSending) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đăng nhập để bình luận')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final newComment = await widget.commentApiRepo.addComment(
        postId: widget.post.postId,
        authorId: user.uid,
        authorName: user.displayName ?? user.email ?? 'Người dùng',
        authorAvatar: user.photoURL ?? '',
        content: text,
      );

      if (!mounted) return;

      _commentController.clear();

      if (!newComment.isDeleted && newComment.status) {
        setState(() {
          _comments.add(newComment);
          _isSending = false;
        });

        widget.onCommentAdded();
      } else {
        setState(() {
          _isSending = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bình luận vi phạm tiêu chuẩn nên đã bị tự động xóa'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSending = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi gửi bình luận: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sheetBg = isDark
        ? const Color(0xFF111827)
        : Colors.white;

    final textColor = isDark
        ? Colors.white
        : const Color(0xFF111827);

    final subTextColor = isDark
        ? const Color(0xFFCBD5E1)
        : const Color(0xFF6B7280);

    final inputBg = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFF3F4F6);

    final inputTextColor = isDark
        ? Colors.white
        : const Color(0xFF111827);

    final hintColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF9CA3AF);

    final borderColor = isDark
        ? const Color(0xFF374151)
        : const Color(0xFFE5E7EB);

    return SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 44,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1F2937) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                  ),

                  Text(
                    'Bình luận',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _comments.isEmpty
                        ? Center(
                            child: Text(
                              'Chưa có bình luận nào',
                              style: TextStyle(
                                color: subTextColor,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : ListView.builder(
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final comment = _comments[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1F2937) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor:
                                isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                                backgroundImage: comment.authorAvatar.isNotEmpty
                                    ? NetworkImage(comment.authorAvatar)
                                    : null,
                                child: comment.authorAvatar.isEmpty
                                    ? Icon(
                                  Icons.person,
                                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280),
                                )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.authorName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      comment.content,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: subTextColor,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          style: TextStyle(
                            color: inputTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: const Color(0xFFF59E0B),
                          decoration: InputDecoration(
                            hintText: 'Viết bình luận...',
                            hintStyle: TextStyle(
                              color: hintColor,
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: inputBg,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: const Color(0xFFF59E0B),
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _isSending ? null : _sendComment,
                        icon: _isSending
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : const Icon(Icons.send_rounded, color: kAmber),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      )
    );
  }
}