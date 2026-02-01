import 'package:flutter/material.dart';

class AddMcqScreen extends StatefulWidget {
  const AddMcqScreen({super.key});

  @override
  State<AddMcqScreen> createState() => _AddMcqScreenState();
}

class _AddMcqScreenState extends State<AddMcqScreen> {
  // Controllers for the question and the 4 options
  final _questionController = TextEditingController();
  final _optAController = TextEditingController();
  final _optBController = TextEditingController();
  final _optCController = TextEditingController();
  final _optDController = TextEditingController();

  String _selectedCorrectOption = 'A'; // Default correct answer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add MCQ Question")),
      body: SingleChildScrollView( // Allows scrolling if the keyboard covers fields
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Field
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: "Question Text",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Options Fields
            _buildOptionField(_optAController, "Option A"),
            const SizedBox(height: 10),
            _buildOptionField(_optBController, "Option B"),
            const SizedBox(height: 10),
            _buildOptionField(_optCController, "Option C"),
            const SizedBox(height: 10),
            _buildOptionField(_optDController, "Option D"),
            const SizedBox(height: 20),

            // Correct Answer Selector
            const Text("Select Correct Option:", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedCorrectOption,
              isExpanded: true,
              items: ['A', 'B', 'C', 'D'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text("Option $value"),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCorrectOption = newValue!;
                });
              },
            ),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Logic to save the MCQ will go here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("MCQ Saved Locally")),
                  );
                  Navigator.pop(context);
                },
                child: const Text("Save MCQ"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create Option TextFields quickly
  Widget _buildOptionField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}