import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:satnusa_test/constants/text_style.dart';
import 'package:satnusa_test/models/quiz.dart';
import '../../constants/colors.dart';
import 'quiz_result_page.dart';

class QuizPage extends StatefulWidget {
  final Quiz quiz;

  const QuizPage({Key? key, required this.quiz}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Map<int, int> _selectedAnswers = {};
  int _attempts = 0;

  void _resetQuiz() {
    setState(() {
      _selectedAnswers.clear(); // Reset jawaban yang dipilih
      _attempts++; // Tambah jumlah percobaan
    });
  }

  void _submitQuiz() async {
  int calculatedScore = 0;
  final totalQuestions = widget.quiz.questions.length;

  // Hitung score
  for (int i = 0; i < totalQuestions; i++) {
    if (_selectedAnswers[i] != null) {
      final selectedAnswer = widget.quiz.questions[i].options[_selectedAnswers[i]!];
      if (selectedAnswer == widget.quiz.questions[i].correct) {
        calculatedScore += (100 ~/ totalQuestions);
      }
    }
  }

  final updatedQuiz = widget.quiz.copyWith(score: calculatedScore);

  try {
    await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(updatedQuiz.title)
        .set(updatedQuiz.toMap(), SetOptions(merge: true));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultPage(
          quiz: updatedQuiz, 
          remainingAttempts: 2 - _attempts,
          onRetry: _attempts < 2 ? _resetQuiz : null,
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menyimpan score: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitConfirmation(context);
        return false; 
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Quiz', style: AppTextStyle.heading),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _showExitConfirmation(context),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.quiz.questions.length,
          itemBuilder: (context, index) {
            final question = widget.quiz.questions[index];
            return Card(
              color: AppColors.background,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${index + 1}. ${question.question} *",
                        style: AppTextStyle.label),
                    const SizedBox(height: 8),
                    ...List.generate(question.options.length, (optIndex) {
                      return RadioListTile<int>(
                        value: optIndex,
                        activeColor: AppColors.primary,
                        groupValue: _selectedAnswers[index],
                        onChanged: (val) {
                          setState(() {
                            _selectedAnswers[index] = val!;
                          });
                        },
                        title: Text(question.options[optIndex]),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _selectedAnswers.length == widget.quiz.questions.length
                ? _submitQuiz
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Submit',
                style: AppTextStyle.ya,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Apakah Anda yakin ingin keluar dari kuis ini?",
                style: AppTextStyle.headingSecond,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.info, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Jika Anda menutup halaman kuis sebelum menyelesaikannya, semua jawaban akan hilang dan tidak tersimpan.",
                        style: AppTextStyle.alert,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.background,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Batalkan",
                          style: AppTextStyle.tidak,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); 
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Tutup Kuis",
                          style: AppTextStyle.ya,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
