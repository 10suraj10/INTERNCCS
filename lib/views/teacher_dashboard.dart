import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/exercise_viewmodel.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExerciseViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthViewModel>().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: vm.exercises.isEmpty
          ? const Center(child: Text("No exercises added"))
          : ListView.builder(
              itemCount: vm.exercises.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(vm.exercises[i].title),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addExerciseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addExerciseDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Exercise"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter exercise title",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<ExerciseViewModel>().addExercise(controller.text);
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
