import 'package:flutter/material.dart';
import 'exam_list_view.dart';

class SubjectListView extends StatelessWidget {
  const SubjectListView({super.key});

  final subjects = const [
    "Computer Science",
    "Mathematics",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subjects")),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(subjects[i]),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExamListView()),
            );
          },
        ),
      ),
    );
  }
}
