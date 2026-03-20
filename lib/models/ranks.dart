class Rank {
  final String rankId;
  final String name;
  final String description;
  final int totalQuestions;
  final int totalExam;
  final int totalPass;
  final int time;
  final int examGroupId;

  Rank({
    required this.rankId,
    required this.name,
    required this.description,
    required this.totalQuestions,
    required this.totalExam,
    required this.totalPass,
    required this.time,
    required this.examGroupId,
  });

  // JSON → Object
  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      rankId: json['rank_id'],
      name: json['name'],
      description: json['description'],
      totalQuestions: json['total_questions'],
      totalExam: json['total_exam'],
      totalPass: json['total_pass'],
      time: json['time'],
      examGroupId: json['exam_group_id'], // 🔥
    );
  }

  // Object → Map (insert DB)
  Map<String, dynamic> toMap() {
    return {
      'rank_id': rankId,
      'name': name,
      'description': description,
      'total_questions': totalQuestions,
      'total_exam': totalExam,
      'total_pass': totalPass,
      'time': time,
      'exam_group_id': examGroupId, // 🔥
    };
  }
}