import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/images.dart';
import '../models/material.dart';
import '../constants/colors.dart';
import '../constants/text_style.dart';

class MaterialTile extends StatelessWidget {
  final CourseMaterial material;
  final VoidCallback onConfirmed;

  const MaterialTile({
    Key? key,
    required this.material,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showConfirmationSheet(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SvgPicture.asset(MyIcons.play),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(material.title, style: AppTextStyle.title),
                    const SizedBox(height: 4),
                    Text('Durasi: ${material.duration}',
                        style: AppTextStyle.subTitle),
                  ],
                ),
              ),
              if (material.progress >= 1.0)
                const Icon(Icons.check_circle, color: Colors.green)
              else
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    value: material.progress,
                    strokeWidth: 3,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Apakah anda ingin memulai materi ini?',
                style: AppTextStyle.headingBlack,
              ),
              const SizedBox(height: 12),
              const Text(
                'Ketuk Ya untuk memulai materi',
                style: AppTextStyle.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: const Text(
                          'Tidak',
                          style: AppTextStyle.tidak,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.background,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirmed();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Ya',
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
