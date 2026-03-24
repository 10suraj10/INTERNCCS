import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/exercise_viewmodel.dart';
import '../viewmodels/exam_viewmodel.dart';
import '../models/program_model.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _titleController = TextEditingController();
  
  int? _selectedProgramId;
  String? _selectedClass;
  String? _selectedSubject;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamViewModel>().fetchFilterData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final examVm = context.watch<ExamViewModel>();
    final exerciseVm = context.watch<ExerciseViewModel>();

    // Initial default selections
    if (_selectedProgramId == null && examVm.bankPrograms.isNotEmpty) {
      _selectedProgramId = examVm.bankPrograms.first.id;
      _updateDefaultClass(examVm.bankPrograms.first.programType);
    }
    if (_selectedSubject == null && examVm.subjects.isNotEmpty) {
      _selectedSubject = examVm.subjects.first['subject_name'];
    }

    final currentProgram = examVm.bankPrograms.firstWhere(
      (p) => p.id == _selectedProgramId, 
      orElse: () => examVm.bankPrograms.isNotEmpty ? examVm.bankPrograms.first : Datum(id: -1, programType: '', programTypeCode: '', status: '', createdBy: 0, updatedBy: 0, createdAt: DateTime.now(), updatedAt: DateTime.now())
    );
    final classList = _programToClasses[currentProgram.programType] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Exercises")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Exercise Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Program Dropdown
            DropdownButtonFormField<int>(
              value: _selectedProgramId,
              hint: const Text("Select Program"),
              items: examVm.bankPrograms.map((p) {
                return DropdownMenuItem(value: p.id, child: Text(p.programType));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedProgramId = val;
                  final p = examVm.bankPrograms.firstWhere((p) => p.id == val);
                  _updateDefaultClass(p.programType);
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Program"),
            ),
            const SizedBox(height: 16),

            // Class Dropdown
            DropdownButtonFormField<String>(
              value: _selectedClass,
              hint: const Text("Select Class"),
              items: classList.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (val) => setState(() => _selectedClass = val),
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Class"),
            ),
            const SizedBox(height: 16),

            // Subject Dropdown
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              hint: const Text("Select Subject"),
              items: examVm.subjects.map((s) {
                final name = s['subject_name'] as String;
                return DropdownMenuItem(value: name, child: Text(name));
              }).toList(),
              onChanged: (val) => setState(() => _selectedSubject = val),
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Subject"),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isNotEmpty) {
                    exerciseVm.addExercise(
                      title: _titleController.text,
                      program: currentProgram.programType,
                      className: _selectedClass,
                      subject: _selectedSubject,
                    );
                    _titleController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Exercise added!")),
                    );
                  }
                },
                child: const Text("Add Exercise"),
              ),
            ),
            const Divider(height: 40),
            const Text("Saved Exercises", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: exerciseVm.exercises.length,
                itemBuilder: (context, index) {
                  final ex = exerciseVm.exercises[index];
                  return Card(
                    child: ListTile(
                      title: Text(ex.title),
                      subtitle: Text("${ex.program ?? ''} - ${ex.className ?? ''} - ${ex.subject ?? ''}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => exerciseVm.deleteExercise(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateDefaultClass(String programType) {
    if (_programToClasses.containsKey(programType)) {
      _selectedClass = _programToClasses[programType]!.first;
    } else {
      _selectedClass = null;
    }
  }
}
