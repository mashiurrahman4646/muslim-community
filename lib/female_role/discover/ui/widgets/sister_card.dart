import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/female_role/discover/model/sister_model.dart';

/// This widget represents a single sister profile card in the Discover grid.
class SisterCard extends StatelessWidget {
  final SisterModel sister;
  
  const SisterCard({super.key, required this.sister});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- IMAGE SECTION ---
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.asset(
                  'assets/image/female.png', 
                  height: 100.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter, 
                ),
              ),
              if (sister.isOnline) _buildOnlineIndicator(),
              if (sister.isVerified) _buildVerifiedBadge(),
            ],
          ),
          
          SizedBox(height: 8.h),
          
          // --- INFO SECTION (Name, Age, Distance) ---
          Text(
            sister.name,
            style: GoogleFonts.playfairDisplay(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3436),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 2.h),
          
          Text(
            '${sister.age} • ${sister.joinedAgo}',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              color: const Color(0xFF636E72),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 6.h),
          
          _buildDistanceBadge(),

          SizedBox(height: 8.h),

          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildOnlineIndicator() {
    return Positioned(
      top: 6,
      right: 6,
      child: Container(
        width: 8.w,
        height: 8.w,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 1.5)),
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Positioned(
      bottom: 4,
      right: 4,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: Color(0xFFD18E8E),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, color: Colors.white, size: 10.sp),
      ),
    );
  }

  Widget _buildDistanceBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF0F0), // Soft pink background matching femaleColor
        borderRadius: BorderRadius.circular(20.r), // Pill shape
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_outlined, size: 10.sp, color: const Color(0xFFD18E8E)),
          SizedBox(width: 4.w),
          Text(
            '${sister.distance} mi',
            style: GoogleFonts.inter(fontSize: 10.sp, color: const Color(0xFFD18E8E)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    // Determine styles based on status
    final bool isConnected = sister.status == 'Connected';
    final bool isRequested = sister.status == 'Requested';
    final bool isConnect = sister.status == 'Connect';

    return SizedBox(
      width: double.infinity,
      height: 32.h,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isConnected || isRequested ? Colors.white : const Color(0xFFD18E8E),
          foregroundColor: isConnected || isRequested ? const Color(0xFFD18E8E) : Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r), // Pill shape matching screenshot
            // Both Connected and Requested get a visible pink border
            side: isConnected || isRequested
                ? const BorderSide(color: Color(0xFFD18E8E), width: 1.5)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isConnect) ...[
              Icon(Icons.person_add_alt_1, size: 14.sp),
              SizedBox(width: 6.w),
            ],
            Text(
              sister.status,
              style: GoogleFonts.inter(fontSize: 11.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
