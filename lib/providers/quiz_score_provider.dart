import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizScoreProvider with ChangeNotifier {
  Map<String, int> _scores = {};

  Map<String, int> get scores => _scores;

  Future<void> fetchScore(String courseId) async {
    final doc = await FirebaseFirestore.instance
        .collection('course_quiz_scores')
        .doc(courseId)
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('score')) {
        _scores[courseId] = data['score'];
        notifyListeners();
      }
    }
  }

  int? getScore(String courseId) => _scores[courseId];
}
