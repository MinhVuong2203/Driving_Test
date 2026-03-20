class Question {
  int? id;
  int? topicId;
  String question;
  String? imageUrl;

  String? answerA;
  String? answerB;
  String? answerC;
  String? answerD;

  int ofRankA;
  int ofRankB1;

  String correctAnswer;
  String? explanation;

  int isCritical;

  Question({
    this.id,
    this.topicId,
    required this.question,
    this.imageUrl,
    this.answerA,
    this.answerB,
    this.answerC,
    this.answerD,
    this.ofRankA = 0,
    this.ofRankB1 = 0,
    required this.correctAnswer,
    this.explanation,
    this.isCritical = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic_id': topicId,
      'question': question,
      'image_url': imageUrl,
      'answer_a': answerA,
      'answer_b': answerB,
      'answer_c': answerC,
      'answer_d': answerD,
      'ofRankA': ofRankA,
      'ofRankB1': ofRankB1,
      'correct_answer': correctAnswer,
      'explanation': explanation,
      'is_critical': isCritical,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      topicId: map['topic_id'],
      question: map['question'],
      imageUrl: map['image_url'],
      answerA: map['answer_a'],
      answerB: map['answer_b'],
      answerC: map['answer_c'],
      answerD: map['answer_d'],
      ofRankA: map['ofRankA'] ?? 0,
      ofRankB1: map['ofRankB1'] ?? 0,
      correctAnswer: map['correct_answer'],
      explanation: map['explanation'],
      isCritical: map['is_critical'] ?? 0,
    );
  }
}