import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/approut.dart';

class MaleSignUpOTPUI extends StatefulWidget {
  const MaleSignUpOTPUI({super.key});

  @override
  State<MaleSignUpOTPUI> createState() => _MaleSignUpOTPUIState();
}

class _MaleSignUpOTPUIState extends State<MaleSignUpOTPUI> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF5B7C99);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF2D3436), size: 24.sp),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // Updated Icon from Assets
              Center(
                child: Container(
                  width: 140.w,
                  height: 140.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withOpacity(0.15),
                        blurRadius: 30.r,
                        spreadRadius: 5.r,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/icons/verifycomplite.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              Text(
                'Verify Your Email',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                'We have sent a 4-digit code to your email.\nPlease enter it below to continue.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: const Color(0xFF636E72),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 30.h),

              // Email Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.email_outlined, size: 16.sp, color: themeColor.withOpacity(0.6)),
                    SizedBox(width: 8.w),
                    Text(
                      'a*****@gmail.com',
                      style: GoogleFonts.inter(fontSize: 13.sp, color: const Color(0xFF2D3436)),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.circle, size: 4.sp, color: const Color(0xFFF1C40F)),
                  ],
                ),
              ),
              SizedBox(height: 40.h),

              // Workable OTP Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildOTPBox(index, themeColor)),
              ),
              SizedBox(height: 15.h),
              Text(
                'ENTER 4-DIGIT CODE',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade400,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 40.h),

              // Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time, size: 18.sp, color: Colors.grey.shade400),
                  SizedBox(width: 8.w),
                  Text(
                    'Code expires in ',
                    style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey.shade600),
                  ),
                  Text(
                    '02:47',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp, 
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),

              // Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.maleLocationAccess),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.help_outline, size: 18.sp, color: Colors.white),
                      SizedBox(width: 8.w),
                      Text(
                        'Verify & Continue',
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
              SizedBox(height: 30.h),

              // Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey.shade600),
                  ),
                  Text(
                    'Resend',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: themeColor,
                      fontWeight: FontWeight.bold,
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

  Widget _buildOTPBox(int index, Color themeColor) {
    return Container(
      width: 65.w,
      height: 75.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: themeColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: GoogleFonts.playfairDisplay(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: themeColor,
          ),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}
