import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/male_role/home/controller/home_controller.dart';
import 'package:muslim_community/male_role/navbar/navbarcontroller.dart';
import 'package:muslim_community/male_role/home/ui/prayer_settings_ui.dart';
import 'package:muslim_community/male_role/notifications/ui/malenotificationsui.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class MaleHomeUI extends StatelessWidget {
  const MaleHomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    final MaleHomeController controller = Get.put(MaleHomeController());
    final MaleNavbarController navbarController = Get.find<MaleNavbarController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                // --- HEADER ---
                _buildHeader(),
                SizedBox(height: 30.h),

                // --- PRAYER & QIBLA SECTION ---
                _buildSectionHeader(
                  "Prayer & Qibla",
                  "Settings >",
                  onActionTap: () => Get.to(() => const MalePrayerSettingsUI()),
                ),
                SizedBox(height: 20.h),

                // --- PRAYER TIMES ---
                _buildPrayerTimes(controller),
                SizedBox(height: 30.h),

                // --- QIBLA DIRECTION ---
                _buildQiblaCompass(controller),
                SizedBox(height: 30.h),

                // --- NEARBY REVERTS ---
                _buildNearbyReverts(navbarController),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 25.r,
              backgroundImage: const AssetImage('assets/image/male.png'),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, color: Colors.green, size: 12.sp),
              ),
            ),
          ],
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "As-salamu alaykum",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppColors.bodyColor,
              ),
            ),
            Text(
              "Welcome, Ahmed",
              style: GoogleFonts.playfairDisplay(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Get.to(() => const MaleNotificationsUI()),
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.maleColor.withOpacity(0.2)),
            ),
            child: Icon(Icons.notifications_none, color: AppColors.titleColor, size: 24.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String actionText, {VoidCallback? onActionTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor,
          ),
        ),
        TextButton(
          onPressed: onActionTap ?? () {},
          child: Text(
            actionText,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.maleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerTimes(MaleHomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Prayer Times",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  Text(
                    "Today · Thursday, 15 Dhul-Hijjah",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.bodyColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.maleColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: AppColors.maleColor, size: 14.sp),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Obx(() => Text(
                      controller.currentLocation.value,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.maleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        // --- Static Prayer Cards with Asset Icons ---
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 15.h,
          crossAxisSpacing: 15.w,
          childAspectRatio: 0.8,
          children: [
            _buildPrayerCard("Fajr", "05:12", 'assets/icons/fajr.png'),
            _buildPrayerCard("Sunrise", "06:45", 'assets/icons/sunrise.png'),
            _buildPrayerCard("Dhuhr", "12:30", 'assets/icons/dhuhr.png'),
            _buildPrayerCard("Asr", "15:45", 'assets/icons/asr.png'),
            _buildPrayerCard("Maghrib", "18:15", 'assets/icons/maghrib.png', isNext: true),
            _buildPrayerCard("Isha", "19:45", 'assets/icons/isha.png'),
          ],
        ),
        SizedBox(height: 20.h),
        Center(
          child: Text(
            "Tap card to view recitation",
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.bodyColor.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerCard(String name, String time, String iconPath, {bool isNext = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isNext ? AppColors.maleColor.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: isNext ? Border.all(color: AppColors.maleColor.withOpacity(0.3)) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isNext)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.goldColor,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Text(
                  "NEXT",
                  style: TextStyle(color: Colors.white, fontSize: 8.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(iconPath, width: 24.w, height: 24.w),
                SizedBox(height: 8.h),
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.titleColor,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.bodyColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    color: AppColors.goldColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQiblaCompass(MaleHomeController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.maleColor.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "QIBLA DIRECTION",
            style: GoogleFonts.playfairDisplay(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "Live Compass Direction",
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.bodyColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 35.h),
          Stack(
            alignment: Alignment.center,
            children: [
              // 1. Dynamic Outer Compass Face
              Obx(() => Transform.rotate(
                angle: controller.qiblaController.dialAngle,
                child: Image.asset(
                  'assets/image/side.png',
                  width: 230.w,
                  height: 230.w,
                  fit: BoxFit.contain,
                ),
              )),
              
              // 2. The Dynamic Qibla Pointer
              Obx(() => Transform.rotate(
                angle: controller.qiblaController.needleAngle,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 170.w,
                      height: 170.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.maleColor.withOpacity(0.03),
                      ),
                    ),
                    Image.asset(
                      'assets/image/qiblacompas.png',
                      width: 160.w,
                      height: 160.w,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              )),

              // 3. Center Point
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.maleColor, width: 3),
                  boxShadow: [
                    BoxShadow(color: AppColors.maleColor.withOpacity(0.3), blurRadius: 8),
                  ],
                ),
              ),
              
              // 4. Heading Degree Text
              Positioned(
                bottom: 20.h,
                child: Obx(() => Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.maleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    "${controller.qiblaController.compassHeading.value.toStringAsFixed(0)}°",
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.maleColor,
                    ),
                  ),
                )),
              ),
            ],
          ),
          SizedBox(height: 35.h),
          Text(
            "Align your phone to find the Kaaba",
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.bodyColor.withOpacity(0.5),
              fontStyle: FontStyle.italic,
            ),
          ),
          Obx(() => controller.qiblaController.accuracyStatus.value.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 18.sp),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          controller.qiblaController.accuracyStatus.value,
                          style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyReverts(MaleNavbarController navbarController) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Nearby Reverts",
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                navbarController.changeIndex(1); // Go to Discover
              },
              child: Text(
                "See all >",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: AppColors.maleColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 160.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildRevertItem("Omar", 'assets/image/male.png', true),
              _buildRevertItem("Zaid", 'assets/image/male.png', false),
              _buildRevertItem("Ali", 'assets/image/male.png', false),
              _buildRevertItem("Hassan", 'assets/image/male.png', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRevertItem(String name, String assetPath, bool isVerified) {
    return Container(
      width: 130.w,
      margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  image: DecorationImage(
                    image: AssetImage(assetPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_circle, color: AppColors.maleColor, size: 16.sp),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.titleColor,
            ),
          ),
        ],
      ),
    );
  }
}
