import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:satnusa_test/constants/colors.dart';
import '../constants/images.dart';
import '../constants/text_style.dart';
import '../providers/date_provider.dart';
import '../widgets/card_course.dart';
import '../widgets/card_topic_category.dart';
import '../widgets/card_training_progress.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    dateProvider.fetchCurrentDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('QHSE Training', style: AppTextStyle.heading),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  MyImages.banner,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      MyIcons.warning,
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Consumer<DateProvider>(
                        builder: (context, dateProvider, _) {
                          if (dateProvider.isLoading) {
                            return const Text(
                              'Memuat tanggal...',
                              style: AppTextStyle.headingSecond,
                            );
                          } else if (dateProvider.error != null) {
                            return Text(
                              dateProvider.error!,
                              style: AppTextStyle.headingSecond,
                            );
                          } else {
                            return Text.rich(
                              TextSpan(
                                text: 'Completed your training\n',
                                style: AppTextStyle.headingSecond,
                                children: [
                                  TextSpan(
                                    text:
                                        'Before ${dateProvider.formattedDate}',
                                    style: AppTextStyle.title,
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Training Progress',
                style: AppTextStyle.headingSecond,
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CardTrainingProgress(
                    count: '3',
                    label: 'Enrolled',
                    color: Colors.lightBlue,
                  ),
                  CardTrainingProgress(
                    count: '2',
                    label: 'On Progress',
                    color: Colors.orangeAccent,
                  ),
                  CardTrainingProgress(
                    count: '1',
                    label: 'Completed',
                    color: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Category Topic',
                style: AppTextStyle.headingSecond,
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CardTopicCategory(
                      iconPath: MyIcons.quality, label: 'Quality'),
                  CardTopicCategory(iconPath: MyIcons.health, label: 'Healthy'),
                  CardTopicCategory(iconPath: MyIcons.safety, label: 'Safety'),
                  CardTopicCategory(
                      iconPath: MyIcons.environment, label: 'Environment'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Assigned Course',
                      style: AppTextStyle.headingSecond),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.background,
                      padding: EdgeInsets.zero, // remove default padding
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: [
                          Text('Lainnya', style: AppTextStyle.headingFifth),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right,
                              color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 240,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    SizedBox(width: 16),
                    CardCourse(
                      image: MyImages.banner,
                      title:
                          'Pelatihan K3 dan Identifikasi Bahaya di Tempat Kerja',
                      description:
                          'Pelatihan ini bertujuan untuk memberikan pemahaman dasar me...',
                      progress: 0.1,
                    ),
                    SizedBox(width: 12),
                    CardCourse(
                      image: MyImages.banner,
                      title:
                          'Implementasi Quality Control dan Quality Assurance',
                      description:
                          'Pelatihan ini bertujuan untuk memberikan pemahaman dasar me...',
                      progress: 0.6,
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
