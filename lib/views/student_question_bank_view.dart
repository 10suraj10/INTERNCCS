import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/exam_viewmodel.dart';

class StudentQuestionBankView extends StatelessWidget {
  const StudentQuestionBankView({super.key});

  @override
  Widget build(BuildContext context) {
    final exams = context.watch<ExamViewModel>();
    
    // FILTER: Show only questions added via the "Question Bank" tool (type: 'Bank')
    final bankOnlyQuestions = exams.bankQuestions.where((q) => q.type == 'Bank').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared Question Bank"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${bankOnlyQuestions.length} Items Available",
                style: const TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 10),
            Expanded(
              child: bankOnlyQuestions.isEmpty
                  ? const Center(child: Text("No items in the question bank yet."))
                  : ListView.builder(
                      itemCount: bankOnlyQuestions.length,
                      itemBuilder: (context, index) {
                        final q = bankOnlyQuestions[index];
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
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text("Bank Item",
                                          style: TextStyle(
                                              color: Colors.orange,
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
