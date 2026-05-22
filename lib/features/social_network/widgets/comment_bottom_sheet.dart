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

      setState(() {
        _comments.add(newComment);
        _isSending = false;
      });

      widget.onCommentAdded();
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
    return SafeArea(
      top: false,
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
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),

              const Text(
                'Bình luận',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kNavy,
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _comments.isEmpty
                    ? const Center(child: Text('Chưa có bình luận nào'))
                    : ListView.builder(
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundImage:
                        comment.authorAvatar.isNotEmpty
                            ? NetworkImage(comment.authorAvatar)
                            : null,
                        child: comment.authorAvatar.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(
                        comment.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(comment.content),
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
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Viết bình luận...',
                        filled: true,
                        fillColor: kInputBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
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
    );
  }
}