import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/approut.dart';
import 'package:muslim_community/female_role/group/model/group_model.dart';

class FemaleGroupDetailsUI extends StatelessWidget {
  const FemaleGroupDetailsUI({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupModel group = Get.arguments ?? GroupModel(
      id: '1',
      name: 'New Reverts in London',
      category: 'Local',
      memberCount: 125,
      description: 'A safe space for new reverts in the London area to connect and support each other.',
      isJoined: true,
      icon: Icons.location_on_outlined,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: AppColors.femaleColor, size: 18.sp),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.name,
              style: GoogleFonts.playfairDisplay(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            Text(
              '${group.memberCount} members',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppColors.bodyColor,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GROUP INFO CARD ---
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBF0F0),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Icon(group.icon, color: AppColors.femaleColor, size: 24.sp),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${group.category} Group',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              group.description,
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                color: AppColors.bodyColor,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE57373),
                        side: const BorderSide(color: Color(0xFFFFEBEE)),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Text(
                        'Leave Group',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // --- CREATE POST SECTION ---
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: const AssetImage('assets/image/female.png'), // Placeholder
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: const Color(0xFFF5EFE6)),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Share something with the group...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: AppColors.bodyColor.withValues(alpha: 0.6),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE9DCC9),
                  foregroundColor: AppColors.titleColor,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  'Post',
                  style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            SizedBox(height: 30.h),

            // --- RECENT POSTS TITLE ---
            Text(
              'Recent Posts',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            SizedBox(height: 20.h),

            // --- POST CARD ---
            _buildPostCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.femalePostDetails),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
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
                CircleAvatar(
                  radius: 18.r,
                  backgroundImage: const AssetImage('assets/icons/abubakr.png'),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tariq M.',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                      Text(
                        '5h ago',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AppColors.bodyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: AppColors.bodyColor, size: 20.sp),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              'Are we still meeting up this Friday near Regent\'s Park mosque?',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppColors.titleColor.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Icon(Icons.favorite, color: const Color(0xFFE57373).withValues(alpha: 0.6), size: 18.sp),
                SizedBox(width: 6.w),
                Text(
                  '8',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.bodyColor,
                  ),
                ),
                SizedBox(width: 20.w),
                Icon(Icons.chat_bubble_outline, color: AppColors.bodyColor, size: 18.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
