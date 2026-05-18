import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/female_role/notifications/controller/pending_request_controller.dart';
import 'package:muslim_community/female_role/discover/model/sister_model.dart';

class FemalePendingRequestUI extends StatelessWidget {
  const FemalePendingRequestUI({super.key});

  @override
  Widget build(BuildContext context) {
    final FemalePendingRequestController controller = Get.put(FemalePendingRequestController());

    return Obx(() {
      if (controller.isLoading.value && controller.pendingRequests.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: AppColors.femaleColor));
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchPendingRequests(),
        color: AppColors.femaleColor,
        child: controller.pendingRequests.isEmpty
            ? ListView(
                children: [
                  SizedBox(height: 200.h),
                  Center(
                    child: Text(
                      'No pending requests',
                      style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                itemCount: controller.pendingRequests.length,
                itemBuilder: (context, index) {
                  final sister = controller.pendingRequests[index];
                  return _buildRequestCard(sister, controller);
                },
              ),
      );
    });
  }

  Widget _buildRequestCard(SisterModel sister, FemalePendingRequestController controller) {
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
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (sister.connectionId != null) {
                            controller.acceptRequest(sister.connectionId!, sister.id);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.femaleColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                        child: Text("Accept", style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (sister.connectionId != null) {
                            controller.rejectRequest(sister.connectionId!, sister.id);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                        child: Text("Reject", style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
