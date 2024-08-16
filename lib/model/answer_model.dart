import 'package:flutter/material.dart';

class AnswerModel extends ChangeNotifier {
  bool answer_1 = false;
  bool answer_2 = false;
  bool answer_3 = false;
  bool answer_4 = false;

  bool selected = false;

  void updateData({
    required bool answer_1,
    required bool answer_2,
    required bool answer_3,
    required bool answer_4,
    required bool selected,
  }) {
    this.answer_1 = answer_1;
    this.answer_2 = answer_2;
    this.answer_3 = answer_3;
    this.answer_4 = answer_4;
    this.selected = selected;

    notifyListeners();
  }

  void toggle_answer1() {
    answer_1 = true;
    notifyListeners();
  }

  void toggle_answer2() {
    answer_2 = true;
    notifyListeners();
  }

  void toggle_answer3() {
    answer_3 = true;
    notifyListeners();
  }

  void toggle_answer4() {
    answer_4 = true;
    notifyListeners();
  }

  void selected_true() {
    selected = true;
    notifyListeners();
  }

  void selected_false() {
    selected = false;
    notifyListeners();
  }

  void all_false() {
    answer_1 = false;
    answer_2 = false;
    answer_3 = false;
    answer_4 = false;
    notifyListeners();
  }

  // Add the setValue method here
  void setValue(bool value) {
    selected = value;
    notifyListeners();
  }
}
