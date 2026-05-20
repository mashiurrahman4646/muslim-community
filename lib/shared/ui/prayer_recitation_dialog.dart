import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/shared/controller/dua_controller.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class PrayerRecitationDialog extends StatelessWidget {
  final String waqt;
  final Color themeColor;

  const PrayerRecitationDialog({
    super.key,
    required this.waqt,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DuaController());
    
    // Set the dua for the specific waqt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setDuaByWaqt(waqt);
    });

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return SizedBox(
              height: 200.h,
              child: Center(child: CircularProgressIndicator(color: themeColor)),
            );
          }

          final dua = controller.currentDua.value;
          if (dua == null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Dua for $waqt",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleColor,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "No Dua found for this waqt yet.",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.bodyColor,
                  ),
                ),
                SizedBox(height: 20.h),
                _buildCloseButton(),
              ],
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dua.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Waqt: ${dua.waqt}",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: themeColor,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Text(
                  dua.details,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    height: 1.6,
                    color: AppColors.titleColor,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              
              // Audio Player UI
              if (dua.audioUrl.isNotEmpty) ...[
                Obx(() => ProgressBar(
                  progress: controller.position.value,
                  buffered: controller.bufferedPosition.value,
                  total: controller.duration.value,
                  onSeek: (duration) {
                    controller.seek(duration);
                  },
                  baseBarColor: themeColor.withOpacity(0.1),
                  progressBarColor: themeColor,
                  bufferedBarColor: themeColor.withOpacity(0.2),
                  thumbColor: themeColor,
                  barHeight: 4.0,
                  thumbRadius: 6.0,
                  timeLabelTextStyle: GoogleFonts.inter(
                    color: AppColors.bodyColor,
                    fontSize: 12.sp,
                  ),
                )),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => controller.togglePlay(),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: themeColor,
                          shape: BoxShape.circle,
                        ),
                        child: Obx(() => Icon(
                          controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 30.sp,
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
              
              _buildCloseButton(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCloseButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        ),
        child: Text(
          "Close",
          style: GoogleFonts.inter(
            color: AppColors.titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
