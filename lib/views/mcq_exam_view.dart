import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/exam_viewmodel.dart';

class MCQExamView extends StatefulWidget {
  const MCQExamView({super.key});

  @override
  State<MCQExamView> createState() => _MCQExamViewState();
}

class _MCQExamViewState extends State<MCQExamView> {
  Map<int, int?> selected = {};
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    final exams = context.watch<ExamViewModel>();
    final mcqs = exams.bankQuestions.where((q) => q.type == 'MCQ').toList();

    return Scaffold(
      appBar: AppBar(title: const Text("MCQ Exam")),
      body: mcqs.isEmpty
          ? const Center(child: Text("No MCQ questions available."))
          : ListView.builder(
              itemCount: mcqs.length,
              itemBuilder: (_, i) {
                final q = mcqs[i];
                final options = q.options ?? [];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Question ${i + 1}", 
                                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                if (q.marks != null)
                                  Text("Marks: ${q.marks}", 
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(q.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      
                      if (q.imagePath != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(q.imagePath!), 
                                height: 150, 
                                width: double.infinity, 
                                fit: BoxFit.cover),
                          ),
                        ),

                      const SizedBox(height: 8),

                      ...List.generate(options.length, (o) {
                        return RadioListTile<int>(
                          value: o,
                          groupValue: selected[i],
                          title: Text(options[o]),
                          onChanged: submitted
                              ? null
                              : (v) => setState(() => selected[i] = v),
                        );
                      }),
                      if (submitted)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            options[selected[i] ?? -1] == q.correctAnswer
                                ? "✔ Correct"
                                : "❌ Wrong (Correct: ${q.correctAnswer})",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: options[selected[i] ?? -1] == q.correctAnswer
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        )
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: mcqs.isEmpty ? null : () => setState(() => submitted = true),
          child: const Text("Submit Exam"),
        ),
      ),
    );
  }
}
