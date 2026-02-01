class Question {
  final String text;
  final String? imagePath;
  final String type; // 'MCQ', 'Subjective', or 'Bank'
  final List<String>? options;
  final String? correctAnswer;

  Question({
    required this.text,
    this.imagePath,
    required this.type,
    this.options,
    this.correctAnswer,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'imagePath': imagePath,
      'type': type,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      text: map['text'] ?? '',
      imagePath: map['imagePath'],
      type: map['type'] ?? 'Bank',
      options: map['options'] != null ? List<String>.from(map['options']) : null,
      correctAnswer: map['correctAnswer'],
    );
  }
}
