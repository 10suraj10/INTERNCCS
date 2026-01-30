import 'package:flutter/material.dart';
import '../models/exercise_model.dart';

class ExerciseViewModel extends ChangeNotifier {
  final List<Exercise> exercises = [];

  void addExercise(String title) {
    exercises.add(Exercise(title: title));
    notifyListeners();
  }
}
