import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:satnusa_test/constants/images.dart';
import '../constants/colors.dart';
import '../constants/text_style.dart';
import '../models/course.dart';
import '../models/material.dart';
import '../models/quiz.dart';
import '../utils/format_date.dart';
import '../widgets/material_tile.dart';
import 'course/quiz_page.dart';
import 'course/video_detail_page.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  void _updateQuizScore(Quiz updatedQuiz) {
    setState(() {
      final index =
          widget.course.quizzes.indexWhere((q) => q.title == updatedQuiz.title);
      if (index != -1) {
        widget.course.quizzes[index] = updatedQuiz;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
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
            // Course image with better error handling
            _buildCourseImage(),
            const SizedBox(height: 16),

            // Course title
            Text(
              course.title,
              style: AppTextStyle.headingBlack.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 12),

            // Course duration
            _buildDurationInfo(),
            const SizedBox(height: 16),

            // Course description
            _buildDescriptionSection(),
            const SizedBox(height: 16),

            // Trainer info
            _buildTrainerCard(),
            const SizedBox(height: 16),

            // Course content section
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          widget.course.courseImageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationInfo() {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 24, color: AppColors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Waktu Pengerjaan", style: AppTextStyle.title),
            const SizedBox(height: 4),
            Text(
              '${formatDate(widget.course.startDate)} - ${formatDate(widget.course.endDate)}',
              style: AppTextStyle.title,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: AppTextStyle.label.copyWith(fontSize: 18)),
        const SizedBox(height: 8),
        Text(
          widget.course.description,
          style: AppTextStyle.subTitle.copyWith(fontSize: 14),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildTrainerCard() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.course.trainer.imageUrl),
              onBackgroundImageError: (_, __) => const Icon(Icons.person),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.course.trainer.name,
                    style: AppTextStyle.headingThird,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.course.trainer.title,
                    style: AppTextStyle.subTitle.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Course', style: AppTextStyle.label.copyWith(fontSize: 18)),
        const SizedBox(height: 8),
        ..._buildCourseContentList(),
      ],
    );
  }

  List<Widget> _buildCourseContentList() {
    final items = <Widget>[];

    // Add materials
    for (var material in widget.course.materials) {
      items.add(
        MaterialTile(
          material: material,
          onConfirmed: () => _navigateToVideo(material),
        ),
      );
      items.add(const SizedBox(height: 8));
    }

    // Add quizzes
    for (var quiz in widget.course.quizzes) {
      items.add(_buildQuizTile(quiz));
      items.add(const SizedBox(height: 8));
    }

    return items;
  }

  void _navigateToVideo(CourseMaterial material) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoDetailPage(
          youtubeUrl: material.youtubeUrl,
          onFinished: () {
            setState(() {
              final index = widget.course.materials.indexOf(material);
              if (index != -1) {
                final updated = CourseMaterial(
                  title: material.title,
                  youtubeUrl: material.youtubeUrl,
                  duration: material.duration,
                  progress: 1.0,
                );
                widget.course.materials[index] = updated;
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildQuizTile(Quiz quiz) {
    final isCompleted = quiz.score > 0; // Check if score is greater than 0
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: SvgPicture.asset(MyIcons.quiz),
        title: Text(quiz.title, style: AppTextStyle.title),
        subtitle: Text(
          isCompleted ? 'Nilai: ${quiz.score}' : 'Belum dikerjakan',
          style: TextStyle(
            color: isCompleted
                ? (quiz.score >= 50 ? Colors.green : Colors.red)
                : Colors.grey,
          ),
        ),
        trailing: isCompleted
            ? Icon(
                Icons.check_circle,
                color: quiz.score >= 50 ? Colors.green : Colors.red,
              )
            : const Icon(Icons.arrow_forward_ios, size: 16),
        // Di dalam _buildQuizTile:
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuizPage(quiz: quiz),
            ),
          );

          if (result != null && result is Quiz) {
            setState(() {
              // Update quiz di list course
              final index = widget.course.quizzes
                  .indexWhere((q) => q.title == result.title);
              if (index != -1) {
                widget.course.quizzes[index] = result;
              }
            });
          }
        },
      ),
    );
  }
}
