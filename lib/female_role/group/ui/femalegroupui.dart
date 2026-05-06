import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/female_role/group/controller/group_controller.dart';
import 'package:muslim_community/female_role/group/ui/widgets/group_card.dart';
import 'package:muslim_community/female_role/group/ui/learning.dart';
import 'package:muslim_community/female_role/group/ui/Mosques.dart';
import 'package:muslim_community/female_role/group/ui/Jumma.dart';
import 'package:muslim_community/female_role/group/ui/Ask Imam.dart';

class FemaleGroupUI extends StatelessWidget {
  const FemaleGroupUI({super.key});

  @override
  Widget build(BuildContext context) {
    final FemaleGroupController controller = Get.put(FemaleGroupController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            
            // --- TITLE ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Groups',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // --- TABS ---
            _buildCategoryTabs(controller),
            
            SizedBox(height: 20.h),
            
            // --- DIVIDER ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Divider(
                color: AppColors.goldColor.withValues(alpha: 0.15),
                thickness: 1,
                height: 1,
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // --- GROUP LIST OR PLACEHOLDER ---
            Expanded(
              child: Obx(() {
                if (controller.selectedCategory.value == 'Groups') {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: controller.filteredGroups.length,
                    itemBuilder: (context, index) {
                      final group = controller.filteredGroups[index];
                      return GroupCard(
                        group: group,
                        onJoinToggle: () => controller.toggleJoin(group.id),
                      );
                    },
                  );
                } else if (controller.selectedCategory.value == 'Learning') {
                  return const LearningUI();
                } else if (controller.selectedCategory.value == 'Mosques') {
                  return const MosquesUI();
                } else if (controller.selectedCategory.value == 'Jumma') {
                  return const JummaUI();
                } else if (controller.selectedCategory.value == 'Ask Imam') {
                  return const AskImamUI();
                } else {
                  return const SizedBox();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(FemaleGroupController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(4.w),
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFE6), // Unified background from image
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Obx(() {
        // Explicitly read the observable outside the builder to ensure GetX tracks it
        final currentSelection = controller.selectedCategory.value;
        
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected = currentSelection == category;
            
            return GestureDetector(
              onTap: () => controller.filterGroups(category),
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
                    color: isSelected ? AppColors.titleColor : const Color(0xFF5B7C99), // Bluish grey unselected text from image
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
}
