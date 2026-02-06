import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/exam_viewmodel.dart';

class QuestionBankScreen extends StatelessWidget {
  const QuestionBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exams = context.watch<ExamViewModel>();
    
    // Filter to show only questions explicitly marked for the bank
    final bankQuestions = exams.bankQuestions.where((q) => q.isForBank).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher's Question Bank View"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${bankQuestions.length} Items Shared with Students",
                style: const TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 10),
            Expanded(
              child: bankQuestions.isEmpty
                  ? const Center(child: Text("No items in the question bank yet."))
                  : ListView.builder(
                      itemCount: bankQuestions.length,
                      itemBuilder: (context, index) {
                        final q = bankQuestions[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(q.type,
                                          style: const TextStyle(
                                              color: Colors.orange,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    if (q.marks != null)
                                      Text("Marks: ${q.marks}", 
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
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
