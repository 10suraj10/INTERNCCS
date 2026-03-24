import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/program_model.dart';
import '../models/question_model.dart';
import '../viewmodels/exam_viewmodel.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();
  
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final _optAController = TextEditingController();
  final _optBController = TextEditingController();
  final _optCController = TextEditingController();
  final _optDController = TextEditingController();
  String _selectedCorrectOption = 'A';

  List<Map<String, dynamic>> _savedQuestions = [];

  // Use IDs for selection to avoid reference comparison issues with Model objects
  int? _selectedProgramId;
  String? _selectedClass;
  String? _selectedSubject;
  String _selectedType = 'Subjective';
  bool _isForBank = false; 

  // Exhaustive Program to Class mapping
  final Map<String, List<String>> _programToClasses = {
    'Primary': ['Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8'],
    'Secondary': ['Class 9', 'Class 10'],
    '+2': ['Class 11', 'Class 12'],
    'Bachelor': ['1st Year', '2nd Year', '3rd Year', '4th Year'],
    'Bachelor Program': ['1st Year', '2nd Year', '3rd Year', '4th Year'],
    'Masters Program': ['1st Year', '2nd Year'],
    'Masters': ['1st Year', '2nd Year'],
  };

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ExamViewModel>().fetchFilterData();
    });
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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _saveQuestion() async {
    if (_questionController.text.isEmpty) return;
    
    final exams = context.read<ExamViewModel>();
    final program = exams.bankPrograms.firstWhere((p) => p.id == _selectedProgramId, orElse: () => exams.bankPrograms.first);

    List<String>? options;
    String? correctAnswer;

    if (_selectedType == 'MCQ') {
      options = [_optAController.text, _optBController.text, _optCController.text, _optDController.text];
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
      program: program.programType,
      className: _selectedClass,
      subject: _selectedSubject,
      options: options,
      correctAnswer: correctAnswer,
      marks: _marksController.text,
      imagePath: _selectedImage?.path,
      isForBank: _isForBank,
    );

    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('question_bank_data');
    List<dynamic> allQuestions = savedData != null ? json.decode(savedData) : [];

    allQuestions.add(newQuestion.toMap());
    await prefs.setString('question_bank_data', json.encode(allQuestions));

    if (mounted) {
      context.read<ExamViewModel>().loadQuestionBank();
    }

    _questionController.clear();
    _marksController.clear();
    _optAController.clear();
    _optBController.clear();
    _optCController.clear();
    _optDController.clear();
    setState(() {
      _selectedImage = null;
      _isForBank = false;
    });
    
    _loadQuestions();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Question saved!")));
    }
  }

  Future<void> _deleteQuestion(int index) async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('question_bank_data');
    if (savedData != null) {
      List<dynamic> allQuestions = json.decode(savedData);
      allQuestions.removeAt(index);
      await prefs.setString('question_bank_data', json.encode(allQuestions));
      if (mounted) context.read<ExamViewModel>().loadQuestionBank();
      _loadQuestions();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Question deleted")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final exams = context.watch<ExamViewModel>();
    
    // Auto-select first program if nothing is selected yet
    if (_selectedProgramId == null && exams.bankPrograms.isNotEmpty) {
      _selectedProgramId = exams.bankPrograms.first.id;
      final pType = exams.bankPrograms.first.programType;
      if (_programToClasses.containsKey(pType)) {
        _selectedClass = _programToClasses[pType]!.first;
      }
    }
    
    // Auto-select first subject if nothing is selected yet
    if (_selectedSubject == null && exams.subjects.isNotEmpty) {
      _selectedSubject = exams.subjects.first['subject_name'];
    }

    final currentProgram = exams.bankPrograms.firstWhere((p) => p.id == _selectedProgramId, orElse: () => exams.bankPrograms.isNotEmpty ? exams.bankPrograms.first : Datum(id: -1, programType: '', programTypeCode: '', status: '', createdBy: 0, updatedBy: 0, createdAt: DateTime.now(), updatedAt: DateTime.now()));
    final classList = _programToClasses[currentProgram.programType] ?? [];

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
                  const Text("Program Type", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<int>(
                    isExpanded: true,
                    hint: const Text("Select Program"),
                    value: _selectedProgramId,
                    items: exams.bankPrograms.map((program) {
                      return DropdownMenuItem<int>(value: program.id, child: Text(program.programType));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedProgramId = val;
                        final p = exams.bankPrograms.firstWhere((p) => p.id == val);
                        if (_programToClasses.containsKey(p.programType)) {
                          _selectedClass = _programToClasses[p.programType]!.first;
                        } else {
                          _selectedClass = null;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  const Text("Class", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text("Select Class"),
                    value: _selectedClass,
                    items: classList.map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedClass = val),
                  ),
                  const SizedBox(height: 10),

                  const Text("Subject", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text("Select Subject"),
                    value: _selectedSubject,
                    items: exams.subjects.map((s) {
                      final name = s['subject_name'] as String;
                      return DropdownMenuItem<String>(value: name, child: Text(name));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedSubject = val),
                  ),
                  const SizedBox(height: 10),

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
                    decoration: const InputDecoration(labelText: "Question Text", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),

                  if (_selectedImage != null)
                    Container(height: 100, margin: const EdgeInsets.only(bottom: 10), child: Image.file(_selectedImage!)),

                  ElevatedButton.icon(onPressed: _pickImage, icon: const Icon(Icons.add_a_photo), label: const Text("Add Image")),
                  const SizedBox(height: 10),

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

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Push to Question Bank", style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Switch(value: _isForBank, onChanged: (val) => setState(() => _isForBank = val)),
                    ],
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(onPressed: _saveQuestion, child: const Text("Save Question")),
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
                final bool isBank = q['isForBank'] ?? false;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: q['imagePath'] != null
                        ? SizedBox(width: 50, child: Image.file(File(q['imagePath']), fit: BoxFit.cover))
                        : const Icon(Icons.description),
                    title: Text(q['text'] ?? ""),
                    subtitle: Text("${q['type']} | Bank: ${isBank ? 'Yes' : 'No'} | Marks: ${q['marks'] ?? 'N/A'} | ${q['program']} | Class ${q['className']} | ${q['subject']}"),
                    trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteQuestion(index)),
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
