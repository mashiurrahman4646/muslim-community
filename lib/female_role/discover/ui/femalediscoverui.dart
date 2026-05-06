import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/female_role/discover/controller/discover_controller.dart';
import 'package:muslim_community/female_role/discover/ui/widgets/sister_card.dart';

/// Female Discover page — uses femaleColor (0xFFD18E8E)
class FemaleDiscoverUI extends StatelessWidget {
  const FemaleDiscoverUI({super.key});

  // Female role primary color — from AppColors
  static const Color _roleColor = AppColors.femaleColor;
  static const Color _bgColor = AppColors.backgroundColor;

  @override
  Widget build(BuildContext context) {
    final FemaleDiscoverController controller = Get.put(FemaleDiscoverController());

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
              // Search bar (no filter button as per design)
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
          hintText: 'Search Sisters...',
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

  Widget _buildFilterTabs(FemaleDiscoverController controller) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _tab('Near Me', controller.selectedTab.value == DiscoverTab.nearMe,
                () => controller.changeTab(DiscoverTab.nearMe)),
            SizedBox(width: 10.w),
            _tab('New Reverts', controller.selectedTab.value == DiscoverTab.newReverts,
                () => controller.changeTab(DiscoverTab.newReverts)),
            SizedBox(width: 10.w),
            _tab('Verified Only', controller.selectedTab.value == DiscoverTab.verifiedOnly,
                () => controller.changeTab(DiscoverTab.verifiedOnly)),
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
            color: isSelected ? _roleColor : const Color(0xFFA6864D),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilesGrid(FemaleDiscoverController controller) {
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
          itemCount: controller.filteredSisters.length,
          itemBuilder: (context, index) =>
              SisterCard(sister: controller.filteredSisters[index]),
        ),
      ),
    );
  }
}
