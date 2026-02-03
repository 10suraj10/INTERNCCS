import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/question_model.dart';

class AddMcqScreen extends StatefulWidget {
  const AddMcqScreen({super.key});

  @override
  State<AddMcqScreen> createState() => _AddMcqScreenState();
}

class _AddMcqScreenState extends State<AddMcqScreen> {
  final _questionController = TextEditingController();
  final _optAController = TextEditingController();
  final _optBController = TextEditingController();
  final _optCController = TextEditingController();
  final _optDController = TextEditingController();

  String _selectedCorrectOption = 'A';

  Future<void> _saveMCQ() async {
    if (_questionController.text.isEmpty ||
        _optAController.text.isEmpty ||
        _optBController.text.isEmpty ||
        _optCController.text.isEmpty ||
        _optDController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final options = [
      _optAController.text,
      _optBController.text,
      _optCController.text,
      _optDController.text,
    ];

    String correctAnswer = "";
    if (_selectedCorrectOption == 'A') correctAnswer = _optAController.text;
    if (_selectedCorrectOption == 'B') correctAnswer = _optBController.text;
    if (_selectedCorrectOption == 'C') correctAnswer = _optCController.text;
    if (_selectedCorrectOption == 'D') correctAnswer = _optDController.text;

    final newQuestion = Question(
      text: _questionController.text,
      type: 'MCQ',
      options: options,
      correctAnswer: correctAnswer,
    );

    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('question_bank_data');
    List<dynamic> jsonList = savedData != null ? json.decode(savedData) : [];

    jsonList.add(newQuestion.toMap());
    await prefs.setString('question_bank_data', json.encode(jsonList));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("MCQ Saved for Students!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add MCQ Question")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: "Question Text",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            _buildOptionField(_optAController, "Option A"),
            const SizedBox(height: 10),
            _buildOptionField(_optBController, "Option B"),
            const SizedBox(height: 10),
            _buildOptionField(_optCController, "Option C"),
            const SizedBox(height: 10),
            _buildOptionField(_optDController, "Option D"),
            const SizedBox(height: 20),
            const Text("Select Correct Option:",
                style: TextStyle(fontWeight: FontWeight.bold)),
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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveMCQ,
                child: const Text("Save MCQ"),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
