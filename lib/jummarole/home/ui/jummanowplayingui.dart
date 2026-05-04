import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class JummaNowPlayingUI extends StatefulWidget {
  const JummaNowPlayingUI({super.key});

  @override
  State<JummaNowPlayingUI> createState() => _JummaNowPlayingUIState();
}

class _JummaNowPlayingUIState extends State<JummaNowPlayingUI> {
  double _currentPosition = 0.4;
  double _currentVolume = 0.7;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF436E50);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: themeColor, size: 18.sp),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Text(
          'NOW PLAYING',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: themeColor,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Khutbah Image
            Center(
              child: Container(
                width: 280.w,
                height: 280.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child: Image.asset(
                    'assets/icons/sun.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            SizedBox(height: 40.h),

            // Title & Speaker
            Text(
              'Finding Peace in Prayer',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 12.r,
                  backgroundImage: const AssetImage('assets/icons/abubakr.png'),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Sheikh Abu Bakr',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.circle, size: 4.sp, color: Colors.grey.shade400),
                SizedBox(width: 8.w),
                Text(
                  'East London Mosque',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 40.h),

            // Player Controls Card
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Progress Bar (Seeking Option)
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4.h,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
                      activeTrackColor: themeColor,
                      inactiveTrackColor: Colors.grey.shade200,
                      thumbColor: const Color(0xFFA6864D),
                    ),
                    child: Slider(
                      value: _currentPosition,
                      onChanged: (v) {
                        setState(() {
                          _currentPosition = v;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('12:45', style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.grey)),
                        Text('24:00', style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.grey)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(icon: Icon(Icons.shuffle, color: const Color(0xFFA6864D), size: 20.sp), onPressed: () {}),
                      IconButton(
                        icon: Icon(Icons.replay_10, color: const Color(0xFF2D3436), size: 24.sp),
                        onPressed: () {
                          setState(() {
                            _currentPosition = (_currentPosition - 0.05).clamp(0.0, 1.0);
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPlaying = !_isPlaying;
                          });
                        },
                        child: Container(
                          width: 65.w,
                          height: 65.w,
                          decoration: BoxDecoration(
                            color: themeColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: themeColor.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isPlaying ? Icons.play_arrow : Icons.pause, 
                            color: Colors.white, 
                            size: 30.sp
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.forward_10, color: const Color(0xFF2D3436), size: 24.sp),
                        onPressed: () {
                          setState(() {
                            _currentPosition = (_currentPosition + 0.05).clamp(0.0, 1.0);
                          });
                        },
                      ),
                      IconButton(icon: Icon(Icons.repeat, color: const Color(0xFFA6864D), size: 20.sp), onPressed: () {}),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // Volume Slider (Volume Option)
            Row(
              children: [
                Icon(Icons.volume_down, color: Colors.grey, size: 20.sp),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.h,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4.r),
                      activeTrackColor: themeColor,
                      inactiveTrackColor: Colors.grey.shade200,
                      thumbColor: const Color(0xFFA6864D),
                    ),
                    child: Slider(
                      value: _currentVolume,
                      onChanged: (v) {
                        setState(() {
                          _currentVolume = v;
                        });
                      },
                    ),
                  ),
                ),
                Icon(Icons.volume_up, color: Colors.grey, size: 20.sp),
              ],
            ),

            SizedBox(height: 30.h),

            // About Section
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.menu_book, color: themeColor, size: 18.sp),
                          SizedBox(width: 10.w),
                          Text(
                            'ABOUT THIS KHUTBAH',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20.sp),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    'In this khutbah, the Sheikh discusses the importance of mindfulness in Salah and how it serves as a spiritual anchor in our busy lives. A reminder to return to prayer with full presence of heart.',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
