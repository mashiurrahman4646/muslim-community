import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/male_role/group/controller/group_controller.dart';
import 'package:muslim_community/male_role/group/ui/widgets/group_card.dart';

class MaleGroupUI extends StatelessWidget {
  const MaleGroupUI({super.key});

  @override
  Widget build(BuildContext context) {
    final MaleGroupController controller = Get.put(MaleGroupController());

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
            
            SizedBox(height: 10.h),
            
            // --- GROUP LIST ---
            Expanded(
              child: Obx(() {
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
              }),
            ),
          ],
        ),
      ),
    );
  }
}
