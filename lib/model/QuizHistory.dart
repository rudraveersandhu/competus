
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_drona/model/quiz_history_model.dart';


class Quizhistory extends ChangeNotifier {
  List<QuizHistory> histroy_array = [];

   updateQuizHistory({
    required  List<QuizHistory> histroy_array,

   }) {
    this.histroy_array = histroy_array;
    notifyListeners();

  }
}
