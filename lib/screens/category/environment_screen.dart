import 'package:flutter/material.dart';

import '../../constants/text_style.dart';
import '../../widgets/card_category.dart';

class EnvironmentScreen extends StatelessWidget {
  const EnvironmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Environment', style: AppTextStyle.heading),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: const [
          CardCategory(
            imagePath: 'assets/images/img_banner.png',
            title: 'Jejakmu Menentukan Bumi: Edukasi Lingkungan untuk Pekerja',
            subtitle:
                'Pelatihan ini bertujuan untuk memberikan pemahaman dasar',
          ),
        ],
      ),
    );
  }
}
