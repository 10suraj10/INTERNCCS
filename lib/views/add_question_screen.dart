import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/question_model.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();
  
  // MCQ Options controllers
  final _optAController = TextEditingController();
  final _optBController = TextEditingController();
  final _optCController = TextEditingController();
  final _optDController = TextEditingController();
  String _selectedCorrectOption = 'A';

  List<Map<String, dynamic>> _savedQuestions = [];

  // Dropdown values
  String _selectedProgram = 'primary';
  String? _selectedClass;
  String _selectedSubject = 'Math';
  String _selectedType = 'Subjective';

  final Map<String, List<String>> _programClasses = {
    'primary': ['1', '2', '3', '4', '5'],
    'secondary': ['6', '7', '8', '9', '10'],
    '+2': ['11', '12'],
    'bachelor': ['1st Year', '2nd Year', '3rd Year', '4th Year'],
    'masters': ['1st Year', '2nd Year'],
  };

  final List<String> _subjects = ['Math', 'Science', 'English', 'Social Studies', 'Computer'];

  @override
  void initState() {
    super.initState();
    _selectedClass = _programClasses[_selectedProgram]![0];
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('question_bank_data');
    if (savedData != null) {
      List<dynamic> allQuestions = json.decode(savedData);
      setState(() {
        _savedQuestions = allQuestions.cast<Map<String, dynamic>>().toList();
      });
    }
  }

  Future<void> _saveQuestion() async {
    if (_questionController.text.isEmpty) return;

    List<String>? options;
    String? correctAnswer;

    if (_selectedType == 'MCQ') {
      options = [
        _optAController.text,
        _optBController.text,
        _optCController.text,
        _optDController.text,
      ];
      if (options.any((opt) => opt.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all MCQ options")));
        return;
      }
      if (_selectedCorrectOption == 'A') correctAnswer = _optAController.text;
      else if (_selectedCorrectOption == 'B') correctAnswer = _optBController.text;
      else if (_selectedCorrectOption == 'C') correctAnswer = _optCController.text;
      else if (_selectedCorrectOption == 'D') correctAnswer = _optDController.text;
    }

    final newQuestion = Question(
      text: _questionController.text,
      type: _selectedType,
      program: _selectedProgram,
      className: _selectedClass,
      subject: _selectedSubject,
      options: options,
      correctAnswer: correctAnswer,
      marks: _marksController.text,
    );

    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('question_bank_data');
    List<dynamic> allQuestions = savedData != null ? json.decode(savedData) : [];

    allQuestions.add(newQuestion.toMap());
    await prefs.setString('question_bank_data', json.encode(allQuestions));

    _questionController.clear();
    _marksController.clear();
    _optAController.clear();
    _optBController.clear();
    _optCController.clear();
    _optDController.clear();
    
    _loadQuestions();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Question saved!")),
      );
    }
  }

  Future<void> _deleteQuestion(int index) async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('question_bank_data');
    if (savedData != null) {
      List<dynamic> allQuestions = json.decode(savedData);
      allQuestions.removeAt(index);
      await prefs.setString('question_bank_data', json.encode(allQuestions));
      _loadQuestions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Question deleted")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Questions")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Program Dropdown
                  const Text("Program Type", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedProgram,
                    items: _programClasses.keys.map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value.toUpperCase()));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedProgram = val!;
                        _selectedClass = _programClasses[_selectedProgram]![0];
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  // Class Dropdown
                  const Text("Class", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedClass,
                    items: _programClasses[_selectedProgram]!.map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text("Class $value"));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedClass = val),
                  ),
                  const SizedBox(height: 10),

                  // Subject Dropdown
                  const Text("Subject", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedSubject,
                    items: _subjects.map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedSubject = val!),
                  ),
                  const SizedBox(height: 10),

                  // Question Type Dropdown
                  const Text("Question Type", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedType,
                    items: ['Subjective', 'MCQ'].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedType = val!),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _questionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Question Text",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Marks Field (Now visible for both types)
                  TextField(
                    controller: _marksController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Marks", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),

                  if (_selectedType == 'MCQ') ...[
                    _buildOptionField(_optAController, "Option A"),
                    const SizedBox(height: 5),
                    _buildOptionField(_optBController, "Option B"),
                    const SizedBox(height: 5),
                    _buildOptionField(_optCController, "Option C"),
                    const SizedBox(height: 5),
                    _buildOptionField(_optDController, "Option D"),
                    const SizedBox(height: 10),
                    const Text("Correct Option"),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedCorrectOption,
                      items: ['A', 'B', 'C', 'D'].map((v) => DropdownMenuItem(value: v, child: Text("Option $v"))).toList(),
                      onChanged: (v) => setState(() => _selectedCorrectOption = v!),
                    ),
                  ],

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _saveQuestion,
                      child: const Text("Save Question"),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 2),
            const Text("Existing Questions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _savedQuestions.length,
              itemBuilder: (context, index) {
                final q = _savedQuestions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text(q['text'] ?? ""),
                    subtitle: Text("${q['type']} | Marks: ${q['marks'] ?? 'N/A'} | ${q['program']} | Class ${q['className']} | ${q['subject']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteQuestion(index),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true),
    );
  }
}
