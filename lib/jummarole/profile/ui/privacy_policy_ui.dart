import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:get/get.dart';

class JummaPrivacyPolicyUI extends StatelessWidget {
  const JummaPrivacyPolicyUI({super.key});

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
          "PRIVACY POLICY",
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
            """Imam Privacy Policy

Your privacy and security are highly valued. It is Muslim Community's policy to respect your privacy regarding any information we may collect from our Imams and community leaders.

We understand the sensitivity of your role and ensure all your data and community interactions are securely handled.

We don't share any personally identifying information publicly or with third-parties, except when required to by law.""",
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
