import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mcq_dummy.dart';
import '../models/exam_model.dart';
import '../models/question_model.dart';
import '../models/program_model.dart';
import '../services/api_service.dart';
import 'dart:convert';

class ExamViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Exam> exams = [];
  List<Question> _bankQuestions = [];
  List<Question> get bankQuestions => _bankQuestions;

  List<Datum> _bankPrograms = [];
  List<dynamic> _classes = [];
  List<dynamic> _subjects = [];

  List<Datum> get bankPrograms => _bankPrograms;
  List<dynamic> get classes => _classes;
  List<dynamic> get subjects => _subjects;

  dynamic selectedProgram;
  dynamic selectedClass;
  dynamic selectedSubject;

  Future<void> loadQuestionBank() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('question_bank_data');

    if (data != null) {
      List<dynamic> jsonList = json.decode(data);
      _bankQuestions = jsonList.map((item) => Question.fromMap(item)).toList();
    } else {
      _bankQuestions = [];
    }

    // REMOVED AWAIT: Load filters instantly from mock/background
    fetchFilterData();
    
    loadExams(); 
    
    for (var q in exams.expand((e) => e.questions)) {
      bool exists = _bankQuestions.any((bq) => bq.text == q.text);
      if (!exists) {
        _bankQuestions.add(q);
      }
    }

    notifyListeners();
  }

  Future<void> fetchFilterData() async {
    // These calls are now instant in ApiService
    final programRes = await _apiService.fetchPrograms();
    if (programRes != null) {
      _bankPrograms = programRes.data.data;
    }

    final classRes = await _apiService.fetchClasses();
    if (classRes['data'] != null) {
      _classes = classRes['data']['data'] ?? [];
    }

    final subjectRes = await _apiService.fetchSubjects();
    if (subjectRes['data'] != null) {
      _subjects = subjectRes['data']['data'] ?? [];
    }

    notifyListeners();
  }

  void setSelectedProgram(dynamic val) {
    selectedProgram = val;
    notifyListeners();
  }

  void setSelectedClass(dynamic val) {
    selectedClass = val;
    notifyListeners();
  }

  void setSelectedSubject(dynamic val) {
    selectedSubject = val;
    notifyListeners();
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
        program: q["program"],
        className: q["className"],
        subject: q["subject"],
        isForBank: true, 
      );
    }).toList();

    exams = [
      Exam(
        id: "exam1",
        title: "Computer Basics Test",
        questions: questions,
      ),
    ];
  }
}
