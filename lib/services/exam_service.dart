import '../models/exam_model.dart';

class ExamService {
  Future<List<Exam>> fetchExams() async {
    // Firebase / REST API call here
    return [];
  }

  Future<void> submitAnswers(String examId, Map<String, String> answers) async {
    // Save to backend
  }
}
