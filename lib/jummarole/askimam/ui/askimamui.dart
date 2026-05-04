import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/jummarole/askimam/ui/submissionsuccessui.dart';

class AskImamUI extends StatefulWidget {
  const AskImamUI({super.key});

  @override
  State<AskImamUI> createState() => _AskImamUIState();
}

class _AskImamUIState extends State<AskImamUI> {
  bool isAskTab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // High-Fidelity Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 80.h, bottom: 60.h),
              decoration: BoxDecoration(
                color: AppColors.jummaColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.r),
                  bottomRight: Radius.circular(50.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.jummaColor.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Ask Imam',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30.h),

            // Refined Tab Switcher
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isAskTab = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: isAskTab ? AppColors.jummaColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Center(
                          child: Text(
                            'Ask Imam',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: isAskTab ? Colors.white : AppColors.jummaColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isAskTab = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: !isAskTab ? AppColors.jummaColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Center(
                          child: Text(
                            'Answered',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: !isAskTab ? Colors.white : AppColors.jummaColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),

            // Content Section
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isAskTab ? _buildAskForm() : _buildAnsweredList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAskForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Question',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.titleColor,
            ),
          ),
          SizedBox(height: 15.h),
          TextField(
            maxLines: 8,
            style: GoogleFonts.inter(fontSize: 16.sp, color: AppColors.titleColor),
            decoration: InputDecoration(
              hintText: 'Type your question here...',
              hintStyle: GoogleFonts.inter(color: AppColors.greyColor, fontSize: 16.sp),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.r),
                borderSide: const BorderSide(color: AppColors.goldColor, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.r),
                borderSide: const BorderSide(color: AppColors.jummaColor, width: 2),
              ),
              contentPadding: EdgeInsets.all(24.w),
            ),
          ),
          SizedBox(height: 50.h),
          SizedBox(
            width: double.infinity,
            height: 70.h,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const SubmissionSuccessUI(), transition: Transition.fadeIn),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.jummaColor,
                shape: const StadiumBorder(),
                elevation: 10,
                shadowColor: AppColors.jummaColor.withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, color: Colors.white, size: 22.sp),
                  SizedBox(width: 14.w),
                  Text(
                    'Submit Question',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50.h),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Your question will be answered by a qualified Imam. Please be respectful and patient.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: AppColors.bodyColor,
                  height: 1.6,
                ),
              ),
            ),
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }

  Widget _buildAnsweredList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          // Question Card
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Text(
                      'Submitted 5 days ago',
                      style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                Text(
                  'I\'m a new Muslim and I\'m struggling to wake up for Fajr prayer. What practical advice can you give me to be more consistent? I feel guilty when I miss it.',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: AppColors.titleColor,
                    height: 1.7,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 25.h),

          // Answer Card
          Container(
            padding: EdgeInsets.all(1.2.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.jummaColor.withOpacity(0.4), AppColors.jummaColor.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(29.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: AppColors.jummaColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Answer from Sister',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.jummaColor,
                            ),
                          ),
                          Text(
                            'Answered 2 days ago',
                            style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  const Divider(thickness: 0.5),
                  SizedBox(height: 20.h),
                  Text(
                    'As-salamu alaykum dear brother,\n\nMay Allah bless you for your sincere effort to establish Fajr prayer. Your concern shows a beautiful connection with your faith, and Allah sees your struggle. First, understand that missing Fajr occasionally while you\'re building the habit doesn\'t make you a bad Muslim. Allah is Most Merciful and knows you\'re trying.\n\nHere are practical steps:\n1. Sleep early - The Prophet (saw) discouraged staying awake unnecessarily after Isha. Aim for 7-8 hours before Fajr.\n2. Set multiple alarms - Place your phone across the room so you must stand to turn it off.\n3. Make sincere dua before sleeping - Ask Allah to help you wake up. He responds to sincere hearts.\n4. Have an accountability partner - Ask a brother to call you or pray together.\n5. Remember the reward - The Prophet (saw) said whoever prays Fajr is under Allah\'s protection for the entire day.\n\nBe patient with yourself. Building habits takes time, and Allah values your effort and intention. Even if you wake up late, pray immediately - a late Fajr is better than no Fajr. May Allah make it easy for you and accept your prayers.',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      color: AppColors.bodyColor,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 40.h),

          // Ask Another Question Button
          SizedBox(
            width: double.infinity,
            height: 65.h,
            child: ElevatedButton(
              onPressed: () => setState(() => isAskTab = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.jummaColor,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              child: Text(
                'Ask Another Question',
                style: GoogleFonts.inter(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
