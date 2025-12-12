
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StudentProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMIS',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainShell(),
    );
  }
}

// Simple provider that holds student info and subject list
class StudentProvider extends ChangeNotifier {
  String name = 'Suraj Shakya';
  String studentId = '2025-0001';
  String department = 'IT';
  String semester = '8';

  final List<String> subjects = [
    'Cloud Computing',
    'Business Intelligence',
    'Digital Economy',
    'IT Entrepreneurship and Management',
  ];

  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }
}

// Main shell with BottomNavigationBar
class MainShell extends StatefulWidget {
  const MainShell({Key? key}) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    IdCardPage(),
    SubjectsPage(),
    InfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMIS'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ID Card'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Subjects'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
        ],
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// Page 1: ID card using Columns and Rows
class IdCardPage extends StatelessWidget {
  const IdCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final student = context.watch<StudentProvider>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    child: Text(student.name.isNotEmpty ? student.name[0] : '?'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('ID: ${student.studentId}'),
                        Text('Dept: ${student.department}'),
                        Text('Semester: ${student.semester}'),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 32),

              // A simple two-column info using Rows inside a Column
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Blood Group'),
                        SizedBox(height: 6),
                        Text('Allergies'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('B+'),
                        SizedBox(height: 6),
                        Text('None'),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }
}

// Page 2: ListView of current semester subjects
class SubjectsPage extends StatelessWidget {
  const SubjectsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<StudentProvider>().subjects;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: subjects.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final s = subjects[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(s),
                );
              },
            ),
          ),


        ],
      ),
    );
  }
}

// Page 3: Basic information page
class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final student = context.watch<StudentProvider>();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Basic Info', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text('Name: ${student.name}'),
          Text('Student ID: ${student.studentId}'),
          Text('Department: ${student.department}'),
          Text('Semester: ${student.semester}'),
        ],
      ),
    );
  }
}
