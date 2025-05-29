class Question {
  final String question;
  final String type; // 'single' or 'multiple'
  final List<String> options;
  final dynamic correct;

  Question({
    required this.question,
    required this.type,
    required this.options,
    required this.correct,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'] ?? '',
      type: map['type'] ?? 'single',
      options: List<String>.from(map['options'] ?? []),
      correct: map['correct'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'type': type,
      'options': options,
      'correct': correct,
    };
  }
}