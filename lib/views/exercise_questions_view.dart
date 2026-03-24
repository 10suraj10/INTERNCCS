import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise_model.dart';
import '../viewmodels/exam_viewmodel.dart';

class ExerciseQuestionsView extends StatefulWidget {
  final Exercise exercise;
  const ExerciseQuestionsView({super.key, required this.exercise});

  @override
  State<ExerciseQuestionsView> createState() => _ExerciseQuestionsViewState();
}

class _ExerciseQuestionsViewState extends State<ExerciseQuestionsView> {
  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  void _loadAllData() {
    Future.microtask(() => context.read<ExamViewModel>().loadQuestionBank());
  }

  @override
  Widget build(BuildContext context) {
    final examVm = context.watch<ExamViewModel>();
    
    // Logic: Show questions that match the exercise's Program, Class, and Subject
    final filteredQuestions = examVm.bankQuestions.where((q) {
      bool matches = true;
      if (widget.exercise.program != null && widget.exercise.program!.isNotEmpty) {
        matches = matches && (q.program == widget.exercise.program);
      }
      if (widget.exercise.className != null && widget.exercise.className!.isNotEmpty) {
        matches = matches && (q.className == widget.exercise.className);
      }
      if (widget.exercise.subject != null && widget.exercise.subject!.isNotEmpty) {
        matches = matches && (q.subject == widget.exercise.subject);
      }
      return matches;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.exercise.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Program: ${widget.exercise.program ?? 'N/A'}", style: const TextStyle(color: Colors.grey)),
            Text("Class: ${widget.exercise.className ?? 'N/A'}", style: const TextStyle(color: Colors.grey)),
            Text("Subject: ${widget.exercise.subject ?? 'N/A'}", style: const TextStyle(color: Colors.grey)),
            const Divider(height: 32),
            Expanded(
              child: filteredQuestions.isEmpty
                  ? const Center(child: Text("No questions found for this exercise's criteria"))
                  : ListView.builder(
                      itemCount: filteredQuestions.length,
                      itemBuilder: (context, index) {
                        final q = filteredQuestions[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Q${index + 1}: ${q.text}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                if (q.imagePath != null) ...[
                                  const SizedBox(height: 10),
                                  Image.file(File(q.imagePath!), height: 150),
                                ],
                                if (q.type == 'MCQ' && q.options != null) ...[
                                  const SizedBox(height: 10),
                                  ...q.options!.map((opt) => ListTile(
                                    leading: const Icon(Icons.radio_button_unchecked, size: 20),
                                    title: Text(opt),
                                    dense: true,
                                  )),
                                ],
                                if (q.type == 'Subjective') ...[
                                  const SizedBox(height: 16),
                                  const TextField(
                                    decoration: InputDecoration(
                                      hintText: "Your answer here...",
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 3,
                                  ),
                                ]
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
