import 'package:online_exam_application/models/question_model.dart';

class Exam {
  final String id;
  final String title;
  final List<Question> questions;

  Exam({
    required this.id,
    required this.title,
    required this.questions,
  });
}
