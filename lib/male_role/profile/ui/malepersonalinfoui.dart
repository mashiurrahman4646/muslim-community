import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:get/get.dart';

class MalePersonalInfoUI extends StatelessWidget {
  const MalePersonalInfoUI({super.key});

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
          "PROFILE",
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor,
            letterSpacing: 2,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              padding: EdgeInsets.all(10.w),
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
              child: Icon(Icons.settings_outlined, color: AppColors.titleColor, size: 18.sp),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            // Profile Image & Info
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          image: const DecorationImage(
                            image: AssetImage('assets/image/male.png'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: const BoxDecoration(
                              color: AppColors.maleColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.check, color: Colors.white, size: 10.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    "Brother Omar",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Joined 8 months ago",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: AppColors.bodyColor,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt_outlined, color: AppColors.maleColor, size: 14.sp),
                        SizedBox(width: 8.w),
                        Text(
                          "Edit Photo",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.titleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),

            // Verified Revert Banner
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: AppColors.maleColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.goldColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.shield_outlined, color: AppColors.goldColor, size: 20.sp),
                  ),
                  SizedBox(width: 15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Verified Revert",
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.titleColor,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Icon(Icons.check_circle, color: Colors.green, size: 14.sp),
                        ],
                      ),
                      Text(
                        "Verified on Oct 12, 2023",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.bodyColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Personal Details Card
            _buildSectionCard(
              title: "Personal Details",
              children: [
                _buildDetailRow("Full Name", "Omar Khan"),
                _buildDetailRow("Age", "24"),
                _buildDetailRow("Gender", "Brother", icon: Icons.lock_outline),
                _buildDetailRow("Location", "London, UK"),
                _buildDetailRow("How long Muslim?", "8 months"),
                _buildDetailRow("Email", "o***@email.com"),
              ],
            ),
            SizedBox(height: 20.h),

            // About Me Card
            _buildSectionCard(
              title: "About Me",
              children: [
                Text(
                  "Assalamu alaikum! I'm Omar, a recent revert navigating my beautiful new faith journey. I'm passionate about learning, connecting with other brothers, and finding peace in my daily prayers. Looking forward to growing together in this supportive community.",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppColors.bodyColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // My Revert Story Card
            _buildSectionCard(
              title: "My Revert Story",
              showEditIcon: false,
              children: [
                Text(
                  "My journey to Islam started during university when I began reading the Quran out of curiosity. The profound peace and logical clarity I found in its verses completely changed my perspective on life. Taking my Shahada was the most liberating moment of my life.",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppColors.bodyColor,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Interests",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: bold,
                    color: AppColors.titleColor,
                  ),
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: [
                    _buildInterestTag("Quran Learning"),
                    _buildInterestTag("Salah"),
                    _buildInterestTag("Community"),
                    _buildInterestTag("Islamic History"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30.h),

            // Update Information Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 18.h),
              decoration: BoxDecoration(
                color: AppColors.maleColor,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.maleColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Update Information",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  FontWeight get bold => FontWeight.bold;

  Widget _buildSectionCard({required String title, required List<Widget> children, bool showEditIcon = true}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
              if (showEditIcon)
                Icon(Icons.edit_square, color: AppColors.maleColor.withOpacity(0.5), size: 18.sp),
            ],
          ),
          SizedBox(height: 15.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.bodyColor.withOpacity(0.8),
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.titleColor,
                ),
              ),
              if (icon != null) ...[
                SizedBox(width: 5.w),
                Icon(icon, color: AppColors.bodyColor, size: 14.sp),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.maleColor.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          color: AppColors.maleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
