import 'package:flutter/material.dart';
import 'package:satnusa_test/constants/text_style.dart';

class CardTrainingProgress extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const CardTrainingProgress({
    super.key,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
            ),
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 6),
              ),
              child: Center(
                child: Text(count, style: AppTextStyle.headingSecond),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: AppTextStyle.headingThird,
        ),
      ],
    );
  }
}
