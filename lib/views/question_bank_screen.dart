import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question_model.dart';
import 'dart:convert';

class QuestionBankScreen extends StatefulWidget {
  const QuestionBankScreen({super.key});

  @override
  State<QuestionBankScreen> createState() => _QuestionBankScreenState();
}

class _QuestionBankScreenState extends State<QuestionBankScreen> {
  final _questionController = TextEditingController();
  final _marksController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final List<Map<String, dynamic>> _fullBank = [];

  @override
  void initState() {
    super.initState();
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('question_bank_data');
    if (savedData != null) {
      setState(() {
        _fullBank.clear();
        _fullBank.addAll(List<Map<String, dynamic>>.from(json.decode(savedData)));
      });
    }
  }

  Future<void> _saveAllToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('question_bank_data', json.encode(_fullBank));
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _addQuestionToList() async {
    if (_questionController.text.isEmpty) return;

    final newQuest = Question(
      text: _questionController.text,
      marks: _marksController.text,
      imagePath: _selectedImage?.path,
      type: 'Bank',
    );

    setState(() {
      _fullBank.add(newQuest.toMap());
      _questionController.clear();
      _marksController.clear();
      _selectedImage = null;
    });

    await _saveAllToStorage();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Question added to bank!")),
      );
    }
  }

  void _deleteQuestion(int index) async {
    setState(() {
      _fullBank.removeAt(index);
    });
    await _saveAllToStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Question Bank Builder")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _questionController,
                  decoration: const InputDecoration(
                    labelText: "Enter Question Text",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _marksController,
                  decoration: const InputDecoration(
                    labelText: "Marks",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                if (_selectedImage != null)
                  Container(
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Image.file(_selectedImage!),
                  ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text("Add Image"),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white),
                      onPressed: _addQuestionToList,
                      child: const Text("Add to Bank"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(thickness: 2),
          Expanded(
            child: _fullBank.isEmpty
                ? const Center(child: Text("No questions in the bank yet."))
                : ListView.builder(
                    itemCount: _fullBank.length,
                    itemBuilder: (context, index) {
                      final item = _fullBank[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(child: Text("${index + 1}")),
                          title: Text(item['text'] ?? ""),
                          subtitle: Text("Type: ${item['type'] ?? 'Bank'} | Marks: ${item['marks'] ?? '0'}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteQuestion(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
