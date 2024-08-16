class QuizHistory {
  final String subjectName;
  final DateTime dateTaken;
  final double markAchieved;
  final double totalMarks;
  final List<Question> questions;
  final List<String> userAnswers;
  final String level;
  final int numOfQues;

  QuizHistory({
    required this.subjectName,
    required this.dateTaken,
    required this.markAchieved,
    required this.totalMarks,
    required this.questions,
    required this.userAnswers,
    required this.level,
    required this.numOfQues,
  });

  factory QuizHistory.fromJson(Map<String, dynamic> json) {
    var questionsFromJson = json['questions'] as List;
    List<Question> questionList = questionsFromJson.map((q) => Question.fromJson(q)).toList();

    var userAnswersFromJson = json['userAnswers'] as List;
    List<String> userAnswersList = userAnswersFromJson.map((a) => a.toString()).toList();

    return QuizHistory(
      subjectName: json['subjectName'],
      dateTaken: DateTime.parse(json['dateTaken']),
      markAchieved: json['markAchieved'].toDouble(),
      totalMarks: json['totalMarks'].toDouble(),
      questions: questionList,
      userAnswers: userAnswersList,
      level: json['level'],        // New parameter
      numOfQues: json['num_of_ques'],  // New parameter
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectName': subjectName,
      'dateTaken': dateTaken.toIso8601String(),
      'markAchieved': markAchieved,
      'totalMarks': totalMarks,
      'questions': questions.map((q) => q.toJson()).toList(),
      'userAnswers': userAnswers,
      'level': level,            // New parameter
      'num_of_ques': numOfQues,  // New parameter
    };
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var optionsFromJson = json['options'] as List;
    List<String> optionsList = optionsFromJson.map((o) => o.toString()).toList();

    return Question(
      questionText: json['questionText'],
      options: optionsList,
      correctAnswer: json['correctAnswer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }
}
