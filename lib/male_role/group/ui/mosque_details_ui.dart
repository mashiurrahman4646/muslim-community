import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';

class MaleMosqueDetailsUI extends StatelessWidget {
  const MaleMosqueDetailsUI({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {
      'name': 'London Central Mosque',
      'address': '146 Park Rd, London NW8 7RG',
      'imagePath': 'assets/image/mosque01.png'
    };
    final String name = args['name'];
    final String address = args['address'];
    final String imagePath = args['imagePath'];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER IMAGE ---
            Stack(
              children: [
                Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 300.h,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40.h,
                  left: 20.w,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.8),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: AppColors.maleColor, size: 18.sp),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.h,
                  left: 20.w,
                  right: 20.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white, size: 16.sp),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              address,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- DIRECTIONS BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.near_me, size: 18.sp),
                      label: Text(
                        'Get Directions',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5A69E).withValues(alpha: 0.8), // Soft coral from image
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // --- ABOUT ---
                  Text(
                    'About',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'A beautiful and large mosque located in Regent\'s Park, serving the local and wider community with daily prayers, educational classes, and community events.',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.bodyColor,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // --- PRAYER TIMES CARD ---
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, color: const Color(0xFFE5A69E), size: 20.sp),
                            SizedBox(width: 10.w),
                            Text(
                              'Prayer Times',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        _buildPrayerRow('Fajr', '04:15'),
                        _buildPrayerRow('Dhuhr', '13:05'),
                        _buildPrayerRow('Asr', '15:30'),
                        _buildPrayerRow('Maghrib', '20:15'),
                        _buildPrayerRow('Isha', '21:45'),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF0F0),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Jummah',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE57373),
                                ),
                              ),
                              Text(
                                '13:15',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE57373),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerRow(String label, String time) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.bodyColor,
            ),
          ),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
            ),
          ),
        ],
      ),
    );
  }
}
