import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/exercise_viewmodel.dart';
import 'exercise_questions_view.dart';

class StudentExerciseListView extends StatelessWidget {
  final String filterSubject;
  
  const StudentExerciseListView({super.key, required this.filterSubject});

  @override
  Widget build(BuildContext context) {
    final exerciseVm = context.watch<ExerciseViewModel>();
    
    // Filter exercises by the selected subject
    final filteredExercises = exerciseVm.exercises
        .where((ex) => ex.subject == filterSubject)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text("$filterSubject Exercises")),
      body: filteredExercises.isEmpty
          ? const Center(child: Text("No exercises available for this subject"))
          : ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final ex = filteredExercises[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.fitness_center, color: Colors.purple),
                    title: Text(ex.title),
                    subtitle: Text("${ex.program ?? ''} - ${ex.className ?? ''}"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseQuestionsView(exercise: ex),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
