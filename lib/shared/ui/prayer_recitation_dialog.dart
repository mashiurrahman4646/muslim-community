import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:muslim_community/appcolore.dart';

class PrayerRecitationDialog extends StatelessWidget {
  final String prayerName;

  const PrayerRecitationDialog({
    super.key,
    required this.prayerName,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Header with Close Button ---
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    child: Icon(Icons.close, color: AppColors.greyColor, size: 24.sp),
                  ),
                ),
              ],
            ),
            
            // --- Title ---
            Text(
              "${prayerName.toUpperCase()} RECITATION",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.goldColor,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 30.h),

            // --- Arabic Text ---
            Text(
              "أشهد أن لا إله إلا الله",
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),

            // --- Transliteration ---
            Text(
              "Ash-hadu an la ilaha illallah",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.titleColor,
              ),
            ),
            SizedBox(height: 10.h),

            // --- Translation ---
            Text(
              "\"I bear witness that there is no god but Allah\"",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontStyle: FontStyle.italic,
                color: AppColors.bodyColor,
              ),
            ),
            SizedBox(height: 40.h),

            // --- Divider ---
            Divider(color: AppColors.greyColor.withOpacity(0.2), thickness: 1),
            SizedBox(height: 30.h),

            // --- Audio Player UI ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "0:00",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.greyColor,
                        ),
                      ),
                      Text(
                        "3:45",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.greyColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4.h,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
                      activeTrackColor: AppColors.goldColor,
                      inactiveTrackColor: AppColors.greyColor.withOpacity(0.2),
                      thumbColor: AppColors.goldColor,
                    ),
                    child: Slider(
                      value: 0.35,
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.skip_previous_rounded, color: AppColors.greyColor, size: 32.sp),
                      ),
                      SizedBox(width: 20.w),
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: const BoxDecoration(
                          color: AppColors.titleColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.pause_rounded, color: Colors.white, size: 32.sp),
                      ),
                      SizedBox(width: 20.w),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.skip_next_rounded, color: AppColors.greyColor, size: 32.sp),
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
