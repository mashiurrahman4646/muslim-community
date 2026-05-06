import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';

class MalePostDetailsUI extends StatelessWidget {
  const MalePostDetailsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: AppColors.maleColor, size: 18.sp),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Reverts in London',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            Text(
              '125 members',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppColors.bodyColor,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Posts',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // --- POST CARD ---
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundImage: const AssetImage('assets/icons/abubakr.png'),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tariq M.',
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.titleColor,
                                    ),
                                  ),
                                  Text(
                                    '5h ago',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: AppColors.bodyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.more_vert, color: AppColors.bodyColor, size: 20.sp),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          'Are we still meeting up this Friday near Regent\'s Park mosque?',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppColors.titleColor.withValues(alpha: 0.8),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Icon(Icons.favorite, color: const Color(0xFFE57373).withValues(alpha: 0.6), size: 18.sp),
                            SizedBox(width: 6.w),
                            Text(
                              '8',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: AppColors.bodyColor,
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Icon(Icons.chat_bubble_outline, color: AppColors.bodyColor, size: 18.sp),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- COMMENT SECTION ---
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
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: const AssetImage('assets/icons/abubakr.png'),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: AppColors.bodyColor.withValues(alpha: 0.6),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9DCC9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send_rounded, color: AppColors.titleColor, size: 20.sp),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
