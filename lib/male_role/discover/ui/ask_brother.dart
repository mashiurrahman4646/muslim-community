import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/jummarole/askimam/ui/submissionsuccessui.dart';

class AskBrotherUI extends StatefulWidget {
  const AskBrotherUI({super.key});

  @override
  State<AskBrotherUI> createState() => _AskBrotherUIState();
}

class _AskBrotherUIState extends State<AskBrotherUI> {
  bool isAskTab = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Tab Switcher
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
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
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isAskTab ? AppColors.maleColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Center(
                      child: Text(
                        'Ask Brother',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: isAskTab ? Colors.white : AppColors.maleColor.withOpacity(0.5),
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
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: !isAskTab ? AppColors.maleColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Center(
                      child: Text(
                        'Answered',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: !isAskTab ? Colors.white : AppColors.maleColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 30.h),

        // Content Section
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isAskTab ? _buildAskForm() : _buildAnsweredList(),
        ),
        SizedBox(height: 20.h),
      ],
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.titleColor,
            ),
          ),
          SizedBox(height: 15.h),
          TextField(
            maxLines: 6,
            style: GoogleFonts.inter(fontSize: 15.sp, color: AppColors.titleColor),
            decoration: InputDecoration(
              hintText: 'Type your question here...',
              hintStyle: GoogleFonts.inter(color: AppColors.greyColor, fontSize: 14.sp),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide(color: AppColors.maleColor.withOpacity(0.2), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: const BorderSide(color: AppColors.maleColor, width: 1.5),
              ),
              contentPadding: EdgeInsets.all(20.w),
            ),
          ),
          SizedBox(height: 30.h),
          SizedBox(
            width: double.infinity,
            height: 55.h,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const SubmissionSuccessUI(), transition: Transition.fadeIn),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.maleColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, color: Colors.white, size: 18.sp),
                  SizedBox(width: 10.w),
                  Text(
                    'Submit Question',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Center(
            child: Text(
              'Your question will be answered by a qualified brother. Please be respectful and patient.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: AppColors.bodyColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnsweredList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 12, color: Colors.grey),
                    SizedBox(width: 6.w),
                    Text(
                      'Submitted 5 days ago',
                      style: GoogleFonts.inter(fontSize: 11.sp, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  'I\'m struggling to wake up for Fajr prayer. What practical advice can you give me to be more consistent?',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.titleColor,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.maleColor.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.maleColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.auto_awesome_rounded, color: AppColors.maleColor, size: 16.sp),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Answer from Brother',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.maleColor,
                          ),
                        ),
                        Text(
                          'Answered 2 days ago',
                          style: GoogleFonts.inter(fontSize: 11.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                const Divider(thickness: 0.5),
                SizedBox(height: 15.h),
                Text(
                  'As-salamu alaykum dear brother,\n\nMay Allah bless you for your sincere effort to establish Fajr prayer. Your concern shows a beautiful connection with your faith, and Allah sees your struggle.\n\nFirst, understand that missing Fajr occasionally while you\'re building the habit doesn\'t make you a bad Muslim. Allah is Most Merciful and knows you\'re trying.\n\nHere are practical steps:\n1. Sleep early - The Prophet ﷺ discouraged staying awake unnecessarily after Isha. Aim for 7-8 hours before Fajr.\n2. Set multiple alarms - Place your phone across the room so you must stand to turn it off.\n3. Make sincere dua before sleeping - Ask Allah to help you wake up. He responds to sincere hearts.\n4. Have an accountability partner - Ask a brother to call you or pray together.\n5. Remember the reward - The Prophet ﷺ said whoever prays Fajr is under Allah\'s protection for the entire day.\n\nBe patient with yourself. Building habits takes time, and Allah values your effort and intention. Even if you wake up late, pray immediately - a late Fajr is better than no Fajr.\n\nMay Allah make it easy for you and accept your prayers.',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.bodyColor,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
