import 'package:satnusa_test/models/question.dart';

class Quiz {
  final String title;
  final List<Question> questions;
  final int? score;

  Quiz({
    required this.title,
    required this.questions,
    this.score
  });

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      title: map['title'] ?? '',
      questions: List<Question>.from(
        (map['questions'] ?? []).map((x) => Question.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'questions': questions.map((q) => q.toMap()).toList(),
    };
  }
}