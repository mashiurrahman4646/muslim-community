import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:get/get.dart';
import 'package:muslim_community/female_role/discover/model/sister_model.dart';

class FemaleProfileDetailsUI extends StatelessWidget {
  final SisterModel sister;

  const FemaleProfileDetailsUI({super.key, required this.sister});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(),
                  SizedBox(height: 30.h),
                  _buildSectionTitle("About Me"),
                  SizedBox(height: 10.h),
                  _buildSectionContent(sister.about),
                  SizedBox(height: 25.h),
                  _buildSectionTitle("My Revert Story / Journey"),
                  SizedBox(height: 10.h),
                  _buildSectionContent(sister.revertHistory),
                  SizedBox(height: 25.h),
                  _buildSectionTitle("Interests"),
                  SizedBox(height: 10.h),
                  _buildInterests(),
                  SizedBox(height: 40.h),
                  _buildActionButtons(),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 350.h,
      pinned: true,
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_new, color: AppColors.titleColor, size: 18.sp),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              sister.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/image/female.png',
                fit: BoxFit.cover,
              ),
            ),
            // Gradient to make text readable
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
            if (sister.isOnline)
              Positioned(
                bottom: 20.h,
                right: 20.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "Online",
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "${sister.name}, ${sister.age}",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.titleColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (sister.isVerified) ...[
                        SizedBox(width: 8.w),
                        Icon(Icons.verified, color: AppColors.femaleColor, size: 22.sp),
                      ],
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Joined ${sister.joinedAgo}",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.bodyColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.femaleColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: AppColors.femaleColor, size: 16.sp),
                  SizedBox(width: 4.w),
                  Text(
                    "${sister.distance} mi",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.femaleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (sister.isNewRevert) ...[
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.goldColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.goldColor.withOpacity(0.5)),
            ),
            child: Text(
              "✨ New Revert",
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFB8860B),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.titleColor,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        content,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: AppColors.bodyColor,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildInterests() {
    if (sister.interests.isEmpty) {
      return _buildSectionContent("No interests provided yet.");
    }

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: sister.interests.map((interest) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.femaleColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.femaleColor.withOpacity(0.3)),
          ),
          child: Text(
            interest,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.femaleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    final bool isConnected = sister.status == 'Connected';
    final bool isRequested = sister.status == 'Requested';
    final bool isConnect = sister.status == 'Connect';

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isConnected || isRequested ? Colors.white : AppColors.femaleColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            side: isConnected || isRequested
                ? BorderSide(color: AppColors.femaleColor, width: 1.5)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isConnect) ...[
              Icon(Icons.person_add_alt_1, color: Colors.white, size: 20.sp),
              SizedBox(width: 8.w),
            ],
            Text(
              sister.status,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isConnected || isRequested ? AppColors.femaleColor : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
