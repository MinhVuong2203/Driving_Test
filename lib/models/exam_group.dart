class ExamGroup {
  final int id;
  final String name;
  final int totalQuestions;

  ExamGroup({
    required this.id,
    required this.name,
    required this.totalQuestions,
  });

  factory ExamGroup.fromJson(Map<String, dynamic> json) {
    return ExamGroup(
      id: json['exam_groups_id'],
      name: json['name'],
      totalQuestions: json['total_questions'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exam_groups_id': id,
      'name': name,
      'total_questions': totalQuestions,
    };
  }
}