import 'dart:io';
import 'package:driving_test_prep/data/datasource/external/gemini_service.dart';
import 'package:driving_test_prep/features/recognition_ai/widget/action_button.dart';
import 'package:driving_test_prep/features/recognition_ai/widget/glass_card.dart';
import 'package:driving_test_prep/features/recognition_ai/widget/result_card.dart';
import 'package:driving_test_prep/shared/utils/constants/img_processor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RecognitionHomeScreen extends StatefulWidget {
  const RecognitionHomeScreen({super.key});

  @override
  State<RecognitionHomeScreen> createState() => _RecognitionHomeScreenState();
}

class _RecognitionHomeScreenState extends State<RecognitionHomeScreen>
    with SingleTickerProviderStateMixin {
  File? _image;
  String result = "";
  bool isLoading = false;

  final picker = ImagePicker();
  final geminiService = GeminiService();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (isLoading) return;

    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        isLoading = true;
        result = "";
      });

      await _recognizeImage(_image!);

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _recognizeImage(File imageFile) async {
    try {
      // Process image
      String base64Image = ImageProcessor.processImage(imageFile);

      // Call Gemini API
      final response = await geminiService.recognizeTrafficSign(base64Image);

      setState(() {
        result = response;
      });
    } catch (e) {
      setState(() {
        result = "Lỗi: ${e.toString()}";
      });
    }
  }

  void _clearImage() {
    setState(() {
      _image = null;
      result = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          // const GradientBackground(),

          // Main Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // App Bar
                    _buildAppBar(),

                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Image Preview Card
                            _buildImagePreview(),

                            const SizedBox(height: 24),

                            // Result Card
                            if (result.isNotEmpty || isLoading)
                              ResultCard(
                                result: result,
                                isLoading: isLoading,
                              ),

                            const SizedBox(height: 32),

                            // Action Buttons
                            _buildActionButtons(),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Biển báo Việt Nam',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Nhận diện biển báo thông minh',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (_image != null)
              IconButton(
                onPressed: _clearImage,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.pinkAccent,
                    size: 24,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return GlassCard(
      child: _image != null
          ? Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              _image!,
              height: 320,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          if (isLoading) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 16),
                Text(
                  'Đang phân tích biển báo...',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ],
      )
          : Container(
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFF6B6B).withOpacity(0.2),
                    const Color(0xFFFFE66D).withOpacity(0.2),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Chưa có ảnh biển báo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Chụp ảnh hoặc chọn từ thư viện',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ActionButton(
          icon: Icons.camera_alt,
          label: 'Chụp ảnh',
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          ),
          onPressed: () => _pickImage(ImageSource.camera),
          isEnabled: !isLoading,
        ),
        const SizedBox(height: 16),
        ActionButton(
          icon: Icons.photo_library,
          label: 'Chọn từ thư viện',
          gradient: const LinearGradient(
            colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
          ),
          onPressed: () => _pickImage(ImageSource.gallery),
          isEnabled: !isLoading,
        ),
      ],
    );
  }
}
