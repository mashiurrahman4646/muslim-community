import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/male_role/group/model/group_model.dart';

class GroupCard extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onJoinToggle;

  const GroupCard({
    super.key,
    required this.group,
    required this.onJoinToggle,
  });

  static const Color _roleColor = AppColors.maleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ---
          Row(
            children: [
              Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF1F7), // Soft blue-grey background
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Icon(group.icon, color: _roleColor, size: 20.sp),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${group.category} • ${group.memberCount} members',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.bodyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 15.h),
          
          // --- DESCRIPTION ---
          Text(
            group.description,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.titleColor.withValues(alpha: 0.8),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 20.h),
          
          // --- BUTTONS ---
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _roleColor, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    'View Posts',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: _roleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onJoinToggle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: group.isJoined ? const Color(0xFFF5EFE6) : _roleColor,
                    foregroundColor: group.isJoined ? AppColors.titleColor.withValues(alpha: 0.7) : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    group.isJoined ? 'Leave Group' : 'Join Group',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
