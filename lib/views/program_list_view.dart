import 'package:flutter/material.dart';

import 'class_list_view.dart';

class ProgramListView extends StatelessWidget {
  const ProgramListView({super.key});

  final programs = const [
    "Science Program",
    "Management Program",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Programs")),
      body: ListView.builder(
        itemCount: programs.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(programs[i]),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClassListView()),
            );
          },
        ),
      ),
    );
  }
}
