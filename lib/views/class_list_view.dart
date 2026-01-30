import 'package:flutter/material.dart';
import 'subject_list_view.dart';

class ClassListView extends StatelessWidget {
  const ClassListView({super.key});

  final classes = const [
    "Class 11",
    "Class 12",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Classes")),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(classes[i]),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SubjectListView()),
            );
          },
        ),
      ),
    );
  }
}
