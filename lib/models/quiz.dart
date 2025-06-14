import 'package:satnusa_test/models/question.dart';

class Quiz {
  final String title;
  final List<Question> questions;
  int score; 

  Quiz({
    required this.title,
    required this.questions,
    this.score = 0, 
  });

  
  Quiz copyWith({int? score}) {
    return Quiz(
      title: title,
      questions: questions,
      score: score ?? this.score,
    );
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      title: map['title'] ?? '',
      questions: List<Question>.from(
        (map['questions'] ?? []).map((x) => Question.fromMap(x)),
      ),
      score: (map['score'] ?? 0).toInt(), 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'questions': questions.map((q) => q.toMap()).toList(),
      'score': score,
    };
  }
}