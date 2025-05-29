import 'package:flutter/material.dart';
import 'package:satnusa_test/constants/colors.dart';
import 'package:satnusa_test/constants/images.dart';
import '../../constants/text_style.dart';
import '../widgets/card_assigned_course.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  int selectedIndex = 0;

  final List<String> tabs = ["All", "On Progress", "Completed"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Assigned Course', style: AppTextStyle.heading),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(tabs.length, (index) {
                final isSelected = selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: isSelected
                          ? AppColors.secondary
                          : Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      tabs[index],
                      style: AppTextStyle.headingFifth.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.text,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: [
                // CardAssignedCourse(
                //   image: MyImages.banner,
                //   title: 'Pelatihan K3 dan Identifikasi Bahaya di Tempat Kerja',
                //   progress: 0.1,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
