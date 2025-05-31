import 'package:flutter/material.dart';

import '../../constants/text_style.dart';
import '../../widgets/card_category.dart';

class QualityScreen extends StatelessWidget {
  const QualityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Quality', style: AppTextStyle.heading),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: const [
          CardCategory(
            imagePath: 'assets/images/img_banner.png',
            title: 'Yuk Kenalan Sama ISO 9001: Standar Mutu Dunia Kerja Modern',
            subtitle:
                'ISO 9001 adalah standar internasional untuk Sistem Manajemen Mutu (SMM) yang diterbitkan oleh International Organization for Standardization (ISO). ',
          ),
        ],
      ),
    );
  }
}
