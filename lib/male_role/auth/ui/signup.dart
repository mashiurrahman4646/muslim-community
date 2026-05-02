import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/approut.dart';

class MaleSignUpUI extends StatelessWidget {
  const MaleSignUpUI({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF5B7C99); // Brother color

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            children: [
              // Top Logo
              Center(
                child: Container(
                  width: 100.w,
                  height: 100.w,
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
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Titles
              FittedBox(
                child: Text(
                  'Join the Community',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3436),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Start your spiritual journey with us.',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: const Color(0xFF636E72).withOpacity(0.8),
                ),
              ),
              SizedBox(height: 30.h),

              // Form Container
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      label: 'FULL NAME',
                      hint: 'Enter your full name',
                      icon: Icons.person_outline,
                      themeColor: themeColor,
                    ),
                    SizedBox(height: 16.h),
                    _buildInputField(
                      label: 'EMAIL ADDRESS',
                      hint: 'Enter your email',
                      icon: Icons.email_outlined,
                      themeColor: themeColor,
                    ),
                    SizedBox(height: 16.h),
                    _buildInputField(
                      label: 'PASSWORD',
                      hint: 'Create a password',
                      icon: Icons.lock_outline,
                      themeColor: themeColor,
                      isPassword: true,
                    ),
                    SizedBox(height: 16.h),
                    _buildDropdownField(
                      label: 'HOW LONG HAVE YOU BEEN A REVERT?',
                      hint: 'Select duration',
                      assetIcon: 'assets/icons/selecteduration.png',
                      themeColor: themeColor,
                    ),
                    SizedBox(height: 16.h),
                    _buildInputField(
                      label: 'AGE',
                      hint: 'Minimum 16 years',
                      themeColor: themeColor,
                    ),
                    SizedBox(height: 24.h),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed(AppRoutes.maleSignUpOTP),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/creataccout.png',
                              width: 20.w,
                              height: 20.w,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Create Account',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Footer Text - Colored theme
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: const Color(0xFF636E72),
                    ),
                    children: [
                      const TextSpan(text: 'By signing up, you agree to our '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Moon Divider
              Row(
                children: [
                  const Expanded(child: Divider(indent: 40, endIndent: 10)),
                  Image.asset(
                    'assets/icons/selecteduration.png',
                    width: 16.w,
                    height: 16.w,
                    color: themeColor.withOpacity(0.5),
                  ),
                  const Expanded(child: Divider(indent: 10, endIndent: 40)),
                ],
              ),
              SizedBox(height: 20.h),

              // Login Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.maleLogin),
                    child: Text(
                      'Login',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: themeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    IconData? icon,
    required Color themeColor,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14.sp, color: themeColor),
              SizedBox(width: 8.w),
            ],
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: themeColor.withOpacity(0.8),
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextField(
          obscureText: isPassword,
          style: GoogleFonts.inter(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14.sp),
            prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade400, size: 20.sp) : null,
            suffixIcon: isPassword ? Icon(Icons.visibility_off_outlined, color: Colors.grey.shade400, size: 20.sp) : null,
            filled: true,
            fillColor: const Color(0xFFEDF4F1).withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String assetIcon,
    required Color themeColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Image.asset(
                assetIcon,
                width: 14.w,
                height: 14.w,
                color: themeColor,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: themeColor.withOpacity(0.8),
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF4F1).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Image.asset(
                assetIcon,
                width: 18.w,
                height: 18.w,
                color: Colors.grey.shade400,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  hint, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14.sp)
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400, size: 20.sp),
            ],
          ),
        ),
      ],
    );
  }
}
