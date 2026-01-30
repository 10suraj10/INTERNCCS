import 'package:flutter/material.dart';
import '../data/mcq_dummy.dart';
import '../models/exam_model.dart';
import '../models/question_model.dart';

class ExamViewModel extends ChangeNotifier {
  List<Exam> exams = [];

  void loadExams() {
    final questions = mcqQuestions.asMap().entries.map((entry) {
      final index = entry.key;
      final q = entry.value;

      final options = List<String>.from(q["options"]);

      return Question(
        id: "q$index",
        question: q["q"],
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
