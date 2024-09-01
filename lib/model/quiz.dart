class Quiz {
  final String exam;
  final String topic;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String difficulty;
  final String reasoning;
  final String tag;

  Quiz({
    required this.exam,
    required this.topic,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    required this.reasoning,
    required this.tag,
  });

  // Factory method to create a Quiz instance from a JSON object
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      exam: json['exam'],
      topic: json['topic'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correct_answer'],
      difficulty: json['difficulty'],
      reasoning: json['reasoning'],
      tag: json['tag'],
    );
  }
}
