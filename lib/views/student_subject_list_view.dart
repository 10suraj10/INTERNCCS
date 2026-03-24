import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/exam_viewmodel.dart';
import 'subject_questions_view.dart';

class StudentSubjectListView extends StatelessWidget {
  const StudentSubjectListView({super.key});

  @override
  Widget build(BuildContext context) {
    final examVm = context.watch<ExamViewModel>();
    
    // Get unique subjects from the bank questions that students can view
    // We filter bankQuestions to get subjects that actually have questions
    final subjects = examVm.bankQuestions
        .map((q) => q.subject)
        .where((s) => s != null && s.isNotEmpty)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Select Subject")),
      body: subjects.isEmpty
          ? const Center(child: Text("No questions available for any subject"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index]!;
                final count = examVm.bankQuestions.where((q) => q.subject == subject).length;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Icon(Icons.book, color: Colors.white),
                    ),
                    title: Text(subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("$count Question${count > 1 ? 's' : ''} available"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubjectQuestionsView(subject: subject),
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
