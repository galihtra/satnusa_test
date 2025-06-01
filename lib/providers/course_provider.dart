import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';

class CourseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  Future<void> fetchCourses() async {
    try {
      final querySnapshot = await _firestore.collection('courses').get();
      _courses = querySnapshot.docs
          .map((doc) => Course.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  Future<void> addCourse(Course course) async {
    try {
      // Convert the course to a map including nested objects
      final courseData = course.toMap();

      // Debug print to check the data before sending
      debugPrint('Saving course data: $courseData');

      // Add document to Firestore
      final docRef = await _firestore.collection('courses').add(courseData);

      // Debug print the document ID
      debugPrint('Course saved with ID: ${docRef.id}');

      await fetchCourses(); // Refresh the list
    } catch (e) {
      debugPrint('Error adding course: $e');
      rethrow;
    }
  }

  Future<void> refreshCourse(Course course) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(course.title)
          .get();

      if (doc.exists) {
        final updatedCourse = Course.fromMap({
          ...doc.data()!,
          'trainer': doc.data()!['trainer'] ?? {},
          'materials': doc.data()!['materials'] ?? [],
          'quizzes': doc.data()!['quizzes'] ?? [],
        });

        final index = _courses.indexWhere((c) => c.title == course.title);
        if (index != -1) {
          _courses[index] = updatedCourse;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error refreshing course: $e');
    }
  }

  Future<Course?> getCourseById(String id) async {
    try {
      final doc = await _firestore.collection('courses').doc(id).get();
      if (doc.exists) {
        return Course.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting course: $e');
      return null;
    }
  }
}
