import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              course.courseImageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => 
                Container(height: 200, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              course.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Duration: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${course.startDate} to ${course.endDate}'),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Trainer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(course.trainer.imageUrl),
                radius: 30,
              ),
              title: Text(course.trainer.name),
              subtitle: Text(course.trainer.title),
            ),
            const SizedBox(height: 16),
            const Text('Materials', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...course.materials.map((material) => Card(
              child: ListTile(
                title: Text(material.title),
                subtitle: Text('Duration: ${material.duration}'),
                trailing: CircularProgressIndicator(
                  value: material.progress,
                ),
              ),
            )),
            const SizedBox(height: 16),
            const Text('Quizzes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...course.quizzes.map((quiz) => Card(
              child: ListTile(
                title: Text(quiz.title),
                subtitle: Text('${quiz.questions.length} questions'),
                trailing: const Icon(Icons.quiz),
              ),
            )),
          ],
        ),
      ),
    );
  }
}