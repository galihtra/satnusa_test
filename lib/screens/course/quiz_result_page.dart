import 'package:flutter/material.dart';
import 'package:satnusa_test/constants/colors.dart';

import '../../constants/text_style.dart';
import '../../models/quiz.dart';

class QuizResultPage extends StatelessWidget {
  final Quiz quiz;
  final int remainingAttempts;
  final VoidCallback? onRetry;

  const QuizResultPage({
    Key? key,
    required this.quiz,
    required this.remainingAttempts,
    this.onRetry,
  }) : super(key: key);

   bool get isPassed => quiz.score >= 90; 

  @override
  Widget build(BuildContext context) {
    final imageAsset =
        isPassed ? 'assets/images/success.png' : 'assets/images/fail.png';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Nilai Quiz', style: AppTextStyle.heading),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                isPassed
                    ? "Selamat, kamu berhasil dalam quiz kali ini"
                    : "Maaf, kamu belum berhasil dalam quiz kali ini",
                textAlign: TextAlign.center,
                style: AppTextStyle.headingBlack,
              ),
            ),
            const SizedBox(height: 16),
            Image.asset(imageAsset, height: 150),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.background,
              ),
              child: Column(
                children: [
                  Text(
                    isPassed ? "LULUS !" : "TIDAK LULUS !",
                    style: AppTextStyle.headingBlack,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Nilai Kamu",
                    style: AppTextStyle.label,
                  ),
                  Text(
                    "${quiz.score}",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: isPassed ? Colors.green : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            if (!isPassed && remainingAttempts > 0)
              Card(
                elevation: 0,
                color: AppColors.background,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info,
                        color: AppColors.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Info",
                            style: AppTextStyle.headingFourth,
                          ),
                          Text(
                            "Kesempatan kamu sisa ${remainingAttempts}x lagi",
                            style: AppTextStyle.label,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            const Spacer(),
            if (!isPassed && remainingAttempts > 0)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Kerjakan Quiz Lagi",
                      style: AppTextStyle.ya,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Kembali ke Detail Course",
                    style: AppTextStyle.tidak,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
