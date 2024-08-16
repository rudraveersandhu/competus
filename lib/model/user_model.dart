


import 'package:flutter/material.dart';
import 'package:my_drona/model/quiz_history_model.dart';


class UserModel extends ChangeNotifier {
  String id = '';
  String name = '';
  String email = '';
  String number = '';
  String profilePicture = '';
  String DOB = '';
  String subject = '';
  String subsubject = '';
  String address = '';
  String rank = '';
  double credits_left = 0.0;
  double credits_recharged = 0.0;
  List<QuizHistory> quizHistory = [];
  List<List<dynamic>> graph_performance_data = [ <int>[], <int>[], <DateTime>[]];

  int total_questions_solved = 0;
  int time_spent_practicing = 0;
  String strongest_subject = '';
  String weakest_subject = '';


  void updateData({
    required String id,
    required String name,
    required String email,
    required String number,
    required String profilePicture,
    required String DOB,
    required String subject,
    required String subsubject,
    required String address,
    required String rank,
    required double credits_left,
    required double credits_recharged,
    required List<QuizHistory> quizHistory,
    required List<List<dynamic>> graph_performance_data,
    required total_questions_solved,
    required time_spent_practicing,
    required strongest_subject,
    required weakest_subject,


  }) {

    this.id = id;
    this.name = name;
    this.email = email;
    this.number = number;
    this.profilePicture = profilePicture;
    this.DOB = DOB;
    this.subject = subject;
    this.subsubject = subsubject;
    this.address = address;
    this.rank = rank;
    this.credits_left = credits_left;
    this.credits_recharged = credits_recharged;
    this.quizHistory = quizHistory;
    this.total_questions_solved = total_questions_solved;
    this.time_spent_practicing = time_spent_practicing;
    this.strongest_subject = strongest_subject;
    this.weakest_subject = weakest_subject;
    notifyListeners();
  }

  void updateProfilePhoto({
    required String profilePicture,
  }) {
    this.profilePicture = profilePicture;
    notifyListeners();
  }

  void updateGraphData({
    required List<List<dynamic>> graph_performance_data,
  }) {
    this.graph_performance_data = graph_performance_data;
    notifyListeners();
  }

  void updateTestHistory({
    required List<QuizHistory> quizHistory,
  }) {
    this.quizHistory = quizHistory;
    notifyListeners();
  }

  void utilizeCredits({
    required double credits_left,
  }) {
    this.credits_left = credits_left;
    notifyListeners();
  }

}
