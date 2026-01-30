import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/exam_viewmodel.dart';
import 'mcq_exam_view.dart';

class ExamListView extends StatelessWidget {
  const ExamListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Exams")),
      body: Consumer<ExamViewModel>(
        builder: (context, vm, child) {
          if (vm.exams.isEmpty) {
            return const Center(child: Text("No exams available"));
          }

          return ListView.builder(
            itemCount: vm.exams.length,
            itemBuilder: (context, i) {
              return ListTile(
                title: Text(vm.exams[i].title),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MCQExamView()),
                  );
                },
              );
            },
          );
        },
      ),

    );
  }
}
