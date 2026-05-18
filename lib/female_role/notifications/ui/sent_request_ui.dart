import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/female_role/notifications/controller/sent_request_controller.dart';
import 'package:muslim_community/female_role/discover/model/sister_model.dart';

class FemaleSentRequestUI extends StatelessWidget {
  const FemaleSentRequestUI({super.key});

  @override
  Widget build(BuildContext context) {
    final FemaleSentRequestController controller = Get.put(FemaleSentRequestController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: AppColors.femaleColor));
      }

      if (controller.sentRequests.isEmpty) {
        return Center(
          child: Text(
            'No sent requests',
            style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        itemCount: controller.sentRequests.length,
        itemBuilder: (context, index) {
          final sister = controller.sentRequests[index];
          return _buildRequestCard(sister, controller);
        },
      );
    });
  }

  Widget _buildRequestCard(SisterModel sister, FemaleSentRequestController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: sister.imageUrl.isNotEmpty
                ? NetworkImage(sister.imageUrl)
                : null,
            child: sister.imageUrl.isEmpty
                ? Icon(Icons.person, size: 30.sp, color: Colors.grey)
                : null,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sister.name,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                Text(
                  "${sister.age} years • ${sister.distance} km away",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      if (sister.connectionId != null) {
                        controller.cancelRequest(sister.connectionId!, sister.id);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.femaleColor),
                      foregroundColor: AppColors.femaleColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                    child: Text("Cancel Request", style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.bold)),
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
