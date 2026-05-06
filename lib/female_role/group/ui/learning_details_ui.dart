import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';

class FemaleLearningDetailsUI extends StatelessWidget {
  const FemaleLearningDetailsUI({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {
      'category': 'SALAH',
      'title': 'How to Pray Salah for Beginners',
      'imagePath': 'assets/image/learningimage1.png',
    };
    final String category = args['category'];
    final String title = args['title'];
    final String imagePath = args['imagePath'] ?? 'assets/image/learningimage1.png';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // --- VIDEO PLAYER PLACEHOLDER ---
          Stack(
            children: [
              Image.asset(
                imagePath,
                width: double.infinity,
                height: 250.h,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.play_arrow, color: Colors.white, size: 40.sp),
                  ),
                ),
              ),
              Positioned(
                top: 40.h,
                left: 20.w,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.8),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, color: AppColors.femaleColor, size: 18.sp),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.femaleColor,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      _buildStatItem(Icons.favorite_border, '1240'),
                      SizedBox(width: 25.w),
                      _buildStatItem(Icons.chat_bubble_outline, '89'),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  Divider(color: AppColors.bodyColor.withValues(alpha: 0.1)),
                  SizedBox(height: 25.h),
                  Text(
                    'Comments',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _buildCommentItem(
                    'Aisha M.',
                    'This was so helpful, jazakallah khair! I\'ve been struggling to remember the steps but this breaks it down perfectly.',
                    '2 hours ago',
                  ),
                ],
              ),
            ),
          ),

          // --- ADD COMMENT BAR ---
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(color: const Color(0xFFE57373).withValues(alpha: 0.2)),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.bodyColor.withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.bodyColor.withValues(alpha: 0.1)),
          ),
          child: Icon(icon, size: 20.sp, color: AppColors.bodyColor),
        ),
        SizedBox(width: 10.w),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppColors.bodyColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem(String name, String comment, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: Colors.grey.shade200,
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: const Color(0xFFE57373).withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      comment,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: AppColors.bodyColor,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: AppColors.bodyColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
