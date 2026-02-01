import 'package:flutter/material.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  // Controllers hold the text the teacher types
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Question")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Question Input Box
            TextField(
              controller: _questionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Question Text",
                hintText: "Enter your subjective question here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Marks Input Box
            TextField(
              controller: _marksController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Marks",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Logic to save the question will go here later
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Question Saved (Locally)")),
                  );
                  Navigator.pop(context); // Go back to dashboard
                },
                child: const Text("Save Question"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}