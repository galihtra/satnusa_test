import 'package:flutter/material.dart';

import '../../constants/text_style.dart';
import '../../widgets/card_category.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Safety', style: AppTextStyle.heading),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: const [
          CardCategory(
            imagePath: 'assets/images/img_banner.png',
            title: 'Pentingnya APD: Bukan Sekedar Formalitas',
            subtitle:
                'Alat Pelindung Diri (APD) adalah perlengkapan yang digunakan oleh pekerja untuk melindungi tu...',
          ),
          SizedBox(height: 12),
          CardCategory(
            imagePath: 'assets/images/img_banner.png',
            title: 'Jangan Abaikan Keselamatan: Edukasi K3 untuk Semua',
            subtitle:
                'Membangun kesadaran bahwa Keselamatan dan Kesehatan Kerja (K3) bukan hanya tanggung jaw...',
          ),
        ],
      ),
    );
  }
}
