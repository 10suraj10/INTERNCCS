import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/exam_viewmodel.dart';

class SubjectiveQuestionsView extends StatelessWidget {
  const SubjectiveQuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final exams = context.watch<ExamViewModel>();
    final subjectiveQuestions =
        exams.bankQuestions.where((q) => q.type == 'Subjective').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Subjective Questions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${subjectiveQuestions.length} Questions Available",
                style: const TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 10),
            Expanded(
              child: subjectiveQuestions.isEmpty
                  ? const Center(
                      child: Text("No subjective questions added by teachers yet."))
                  : ListView.builder(
                      itemCount: subjectiveQuestions.length,
                      itemBuilder: (context, index) {
                        final q = subjectiveQuestions[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Question ${index + 1}",
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if (q.marks != null)
                                      Text("Marks: ${q.marks}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  q.text,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                                if (q.imagePath != null) ...[
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(File(q.imagePath!), 
                                        height: 200, 
                                        width: double.infinity, 
                                        fit: BoxFit.cover),
                                  ),
                                ],
                                const SizedBox(height: 16),
                                const TextField(
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    hintText: "Type your answer here...",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
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
      bottomNavigationBar: subjectiveQuestions.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Answers submitted (locally)")),
                  );
                  Navigator.pop(context);
                },
                child: const Text("Submit Answers"),
              ),
            ),
    );
  }
}
