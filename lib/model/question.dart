class Question {
  String id;
  String question;
  int questionNumber;
  String optionA;
  String optionB;
  String optionC;
  String optionD;
  String correctAnswer;
  String tag;

  Question({
    required this.id,
    required this.question,
    required this.questionNumber,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    required this.tag,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] ?? '',
      question: json['Question'] ?? '',
      questionNumber: json['Question Number'] ?? 0,
      optionA: json['Option A'] ?? '',
      optionB: json['Option B'] ?? '',
      optionC: json['Option C'] ?? '',
      optionD: json['Option D'] ?? '',
      correctAnswer: json['Correct Answer'] ?? '',
      tag: json['Tag'] ?? '',
    );
  }
}
