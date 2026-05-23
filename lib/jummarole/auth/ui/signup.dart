import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/approut.dart';
import 'package:flutter/gestures.dart';
import 'package:muslim_community/jummarole/profile/ui/privacy_policy_ui.dart';
import 'package:muslim_community/jummarole/profile/ui/terms_conditions_ui.dart';
import 'package:muslim_community/jummarole/auth/controller/jumma_signup_controller.dart';

class JummaSignUpUI extends StatelessWidget {
  const JummaSignUpUI({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF436E50); // Jumma color
    final controller = Get.put(JummaSignupController());

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
                      textController: controller.nameController,
                    ),
                    SizedBox(height: 16.h),
                    _buildInputField(
                      label: 'EMAIL ADDRESS',
                      hint: 'Enter your email',
                      icon: Icons.email_outlined,
                      themeColor: themeColor,
                      textController: controller.emailController,
                    ),
                    SizedBox(height: 16.h),
                    Obx(() => _buildInputField(
                          label: 'PASSWORD',
                          hint: 'Create a password',
                          icon: Icons.lock_outline,
                          themeColor: themeColor,
                          isPassword: true,
                          obscureText: !controller.isPasswordVisible.value,
                          textController: controller.passwordController,
                          onToggleVisibility: () =>
                              controller.togglePasswordVisibility(),
                        )),
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: () => controller.pickDateOfBirth(context),
                      child: AbsorbPointer(
                        child: Obx(() => _buildInputField(
                              label: 'DATE OF BIRTH',
                              hint: controller.dateOfBirth.value.isEmpty
                                  ? 'Select date of birth'
                                  : controller.dateOfBirth.value.split('T')[0],
                              icon: Icons.calendar_today_outlined,
                              themeColor: themeColor,
                            )),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: Obx(() => ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.signup(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              elevation: 0,
                            ),
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Row(
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
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Footer Text - UPDATED COLOR TO THEME COLOR
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
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Get.to(() => const JummaTermsConditionsUI());
                        },
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Get.to(() => const JummaPrivacyPolicyUI());
                        },
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
                  Icon(Icons.nights_stay_outlined, size: 16.sp, color: themeColor.withOpacity(0.5)),
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
                    onTap: () => Get.toNamed(AppRoutes.jummaLogin),
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
    bool obscureText = false,
    TextEditingController? textController,
    VoidCallback? onToggleVisibility,
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
          controller: textController,
          obscureText: isPassword ? obscureText : false,
          style: GoogleFonts.inter(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14.sp),
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.grey.shade400, size: 20.sp)
                : null,
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: onToggleVisibility,
                    child: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey.shade400,
                      size: 20.sp,
                    ),
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFFEDF4F1).withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
      ],
    );
  }
}
