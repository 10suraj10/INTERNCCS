import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'add_question_screen.dart';
import 'question_bank_screen.dart';
import 'add_exercise_screen.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        actions: [
          TextButton.icon(
            onPressed: () => context.read<AuthViewModel>().logout(),
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Management Tools",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildMenuCard(
                    context,
                    "Add Questions",
                    Icons.description,
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddQuestionScreen()),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    "Manage Exercises",
                    Icons.fitness_center,
                    Colors.purple,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddExerciseScreen()),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    "Question Bank",
                    Icons.storage,
                    Colors.orange,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QuestionBankScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
