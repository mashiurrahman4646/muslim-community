import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/approut.dart';

class LearningUI extends StatelessWidget {
  const LearningUI({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        _buildLearningCard(
          context,
          'SALAH',
          'How to Pray Salah for Beginners',
          'assets/image/learningimage1.png',
          '12:45',
          '1240',
          '89',
          AppColors.maleColor,
          AppRoutes.maleLearningDetails,
        ),
        _buildLearningCard(
          context,
          'QURAN',
          'Understanding the Fatiha',
          'assets/image/learningimage2.png',
          '08:20',
          '342',
          '12',
          const Color(0xFFE57373),
          AppRoutes.maleLearningDetails,
        ),
        _buildLearningCard(
          context,
          'DUAS',
          'Daily Duas Every Muslim Needs',
          'assets/image/learningimage3.png',
          '15:10',
          '890',
          '45',
          const Color(0xFF81C784),
          AppRoutes.maleLearningDetails,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildLearningCard(
    BuildContext context,
    String category,
    String title,
    String imagePath,
    String duration,
    String likes,
    String comments,
    Color categoryColor,
    String route,
  ) {
    return GestureDetector(
      onTap: () => Get.toNamed(route, arguments: {
        'category': category,
        'title': title,
        'imagePath': imagePath,
      }),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.r),
                    topRight: Radius.circular(25.r),
                  ),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.play_arrow, color: Colors.white, size: 30.sp),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      duration,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: categoryColor,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(Icons.favorite_border, size: 16.sp, color: AppColors.bodyColor),
                      SizedBox(width: 4.w),
                      Text(
                        likes,
                        style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.bodyColor),
                      ),
                      SizedBox(width: 15.w),
                      Icon(Icons.chat_bubble_outline, size: 16.sp, color: AppColors.bodyColor),
                      SizedBox(width: 4.w),
                      Text(
                        comments,
                        style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.bodyColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
