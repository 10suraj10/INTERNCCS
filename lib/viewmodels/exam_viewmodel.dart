import 'package:flutter/material.dart';
import '../data/mcq_dummy.dart';
import '../models/exam_model.dart';
import '../models/question_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ExamViewModel extends ChangeNotifier {
  List<Exam> exams = [];
  List<Question> _bankQuestions = [];
  List<Question> get bankQuestions => _bankQuestions;

  Future<void> loadQuestionBank() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('question_bank_data');

    if (data != null) {
      List<dynamic> jsonList = json.decode(data);
      _bankQuestions = jsonList.map((item) => Question.fromMap(item)).toList();
      notifyListeners(); // This tells the UI to refresh
    }
  }

  void loadExams() {
    final questions = mcqQuestions.asMap().entries.map((entry) {
      final q = entry.value;
      final options = List<String>.from(q["options"]);

      return Question(
        text: q["q"],
        type: 'MCQ',
        options: options,
        correctAnswer: options[q["answer"]],
      );
    }).toList();

    exams = [
      Exam(
        id: "exam1",
        title: "Computer Basics Test",
        questions: questions,
      ),
    ];

    notifyListeners();
  }
}
