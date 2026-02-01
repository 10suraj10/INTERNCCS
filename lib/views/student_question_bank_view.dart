import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/exam_viewmodel.dart';

class StudentQuestionBankView extends StatelessWidget {
  const StudentQuestionBankView({super.key});

  @override
  Widget build(BuildContext context) {
    final exams = context.watch<ExamViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared Question Bank"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${exams.bankQuestions.length} Items Available",
                style: const TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 10),
            Expanded(
              child: exams.bankQuestions.isEmpty
                  ? const Center(child: Text("No questions shared by teachers yet."))
                  : ListView.builder(
                      itemCount: exams.bankQuestions.length,
                      itemBuilder: (context, index) {
                        final q = exams.bankQuestions[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(q.type,
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(q.text,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                if (q.imagePath != null) ...[
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(File(q.imagePath!),
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover),
                                  ),
                                ],
                                if (q.type == 'MCQ' && q.options != null) ...[
                                  const SizedBox(height: 10),
                                  ...q.options!.map((opt) => Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.radio_button_unchecked,
                                                size: 16,
                                                color: Colors.grey),
                                            const SizedBox(width: 8),
                                            Text(opt),
                                          ],
                                        ),
                                      )),
                                ],
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
