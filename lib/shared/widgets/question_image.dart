import 'dart:io';

import 'package:driving_test_prep/data/services/sqlite/question_image_cache_service.dart';
import 'package:flutter/material.dart';

class QuestionImage extends StatefulWidget {
  final String path;

  const QuestionImage({
    super.key,
    required this.path,
  });

  @override
  State<QuestionImage> createState() => _QuestionImageState();
}

class _QuestionImageState extends State<QuestionImage> {
  File? _localFile;

  @override
  void initState() {
    super.initState();
    QuestionImageCacheService.progress.addListener(_refreshLocalFile);
    _refreshLocalFile();
  }

  @override
  void didUpdateWidget(covariant QuestionImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _refreshLocalFile();
    }
  }

  @override
  void dispose() {
    QuestionImageCacheService.progress.removeListener(_refreshLocalFile);
    super.dispose();
  }

  Future<void> _refreshLocalFile() async {
    final file =
        await QuestionImageCacheService.instance.existingLocalFileFor(widget.path);

    if (!mounted) return;

    if (_localFile?.path != file?.path) {
      setState(() {
        _localFile = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = widget.path.trim();
    if (path.isEmpty) return const SizedBox.shrink();

    final image = _localFile != null
        ? Image.file(
            _localFile!,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          )
        : Image.network(
            QuestionImageCacheService.cloudinaryUrlFor(path),
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 260),
        child: image,
      ),
    );
  }
}
