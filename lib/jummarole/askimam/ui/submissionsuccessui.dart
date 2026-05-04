import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';

class SubmissionSuccessUI extends StatelessWidget {
  const SubmissionSuccessUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w), // Wider padding to allow single line
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon: Precise sizing from figma
                Container(
                  width: 130.w,
                  height: 130.w,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceColor, 
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.jummaColor, width: 2.5),
                      ),
                      child: Icon(Icons.check, color: AppColors.jummaColor, size: 35.sp),
                    ),
                  ),
                ),
                SizedBox(height: 60.h),

                // Title: Single Line as per Figma Screenshot
                Text(
                  'Question Submitted',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w500, // Medium
                    color: AppColors.jummaColor,
                    height: 40 / 36, // line-height: 40px / font-size: 36px
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 40.h),

                // Body Text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'May Allah reward you for seeking knowledge. Your question has been received and will be answered by a qualified Imam.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: AppColors.bodyColor,
                      height: 1.6,
                    ),
                  ),
                ),
                SizedBox(height: 50.h),

                // Gold Text
                Text(
                  'You will receive a thoughtful response within 24-48 hours, insha’Allah.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    color: AppColors.goldColor,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                SizedBox(height: 100.h),
                
                // Minimalist Action
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    'Tap to continue',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.grey.shade400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
