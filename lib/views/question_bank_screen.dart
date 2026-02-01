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
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // This list will hold the questions added during this session
  final List<Map<String, dynamic>> _tempBank = [];

  Future<void> _saveToStorage(Question newQuestion) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Get existing questions
    String? savedData = prefs.getString('question_bank_data');
    List<dynamic> jsonList = savedData != null ? json.decode(savedData) : [];

    // 2. Add new question
    jsonList.add(newQuestion.toMap());

    // 3. Save back to phone storage
    await prefs.setString('question_bank_data', json.encode(jsonList));
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
      imagePath: _selectedImage?.path, // Save the path string
      type: 'Bank',
    );

    await _saveToStorage(newQuest); // Save to disk!

    setState(() {
      _tempBank.add(newQuest.toMap());
      _questionController.clear();
      _selectedImage = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Question added to local bank!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Question Bank Builder")),
      body: Column(
        children: [
          // TOP PART: Input area
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

                // Show image preview only if an image is picked
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
                      child: const Text("Add to List"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(thickness: 2),

          // BOTTOM PART: The List of questions already added
          Expanded(
            child: ListView.builder(
              itemCount: _tempBank.length,
              itemBuilder: (context, index) {
                final item = _tempBank[index];
                return ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(item['text'] ?? ""),
                  subtitle: item['imagePath'] != null
                      ? const Text("📎 Has Image Attachment",
                          style: TextStyle(color: Colors.blue))
                      : const Text("Text Only"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => setState(() => _tempBank.removeAt(index)),
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
