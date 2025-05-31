import 'package:flutter/material.dart';

import '../../constants/text_style.dart';
import '../../widgets/card_category.dart';

class HealtyScreen extends StatelessWidget {
  const HealtyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Healty', style: AppTextStyle.heading),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: const [
          CardCategory(
            imagePath: 'assets/images/img_banner.png',
            title: 'Kerja Sehat, Hidup Hebat: Tips Kesehatan di Tempat Kerja',
            subtitle:
                'Kesehatan bukan hanya urusan rumah atau rumah sakit — lingkungan kerja juga punya peran besar dalam menjaga tubuh dan pikiran tetap fit. Karyawan yang sehat lebih produktif, lebih fokus, dan punya semangat kerja yang lebih tinggi.',
          ),
          SizedBox(height: 12),
          CardCategory(
            imagePath: 'assets/images/img_banner.png',
            title: 'Cegah Lebih Baik: Edukasi Kesehatan Kerja Sehari-hari',
            subtitle:
                'Banyak gangguan kesehatan yang muncul di tempat kerja bukan karena kecelakaan, tapi karena kebiasaan sehari-hari yang tidak sehat. ',
          ),
        ],
      ),
    );
  }
}
