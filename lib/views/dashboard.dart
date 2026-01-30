import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/exam_viewmodel.dart';
import 'exam_list_view.dart';
import 'program_list_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthViewModel>();
    final exams = context.watch<ExamViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Student Dashboard",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Welcome back",
                          style: TextStyle(color: Colors.grey)),
                    ]),
                TextButton.icon(
                    onPressed: () => auth.logout(),
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout")),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProgramListView()),
                );
              },
              child: const Text("Start Exam"),
            ),
          ),

          const SizedBox(height: 16),

          // CONTENT
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)),
              child: tab == 0 ? const ExamListView() : _results(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _results() {
    return const Center(
        child: Text("No results yet", style: TextStyle(color: Colors.grey)));
  }
}
