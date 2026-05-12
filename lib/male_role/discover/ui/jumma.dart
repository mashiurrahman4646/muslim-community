import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/approut.dart';

class JummaUI extends StatelessWidget {
  const JummaUI({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            decoration: BoxDecoration(
              color: AppColors.jummaColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Jumu'ah Mubarak",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Image.asset(
                      'assets/icons/mosque.png',
                      width: 30.w,
                      height: 30.w,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'BLESSED FRIDAY',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Center(
                  child: Text(
                    "This Week's Khutbahs",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                ),
                SizedBox(height: 25.h),

                // Featured Khutbah Card
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.jummaNowPlaying),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
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
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              ),
                              child: Image.asset(
                                'assets/icons/video.png',
                                width: double.infinity,
                                height: 200.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.r),
                                    topRight: Radius.circular(20.r),
                                  ),
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.play_arrow, color: Colors.white, size: 40.sp),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12.h,
                              right: 12.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time, color: Colors.white, size: 12.sp),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '24 mins',
                                      style: GoogleFonts.inter(color: Colors.white, fontSize: 10.sp),
                                    ),
                                  ],
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
                                'FEATURED',
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.goldColor,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Finding Peace in Prayer',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.titleColor,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/location.png',
                                    width: 14.w,
                                    height: 14.w,
                                    color: AppColors.bodyColor,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'East London Mosque',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      color: AppColors.bodyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // List of Other Khutbahs
                _buildKhutbahListItem(
                  'Finding Your Place in the Ummah',
                  "Regent's Park Mosque",
                  '18 mins',
                  'Last Friday',
                ),
                _buildKhutbahListItem(
                  'The Mercy of Allah for New Muslims',
                  'Brixton Mosque',
                  '22 mins',
                  '2 weeks ago',
                ),
                _buildKhutbahListItem(
                  'Patience and Perseverance',
                  'Whitechapel Mosque',
                  '15 mins',
                  '3 weeks ago',
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKhutbahListItem(String title, String location, String duration, String timeAgo) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.jummaNowPlaying),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/icons/video.png',
                    width: 65.w,
                    height: 65.w,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(color: Colors.black.withOpacity(0.1)),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Icon(Icons.play_circle_fill, color: Colors.white.withOpacity(0.8), size: 24.sp),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/location.png',
                        width: 12.w,
                        height: 12.w,
                        color: AppColors.bodyColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        location,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.bodyColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 12, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        duration,
                        style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.grey),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.circle, size: 4.sp, color: Colors.grey.shade300),
                      SizedBox(width: 8.w),
                      Text(
                        timeAgo,
                        style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.grey),
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
