import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/female_role/home/controller/home_controller.dart';
import 'package:muslim_community/female_role/navbar/navbarcontroller.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class FemaleHomeUI extends StatelessWidget {
  const FemaleHomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final FemaleNavbarController navbarController = Get.find<FemaleNavbarController>();

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
                _buildSectionHeader("Prayer & Qibla", "Settings >"),
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
              backgroundImage: const AssetImage('assets/image/female.png'),
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
              "Welcome, Aisha",
              style: GoogleFonts.playfairDisplay(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.femaleColor.withOpacity(0.2)),
          ),
          child: Icon(Icons.notifications_none, color: AppColors.titleColor, size: 24.sp),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
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
          onPressed: () {},
          child: Text(
            actionText,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.femaleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerTimes(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                  "Today · ${DateFormat('EEEE, d MMM').format(DateTime.now())}",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.bodyColor,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.femaleColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.femaleColor, size: 14.sp),
                  SizedBox(width: 4.w),
                  Obx(() => Text(
                    controller.currentLocation.value,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.femaleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final timings = controller.prayerTimings['timings'];
          if (timings == null) return const Text("Failed to load prayer times");

          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 15.h,
            crossAxisSpacing: 15.w,
            childAspectRatio: 0.8,
            children: [
              _buildPrayerCard("Fajr", timings['Fajr'], 'assets/icons/fajr.png', isNext: controller.nextPrayer.value == "Fajr"),
              _buildPrayerCard("Sunrise", timings['Sunrise'], 'assets/icons/sunrise.png', isNext: controller.nextPrayer.value == "Sunrise"),
              _buildPrayerCard("Dhuhr", timings['Dhuhr'], 'assets/icons/dhuhr.png', isNext: controller.nextPrayer.value == "Dhuhr"),
              _buildPrayerCard("Asr", timings['Asr'], 'assets/icons/asr.png', isNext: controller.nextPrayer.value == "Asr"),
              _buildPrayerCard("Maghrib", timings['Maghrib'], 'assets/icons/maghrib.png', isNext: controller.nextPrayer.value == "Maghrib"),
              _buildPrayerCard("Isha", timings['Isha'], 'assets/icons/isha.png', isNext: controller.nextPrayer.value == "Isha"),
            ],
          );
        }),
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
        color: isNext ? AppColors.femaleColor.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: isNext ? Border.all(color: AppColors.femaleColor.withOpacity(0.3)) : null,
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

  Widget _buildQiblaCompass(HomeController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.femaleColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: AppColors.femaleColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.compass_calibration_outlined, color: AppColors.femaleColor, size: 22.sp),
              SizedBox(width: 10.w),
              Text(
                "QIBLA DIRECTION",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Stack(
            alignment: Alignment.center,
            children: [
              // 1. The Background Dial (compas.png)
              // This shows N, S, E, W. It rotates opposite to the phone's heading.
              Obx(() => Transform.rotate(
                angle: controller.qiblaController.dialAngle,
                child: Image.asset(
                  'assets/icons/compas.png',
                  width: 240.w,
                  height: 240.w,
                  fit: BoxFit.contain,
                ),
              )),
              
              // 2. The Qibla Needle/Icon (qibla.png)
              // This is the icon with the Kaaba. It rotates relative to the phone's orientation.
              Obx(() => Transform.rotate(
                angle: controller.qiblaController.needleAngle,
                child: Image.asset(
                  'assets/icons/qibla.png',
                  width: 160.w,
                  height: 160.w,
                  fit: BoxFit.contain,
                ),
              )),

              // 3. Center Point
              Container(
                width: 12.w,
                height: 12.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Text(
            "Rotate your phone to align the needle",
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.bodyColor.withOpacity(0.8),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyReverts(FemaleNavbarController navbarController) {
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
                  color: AppColors.femaleColor,
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
              _buildRevertItem("Aisha", 'assets/image/female.png', true),
              _buildRevertItem("Fatima", 'assets/image/female.png', false),
              _buildRevertItem("Khadija", 'assets/image/female.png', false),
              _buildRevertItem("Zainab", 'assets/image/female.png', false),
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
                    child: Icon(Icons.check_circle, color: AppColors.femaleColor, size: 16.sp),
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
