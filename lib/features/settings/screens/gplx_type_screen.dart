import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class GplxTypeScreen extends StatefulWidget {
  final String currentSelected;

  const GplxTypeScreen({super.key, required this.currentSelected});

  @override
  State<GplxTypeScreen> createState() => _GplxTypeScreenState();
}

class _GplxTypeScreenState extends State<GplxTypeScreen> {
  late String _selected;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentSelected;
    _loadRanks();
  }

  Future<void> _loadRanks() async {
    final String jsonString =
    await rootBundle.loadString('assets/json/ranks/data_ranks.json');
    final List<dynamic> rawList = jsonDecode(jsonString);

    // Nhóm theo exam_groups_id
    final Map<int, List<Map<String, dynamic>>> grouped = {};
    for (final item in rawList) {
      final groupId = item['exam_groups_id'] as int;
      grouped.putIfAbsent(groupId, () => []).add(item as Map<String, dynamic>);
    }

    // Map tên nhóm theo exam_groups_id
    const groupNames = {
      1: 'MÔ TÔ',
      2: 'Ô TÔ',
      3: 'Ô TÔ TẢI',
      4: 'Ô TÔ TẢI NẶNG',
      5: 'Ô TÔ KHÁCH VÀ RƠ-MOÓC',
    };

    final categories = grouped.entries.map((e) {
      return {
        'group': groupNames[e.key] ?? 'Nhóm ${e.key}',
        'items': e.value
            .map((r) => {
          'code': r['rank_id'] as String,
          'desc': r['description'] as String,
        })
            .toList(),
      };
    }).toList();

    // Sắp xếp theo thứ tự exam_groups_id
    categories.sort((a, b) {
      final aKey = grouped.keys
          .firstWhere((k) => groupNames[k] == a['group'], orElse: () => 99);
      final bKey = grouped.keys
          .firstWhere((k) => groupNames[k] == b['group'], orElse: () => 99);
      return aKey.compareTo(bKey);
    });

    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chọn loại GPLX',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, groupIndex) {
                final group = _categories[groupIndex];
                final items =
                group['items'] as List<Map<String, String>>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Text(
                        group['group'] as String,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    ...items.asMap().entries.map((entry) {
                      final i = entry.key;
                      final item = entry.value;
                      final isSelected = _selected == item['code'];
                      final isLast = i == items.length - 1;

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(
                                      () => _selected = item['code']!);
                            },
                            child: Container(
                              color: const Color(0xFF2C2C2E),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['code']!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item['desc']!,
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow:
                                          TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check,
                                        color: Colors.blue, size: 22),
                                ],
                              ),
                            ),
                          ),
                          if (!isLast)
                            const Divider(
                              height: 1,
                              color: Color(0xFF3A3A3C),
                              indent: 16,
                            ),
                        ],
                      );
                    }),
                  ],
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _selected),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'HOÀN TẤT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}