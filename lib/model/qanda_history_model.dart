import 'package:flutter/material.dart';

class QandaHistoryModel extends ChangeNotifier {
  List<int> answers = [0];
  List<int> total_questions = [0];
  List<DateTime> days = [];

  void updateData({
    required List<int> answers,
    required List<int> total_questions,
    required List<DateTime> days,
  }) {
    this.answers = answers;
    this.total_questions = total_questions;
    this.days = days;
    notifyListeners();
  }
}
