class Exercise {
  final String title;
  final String? program;
  final String? className;
  final String? subject;
  final List<String>? questionIds;

  Exercise({
    required this.title,
    this.program,
    this.className,
    this.subject,
    this.questionIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'program': program,
      'className': className,
      'subject': subject,
      'questionIds': questionIds,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      title: map['title'] ?? '',
      program: map['program'],
      className: map['className'],
      subject: map['subject'],
      questionIds: map['questionIds'] != null ? List<String>.from(map['questionIds']) : null,
    );
  }
}
