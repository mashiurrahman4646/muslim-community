import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/splashscreen/splashscreencontroller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(SplashScreenController());

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            
            // Triple Pulsing Logo
            Center(
              child: ScaleTransition(
                scale: controller.scaleAnimation,
                child: Container(
                  width: 150.w,
                  height: 150.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFA6864D).withOpacity(0.1),
                        blurRadius: 20.r,
                        spreadRadius: 5.r,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/image/splashscreenlogo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.brown, size: 40.sp);
                    },
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 40.h),
            
            // Name Text - Fixed to stay in one line and slightly smaller
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Sumayyah • Yasir • Ammar',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp, // Made smaller as requested
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFA6864D),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // Divider Line
            Container(
              width: 80.w,
              height: 1.5.h,
              color: const Color(0xFFA6864D).withOpacity(0.5),
            ),
            
            SizedBox(height: 24.h),
            
            // Quote Text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '"The first family of Islam — \n',
                      style: GoogleFonts.playfairDisplay(
                        fontStyle: FontStyle.italic,
                        fontSize: 16.sp,
                        color: const Color(0xFF4A5568),
                      ),
                    ),
                    TextSpan(
                      text: 'now a family for every revert"',
                      style: GoogleFonts.playfairDisplay(
                        fontStyle: FontStyle.italic,
                        fontSize: 16.sp,
                        color: const Color(0xFFA6864D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(flex: 2),
            
            // Loading Text
            Text(
              'Loading...',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: Colors.grey[600],
                letterSpacing: 1.2,
              ),
            ),
            
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
