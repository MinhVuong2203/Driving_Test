class SimulationSituation {
  final String docId;
  final int id;
  final String title;
  final int chapter;
  final int duration;
  final String videoUrl;
  final List<SimulationScoreWindow> scoreWindows;
  final bool isActive;

  const SimulationSituation({
    required this.docId,
    required this.id,
    required this.title,
    required this.chapter,
    required this.duration,
    required this.videoUrl,
    required this.scoreWindows,
    required this.isActive,
  });

  factory SimulationSituation.fromJson(Map<String, dynamic> json) {
    final windows = json['scoreWindows'];

    return SimulationSituation(
      docId: _readString(json, 'docId'),
      id: _readInt(json, 'id'),
      title: _readString(json, 'title'),
      chapter: _readInt(json, 'chapter'),
      duration: _readInt(json, 'duration'),
      videoUrl: _readString(json, 'videoUrl'),
      scoreWindows: windows is List
          ? windows
              .map(
                (item) => SimulationScoreWindow.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList()
          : const [],
      isActive: _readBool(json, 'isActive', defaultValue: true),
    );
  }

  String get displayTitle => title.trim().isEmpty ? 'Tình huống $id' : title;

  String get durationText {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  int scoreFor(double second) {
    for (final window in scoreWindows) {
      final isLastWindow = window.score == 1;
      final inWindow = second >= window.from &&
          (isLastWindow ? second <= window.to : second < window.to);
      if (inWindow) return window.score;
    }
    return 0;
  }

  static String _readString(Map<String, dynamic> json, String key) {
    return json[key]?.toString() ?? '';
  }

  static int _readInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static bool _readBool(
    Map<String, dynamic> json,
    String key, {
    bool defaultValue = false,
  }) {
    final value = json[key];
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return defaultValue;
  }
}

class SimulationScoreWindow {
  final double from;
  final double to;
  final int score;

  const SimulationScoreWindow({
    required this.from,
    required this.to,
    required this.score,
  });

  factory SimulationScoreWindow.fromJson(Map<String, dynamic> json) {
    return SimulationScoreWindow(
      from: _readDouble(json, 'from'),
      to: _readDouble(json, 'to'),
      score: _readInt(json, 'score'),
    );
  }

  static double _readDouble(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static int _readInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
