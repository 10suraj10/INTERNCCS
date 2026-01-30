import 'package:flutter/material.dart';
import '../data/mcq_dummy.dart';

class MCQExamView extends StatefulWidget {
  const MCQExamView({super.key});

  @override
  State<MCQExamView> createState() => _MCQExamViewState();
}

class _MCQExamViewState extends State<MCQExamView> {
  List<int?> selected = List.filled(mcqQuestions.length, null);
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MCQ Exam")),
      body: ListView.builder(
        itemCount: mcqQuestions.length,
        itemBuilder: (_, i) {
          final q = mcqQuestions[i];
          final options = List<String>.from(q["options"] as List);

          return Card(
            margin: const EdgeInsets.all(12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(q["q"] as String),
                ),

                ...List.generate(options.length, (o) {
                  return RadioListTile<int>(
                    value: o,
                    groupValue: selected[i],
                    title: Text(options[o]),
                    onChanged:
                    submitted ? null : (v) => setState(() => selected[i] = v),
                  );
                }),

                if (submitted)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      selected[i] == (q["answer"] as int)
                          ? "✔ Correct"
                          : "❌ Wrong",
                      style: TextStyle(
                        color: selected[i] == (q["answer"] as int)
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
          onPressed: () => setState(() => submitted = true),
          child: const Text("Submit"),
        ),
      ),
    );
  }
}
