import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/female_role/auth/controller/female_create_account_controller.dart';
import 'package:muslim_community/female_role/auth/controller/female_verify_controller.dart';

class FemaleIdentityVerificationUI extends StatelessWidget {
  const FemaleIdentityVerificationUI({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFFD18E8E);
    final accountController = Get.put(FemaleCreateAccountController());
    final verifyController = accountController.verifyController;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF2D3436), size: 24.sp),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDot(true, themeColor),
            _buildDot(true, themeColor),
            _buildDot(false, themeColor),
          ],
        ),
        centerTitle: true,
        actions: [SizedBox(width: 48.w)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Identity Verification',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'To keep SYA a safe, exclusive space, we require a quick verification.',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: const Color(0xFFA6864D).withOpacity(0.8),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 30.h),

              // Photo Verification Card
              Obx(() => _buildVerificationCard(
                icon: Icons.shield_outlined,
                title: 'Photo Verification',
                description: 'Please take a clear photo holding a piece of paper with today\'s date. This is for manual review only and will never be shared.',
                buttonText: 'Take Verification Photo',
                buttonIcon: Icons.camera_alt_outlined,
                onTap: verifyController.takePhoto,
                isCompleted: verifyController.verificationImage.value != null,
                themeColor: themeColor,
              )),
              SizedBox(height: 24.h),

              // Video Verification Card
              Obx(() => _buildVerificationCard(
                icon: Icons.shield_outlined,
                title: 'Record Video Verification',
                description: '5-second video reading a random phrase',
                buttonText: 'Start recording',
                buttonIcon: Icons.videocam_outlined,
                onTap: verifyController.recordVideo,
                isCompleted: verifyController.verificationVideo.value != null,
                themeColor: themeColor,
              )),
              SizedBox(height: 40.h),

              // Continue Button
              Obx(() => SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: accountController.isLoading.value ? null : () => accountController.createAccount(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                    elevation: 0,
                  ),
                  child: accountController.isLoading.value 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                    'Continue',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? color : color.withOpacity(0.2),
      ),
    );
  }

  Widget _buildVerificationCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required IconData buttonIcon,
    required VoidCallback onTap,
    required bool isCompleted,
    required Color themeColor,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E9).withOpacity(0.6),
        borderRadius: BorderRadius.circular(24.r),
        border: isCompleted ? Border.all(color: Colors.green, width: 1.5) : null,
      ),
      child: Column(
        children: [
          Icon(isCompleted ? Icons.check_circle : icon, size: 40.sp, color: isCompleted ? Colors.green : themeColor.withOpacity(0.5)),
          SizedBox(height: 12.h),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFFA6864D),
              height: 1.5,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(buttonIcon, size: 20.sp, color: const Color(0xFF2D3436)),
                  SizedBox(width: 10.w),
                  Text(
                    isCompleted ? 'Recapture' : buttonText,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3436),
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
