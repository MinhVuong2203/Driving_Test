import 'dart:io';
import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/recognition_history_dao.dart';
import 'package:driving_test_prep/data/datasource/external/gemini_service.dart';
import 'package:driving_test_prep/data/repository/recognition_history_repository.dart';
import 'package:driving_test_prep/features/recognition_ai/widget/glass_card.dart';
import 'package:driving_test_prep/features/recognition_ai/widget/history_sidebar.dart';
import 'package:driving_test_prep/features/recognition_ai/widget/result_card.dart';
import 'package:driving_test_prep/shared/utils/constants/img_processor.dart';
import 'package:driving_test_prep/shared/widgets/car_animated_button.dart';
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
  bool showSidebar = true;

  final picker = ImagePicker();
  final geminiService = GeminiService();

  late final RecognitionHistoryRepository historyRepo;

  // History
  List<RecognitionHistoryData> historyList = [];
  RecognitionHistoryData? selectedHistory;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    final db = DBProvider().db;
    final dao = RecognitionHistoryDao(db);
    historyRepo = RecognitionHistoryRepository(dao);

    // Load history
    _loadHistory();

    // Animation setup
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

  /// Load history from database
  Future<void> _loadHistory() async {
    final history = await historyRepo.getAllHistory();
    setState(() {
      historyList = history;
    });
  }

  /// Pick image from camera or gallery
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
        selectedHistory = null; // Clear selected history
      });

      await _recognizeImage(_image!);

      setState(() {
        isLoading = false;
      });
    }
  }

  /// Recognize image using Gemini API
  Future<void> _recognizeImage(File imageFile) async {
    try {
      // Process image
      String base64Image = ImageProcessor.processImage(imageFile);

      // Call Gemini API
      final response = await geminiService.recognizeTrafficSign(base64Image);

      setState(() {
        result = response;
      });

      // Save to database (only if recognition successful)
      if (response.isNotEmpty && !response.contains('Lỗi')) {
        await _saveToHistory(imageFile.path, response);
      }
    } catch (e) {
      setState(() {
        result = "Lỗi: ${e.toString()}";
      });
    }
  }

  /// Save recognition result to database
  Future<void> _saveToHistory(String imagePath, String result) async {
    try {
      // Parse result to extract sign name and type (optional)
      String? signName;
      String? signType;

      // Simple parsing (you can enhance this)
      final lines = result.split('\n');
      for (var line in lines) {
        if (line.toUpperCase().contains('TÊN BIỂN BÁO')) {
          signName = line.replaceAll(RegExp(r'TÊN BIỂN BÁO:?', caseSensitive: false), '').trim();
        } else if (line.toUpperCase().contains('LOẠI BIỂN BÁO')) {
          signType = line.replaceAll(RegExp(r'LOẠI BIỂN BÁO:?', caseSensitive: false), '').trim();
        }
      }

      await historyRepo.saveRecognition(
        imagePath: imagePath,
        result: result,
        signName: signName,
        signType: signType,
      );

      // Reload history
      await _loadHistory();
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  /// Handle history item tap
  void _onHistoryTap(RecognitionHistoryData history) {
    setState(() {
      selectedHistory = history;
      _image = File(history.imagePath);
      result = history.result;
    });
  }

  /// Delete all history
  Future<void> _onDeleteAll() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tất cả lịch sử?'),
        content: const Text('Bạn có chắc chắn muốn xóa toàn bộ lịch sử nhận diện?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await historyRepo.deleteAllHistory();
      await _loadHistory();
      setState(() {
        selectedHistory = null;
        _image = null;
        result = "";
      });
    }
  }

  void _clearImage() {
    setState(() {
      _image = null;
      result = "";
      selectedHistory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text('Nhận diện biển báo',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 8,
              ),
            ],
          ),
        ),
        centerTitle: true,
        leading: IconButton(onPressed: (){
            setState(() {
              showSidebar = !showSidebar;
            });
        }, icon: const Icon(Icons.menu)),
        actions: [
          if (_image != null)
            IconButton(
              onPressed: _clearImage,
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
        ],

      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12), // giảm padding
              child: Column(
                children: [
                  // ROW: Sidebar + Image
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sidebar
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-1, 0), // trượt từ trái
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: showSidebar
                            ? Row(
                          key: const ValueKey(1),
                          children: [
                            HistorySidebar(
                              historyList: historyList,
                              selectedHistory: selectedHistory,
                              onHistoryTap: _onHistoryTap,
                              onDeleteAll: _onDeleteAll,
                            ),
                            const SizedBox(width: 12),
                          ],
                        )
                            : const SizedBox(key: ValueKey(2)),
                      ),



                      Expanded(
                        child: _buildImagePreview(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // RESULT FULL WIDTH
                  if (result.isNotEmpty || isLoading)
                    ResultCard(
                      result: result,
                      isLoading: isLoading,
                    ),

                  const SizedBox(height: 20),

                  _buildActionButtons(),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }


  Widget _buildImagePreview() {
    return GlassCard(
      child: _image != null
          ? Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          if (isLoading) ...[
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 16),
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
        height: 258,
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
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Chưa có ảnh biển báo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
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
        // ActionButton(
        //   icon: Icons.camera_alt,
        //   label: 'Chụp ảnh',
        //   gradient: const LinearGradient(
        //     colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
        //   ),
        //   onPressed: () => _pickImage(ImageSource.camera),
        //   isEnabled: !isLoading,
        // ),

        CarAnimatedButton(
            text: 'Chụp ảnh',
            width: 390,
            height: 80,
            onPressed: () => _pickImage(ImageSource.camera),
            primaryColor: Color(0xFFFF6B6B),
            secondaryColor: Color(0xFFFF8E53),
            isEnabled: !isLoading,
            icon: Icon(Icons.camera_alt, color: Colors.white),
        ),

        const SizedBox(height: 16),
        // ActionButton(
        //   icon: Icons.photo_library,
        //   label: 'Chọn từ thư viện',
        //   gradient: const LinearGradient(
        //     colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
        //   ),
        //   onPressed: () => _pickImage(ImageSource.gallery),
        //   isEnabled: !isLoading,
        // ),

        CarAnimatedButton(
          text: 'Chon từ thư viện',
          width: 390,
          height: 80,
          onPressed: () => _pickImage(ImageSource.gallery),
          primaryColor: Color(0xFF4ECDC4),
          secondaryColor: Color(0xFF44A08D),
          isEnabled: !isLoading,
          icon: Icon(Icons.photo_library, color: Colors.white),
        ),


      ],
    );
  }
}
