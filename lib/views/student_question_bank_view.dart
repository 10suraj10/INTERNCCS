import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/exam_viewmodel.dart';
import '../models/question_model.dart';
import 'dart:io';

class StudentQuestionBankView extends StatefulWidget {
  const StudentQuestionBankView({super.key});

  @override
  State<StudentQuestionBankView> createState() => _StudentQuestionBankViewState();
}

class _StudentQuestionBankViewState extends State<StudentQuestionBankView> {
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
    Future.microtask(() => context.read<ExamViewModel>().fetchFilterData());
  }

  @override
  Widget build(BuildContext context) {
    final exams = context.watch<ExamViewModel>();

    // Filtering Logic
    final filteredQuestions = exams.bankQuestions.where((q) {
      if (!q.isForBank) return false;

      if (exams.selectedProgram != null) {
        String filterVal = exams.selectedProgram.programType.toString().toLowerCase();
        String qVal = q.program?.toLowerCase() ?? "";
        if (!qVal.contains(filterVal.split(' ')[0]) && !filterVal.contains(qVal)) return false;
      }

      if (exams.selectedClass != null) {
        String filterVal = exams.selectedClass.toString().toLowerCase();
        String qVal = q.className?.toLowerCase() ?? "";
        if (!qVal.contains(filterVal) && !filterVal.contains(qVal)) return false;
      }

      if (exams.selectedSubject != null) {
        String filterVal = exams.selectedSubject is Map 
            ? exams.selectedSubject['subject_name'].toString().toLowerCase()
            : exams.selectedSubject.toString().toLowerCase();
        String qVal = q.subject?.toLowerCase() ?? "";
        if (!qVal.contains(filterVal) && !filterVal.contains(qVal)) return false;
      }

      return true;
    }).toList();

    List<String> classList = [];
    if (exams.selectedProgram != null) {
      classList = _programToClasses[exams.selectedProgram.programType] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Question Bank"),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              exams.setSelectedProgram(null);
              exams.setSelectedClass(null);
              exams.setSelectedSubject(null);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                _buildDropdown(
                  label: "Select Program",
                  value: exams.selectedProgram,
                  items: exams.bankPrograms,
                  onChanged: (val) {
                    exams.setSelectedProgram(val);
                    exams.setSelectedClass(null);
                  },
                  itemText: (item) => item.programType,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "Class", border: OutlineInputBorder(), isDense: true, filled: true, fillColor: Color(0xFFFAFAFA)),
                        value: (exams.selectedClass is String && classList.contains(exams.selectedClass)) ? exams.selectedClass : null,
                        items: classList.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (val) => exams.setSelectedClass(val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdown(
                        label: "Subject",
                        value: exams.selectedSubject,
                        items: exams.subjects,
                        onChanged: (val) => exams.setSelectedSubject(val),
                        itemText: (item) => item is Map ? item['subject_name'] : item.toString(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredQuestions.isEmpty
                ? const Center(child: Text("No questions found for this selection."))
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Container(
                  width: 800, // A4-like width (adjusts on web)
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.05),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "QUESTION BANK",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),

                      const SizedBox(height: 20),

                      ...List.generate(filteredQuestions.length, (index) {
                        return _buildPaperQuestion(filteredQuestions[index], index + 1);
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required dynamic value,
    required List<dynamic> items,
    required Function(dynamic) onChanged,
    required String Function(dynamic) itemText,
  }) {
    final bool valueIsValid = value == null || items.any((item) => item == value);
    final dynamic safeValue = valueIsValid ? value : null;

    return DropdownButtonFormField<dynamic>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
        isDense: true,
      ),
      isExpanded: true,
      value: safeValue,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(itemText(item), overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildPaperQuestion(Question q, int number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Q$number. ${q.text}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          if (q.imagePath != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Image.file(
                File(q.imagePath!),
                height: 150,
              ),
            ),

          if (q.type == 'MCQ' && q.options != null)
            Column(
              children: q.options!.asMap().entries.map((entry) {
                final i = entry.key;
                final opt = entry.value;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        "${String.fromCharCode(65 + i)}. ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Text(opt)),
                    ],
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    );
  }
}
