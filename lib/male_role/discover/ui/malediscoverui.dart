import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/male_role/discover/controller/discover_controller.dart';
import 'package:muslim_community/male_role/discover/ui/widgets/brother_card.dart';

import 'package:muslim_community/appcolore.dart';

/// Male Discover page — mirrors female structure, uses maleColor (0xFF5B7C99)
class MaleDiscoverUI extends StatelessWidget {
  const MaleDiscoverUI({super.key});

  // Male role primary color — from AppColors
  static const Color _roleColor = AppColors.maleColor;
  static const Color _bgColor = AppColors.backgroundColor;

  @override
  Widget build(BuildContext context) {
    final MaleDiscoverController controller = Get.put(MaleDiscoverController());

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text(
                'Discover',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 20.h),
              // Search bar (no filter button — same as female)
              _buildSearchBar(),
              SizedBox(height: 20.h),
              _buildFilterTabs(controller),
              SizedBox(height: 20.h),
              _buildProfilesGrid(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Brothers...',
          hintStyle: GoogleFonts.inter(
            color: Colors.grey.withValues(alpha: 0.5),
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: _roleColor.withValues(alpha: 0.5),
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(MaleDiscoverController controller) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _tab('Near Me', controller.selectedTab.value == MaleDiscoverTab.nearMe,
                () => controller.changeTab(MaleDiscoverTab.nearMe)),
            SizedBox(width: 10.w),
            _tab('New Reverts', controller.selectedTab.value == MaleDiscoverTab.newReverts,
                () => controller.changeTab(MaleDiscoverTab.newReverts)),
            SizedBox(width: 10.w),
            _tab('Verified Only', controller.selectedTab.value == MaleDiscoverTab.verifiedOnly,
                () => controller.changeTab(MaleDiscoverTab.verifiedOnly)),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isSelected
                ? _roleColor.withValues(alpha: 0.4)
                : const Color(0xFFA6864D).withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            // maleColor replaces femaleColor for selected tab text
            color: isSelected ? _roleColor : const Color(0xFFA6864D),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilesGrid(MaleDiscoverController controller) {
    return Expanded(
      child: Obx(
        () => GridView.builder(
          padding: EdgeInsets.only(bottom: 20.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
          ),
          itemCount: controller.filteredBrothers.length,
          itemBuilder: (context, index) =>
              BrotherCard(brother: controller.filteredBrothers[index]),
        ),
      ),
    );
  }
}
