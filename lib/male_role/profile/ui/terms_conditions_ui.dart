import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:get/get.dart';

class MaleTermsConditionsUI extends StatelessWidget {
  const MaleTermsConditionsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back_ios_new, color: AppColors.titleColor, size: 16.sp),
            ),
          ),
        ),
        title: Text(
          "TERMS AND CONDITIONS",
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            """Brother Terms and Conditions

By downloading or using the app, these terms will automatically apply to you. Welcome to the brotherhood space!

You are expected to foster brotherhood and respect within the community. You are not allowed to copy, or modify the app, or extract the source code.

We are committed to ensuring that the app is as useful and efficient as possible for our male community members.""",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.bodyColor,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}
