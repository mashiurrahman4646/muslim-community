import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/female_role/discover/controller/discover_controller.dart';
import 'package:muslim_community/female_role/discover/ui/widgets/sister_card.dart';
import 'package:muslim_community/female_role/discover/ui/learning.dart';
import 'package:muslim_community/female_role/discover/ui/mosques.dart';
import 'package:muslim_community/female_role/discover/ui/jumma.dart';
import 'package:muslim_community/female_role/discover/ui/ask_sister.dart';

/// Female Discover page — uses femaleColor (0xFFD18E8E)
class FemaleDiscoverUI extends StatelessWidget {
  const FemaleDiscoverUI({super.key});

  // Female role primary color — from AppColors
  static const Color _roleColor = AppColors.femaleColor;
  static const Color _bgColor = AppColors.backgroundColor;

  @override
  Widget build(BuildContext context) {
    final FemaleDiscoverController controller = Get.put(
      FemaleDiscoverController(),
    );

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
              _buildMainCategories(controller),
              SizedBox(height: 20.h),

              Expanded(
                child: Obx(() {
                  if (controller.selectedCategory.value == 'Sisters') {
                    return Column(
                      children: [
                        _buildSearchBar(),
                        SizedBox(height: 20.h),
                        _buildFilterTabs(controller),
                        SizedBox(height: 20.h),
                        _buildProfilesGrid(controller),
                      ],
                    );
                  } else if (controller.selectedCategory.value == 'Learning') {
                    return const LearningUI();
                  } else if (controller.selectedCategory.value == 'Mosques') {
                    return const MosquesUI();
                  } else if (controller.selectedCategory.value == 'Jumma') {
                    return const JummaUI();
                  } else if (controller.selectedCategory.value == 'Ask Sister') {
                    return const AskSisterUI();
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCategories(FemaleDiscoverController controller) {
    return Container(
      padding: EdgeInsets.all(4.w),
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFE6),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Obx(() {
        final currentSelection = controller.selectedCategory.value;
        
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.mainCategories.length,
          itemBuilder: (context, index) {
            final category = controller.mainCategories[index];
            final isSelected = currentSelection == category;
            
            return GestureDetector(
              onTap: () => controller.selectedCategory.value = category,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16.r),
                  border: isSelected ? Border.all(color: AppColors.femaleColor, width: 1) : null,
                ),
                child: Text(
                  category,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: isSelected ? AppColors.titleColor : const Color(0xFF5B7C99),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        );
      }),
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
            _tab(
              'Near Me',
              controller.selectedTab.value == DiscoverTab.nearMe,
              () => controller.changeTab(DiscoverTab.nearMe),
            ),
            SizedBox(width: 10.w),
            _tab(
              'New Reverts',
              controller.selectedTab.value == DiscoverTab.newReverts,
              () => controller.changeTab(DiscoverTab.newReverts),
            ),
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

