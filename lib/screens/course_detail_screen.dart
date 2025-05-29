import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_style.dart';
import '../models/course.dart';
import '../models/material.dart';
import '../models/quiz.dart';
import '../utils/format_date.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Detail Course', style: AppTextStyle.heading),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                course.courseImageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(height: 180, color: Colors.grey[300]),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(course.title,
                style: AppTextStyle.label.copyWith(
                  fontSize: 18,
                )),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.access_time,
                  size: 30,
                  color: AppColors.grey,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Waktu Pengerjaan",
                      style: AppTextStyle.title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatDate(course.startDate)} - ${formatDate(course.endDate)}',
                      style: AppTextStyle.title,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Description',
                style: AppTextStyle.label.copyWith(
                  fontSize: 18,
                )),
            const SizedBox(height: 4),
            Text(
              course.description,
              textAlign: TextAlign.justify,
              style: AppTextStyle.subTitle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 6,
              ),
              elevation: 0,
              color: AppColors.background,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(course.trainer.imageUrl),
                  radius: 32,
                ),
                title:
                    Text(course.trainer.name, style: AppTextStyle.headingThird),
                subtitle: Text(
                  course.trainer.title,
                  style: AppTextStyle.subTitle.copyWith(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Course', style: AppTextStyle.label),
            const SizedBox(height: 8),

            // Course materials & quizzes
            ..._buildCourseList(course),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCourseList(Course course) {
    List<Widget> items = [];

    final totalItems = [
      ...course.materials.map((m) => {'type': 'material', 'data': m}),
      ...course.quizzes.map((q) => {'type': 'quiz', 'data': q})
    ];

    for (var item in totalItems) {
      if (item['type'] == 'material') {
        final m = item['data'] as CourseMaterial;
        items.add(_buildMaterialTile(m));
      } else {
        final q = item['data'] as Quiz;
        items.add(_buildQuizTile(q));
      }
    }

    return items;
  }

  Widget _buildMaterialTile(CourseMaterial material) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.play_circle_fill, size: 30),
        title: Text(material.title, style: AppTextStyle.title),
        subtitle: Text(material.duration),
        trailing: material.progress >= 1.0
            ? const Icon(Icons.check_circle, color: Colors.green)
            : CircularProgressIndicator(value: material.progress),
      ),
    );
  }

  Widget _buildQuizTile(Quiz quiz) {
    final bool isCompleted = quiz.score != null;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.quiz, size: 30),
        title: Text(quiz.title, style: AppTextStyle.title),
        subtitle: Text('Nilai : ${quiz.score?.toString() ?? '-'}',
            style: TextStyle(
                color: (quiz.score != null && quiz.score! < 50)
                    ? Colors.red
                    : Colors.black)),
        trailing: isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const SizedBox.shrink(),
      ),
    );
  }
}
