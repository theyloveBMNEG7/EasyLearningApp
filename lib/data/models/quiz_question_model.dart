class QuizQuestionModel {
  final String id;
  final String question;
  final List<String> options; // [A, B, C, D]
  final String correctAnswer; // 'A', 'B', 'C', or 'D'
  final String explanation;
  final String topic;
  final String level;

  QuizQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.topic,
    required this.level,
  });

  factory QuizQuestionModel.fromMap(String id, Map<String, dynamic> data) {
    return QuizQuestionModel(
      id: id,
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
      explanation: data['explanation'] ?? '',
      topic: data['topic'] ?? '',
      level: data['level'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'topic': topic,
      'level': level,
    };
  }
}
