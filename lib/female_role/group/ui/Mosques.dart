import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';

class MosquesUI extends StatelessWidget {
  const MosquesUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mosque, size: 60.sp, color: AppColors.femaleColor.withValues(alpha: 0.5)),
          SizedBox(height: 20.h),
          Text(
            'Mosques Module',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Mosque listings will be designed here.',
            style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.bodyColor),
          ),
        ],
      ),
    );
  }
}
