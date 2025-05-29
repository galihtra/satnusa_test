import 'package:satnusa_test/models/material.dart';
import 'package:satnusa_test/models/quiz.dart';
import 'package:satnusa_test/models/trainer.dart';

class Course {
  final String? id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String courseImageUrl;
  final Trainer trainer;
  final List<CourseMaterial> materials;
  final List<Quiz> quizzes;

  Course({
    this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.courseImageUrl,
    required this.trainer,
    required this.materials,
    required this.quizzes,
  });

  factory Course.fromMap(Map<String, dynamic> map, String id) {
    return Course(
      id: id,
      title: map['title'],
      description: map['description'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      courseImageUrl: map['courseImageUrl'],
      trainer: Trainer.fromMap(map['trainer']),
      materials: List<CourseMaterial>.from(
          map['materials']?.map((x) => CourseMaterial.fromMap(x))),
      quizzes: List<Quiz>.from(map['quizzes']?.map((x) => Quiz.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'courseImageUrl': courseImageUrl,
      'trainer': trainer.toMap(),
      'materials': materials.map((m) => m.toMap()).toList(),
      'quizzes': quizzes.map((q) => q.toMap()).toList(),
    };
  }
}
