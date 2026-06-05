import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';

class PrayerRecitationPage extends StatelessWidget {
  final String waqt;
  final Color themeColor;

  const PrayerRecitationPage({
    super.key,
    required this.waqt,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.titleColor, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "$waqt Prayer Guide",
          style: GoogleFonts.playfairDisplay(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            _buildPrayerHeader(),
            SizedBox(height: 25.h),
            _buildStepCard(
              stepNumber: "2",
              title: "Takbiratul Ihram",
              arabicTitle: "تكبيرة الإحرام",
              imagePath: null, // Placeholder for image
              instructionTitle: "Standing - Hands Raised",
              instructionDesc: "Raise both hands to ear level, palms facing forward.",
              whatToDo: [
                "Raise your hands up to your ears",
                "Say 'Allahu Akbar' clearly — this sacred phrase begins your prayer.",
                "Nothing in the world should distract now."
              ],
              recitationTitle: "Allahu Akbar",
              recitationTranslation: "\"Allah is the Greatest\"",
              recitationArabic: "اللَّهُ أَكْبَرُ",
              isRecitationDark: true,
            ),
            SizedBox(height: 20.h),
            _buildStepCard(
              stepNumber: "3",
              title: "Qiyam (Standing)",
              arabicTitle: "القيام",
              imagePath: null,
              instructionTitle: "RECITE: OPENING DUA (OPTIONAL)",
              instructionDesc: "",
              whatToDo: [],
              recitationTitle: "",
              recitationTranslation: "Subhānaka Allāhumma wa biHamdika, wa tabāraKasmuka, wa ta'āLā jadduka, wa lā ilāha ghayruk\n\n\"Glory be to You, O Allah, and praise. Blessed is Your name, exalted is Your majesty, and there is no god but You.\"",
              recitationArabic: "سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، وَتَبَارَكَ اسْمُكَ، وَتَعَالَىٰ جَدُّكَ، وَلَا إِلَٰهَ غَيْرُكَ",
              isRecitationDark: false,
              extraContent: _buildSurahFatihah(),
            ),
            SizedBox(height: 20.h),
            _buildStepCard(
              stepNumber: "4",
              title: "Ruku (Bowing)",
              arabicTitle: "الركوع",
              imagePath: null,
              instructionTitle: "Bowing - Hands on Knees",
              instructionDesc: "Bow from waist, back straight and parallel to ground, hands gripping knees.",
              whatToDo: [
                "Say \"Allahu Akbar\" while going down",
                "Bow from the waist — keep your back straight",
                "Place hands firmly on your knees",
                "Head should be in line with your back",
                "Say the dhikr 3 times (minimum once)"
              ],
              recitationTitle: "Subhāna Rabbiyal-'aZeem",
              recitationTranslation: "Glory be to my Lord, the Most Great\nSay this 3 times",
              recitationArabic: "سُبْحَانَ رَبِّيَ الْعَظِيمِ",
              isRecitationDark: false,
            ),
            SizedBox(height: 20.h),
            _buildStepCard(
              stepNumber: "5",
              title: "Rise from Ruku",
              arabicTitle: "القومه",
              imagePath: null,
              instructionTitle: "Standing Upright Again",
              instructionDesc: "Rise to full standing position, hands by your sides briefly.",
              whatToDo: [
                "Rise to full standing position",
                "Say 'Sami'allahu liman Hamidah' while rising",
                "Keep your back straight and eyes on prostration spot"
              ],
              recitationTitle: "Sami'allâhu liman Hamîdah",
              recitationTranslation: "\"Allah hears whoever praises Him\"",
              recitationArabic: "سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ",
              isRecitationDark: false,
              extraContent: _buildRabbanaWalakalHamd(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerHeader() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  waqt,
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleColor,
                  ),
                ),
                Text(
                  "Dawn (before sunrise)",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.bodyColor,
                  ),
                ),
              ],
            ),
          ),
          _buildHeaderInfo("2", "Rakahs"),
          SizedBox(width: 15.w),
          _buildHeaderInfo("Sunnah", "2 before"),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(String val, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            val,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: AppColors.bodyColor),
        ),
      ],
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required String arabicTitle,
    String? imagePath,
    required String instructionTitle,
    required String instructionDesc,
    required List<String> whatToDo,
    required String recitationTitle,
    required String recitationTranslation,
    required String recitationArabic,
    bool isRecitationDark = false,
    Widget? extraContent,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Header
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: const Color(0xFFE0F7F3),
                  child: Text(
                    stepNumber,
                    style: TextStyle(
                      color: const Color(0xFF26A69A),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor,
                      ),
                    ),
                    Text(
                      arabicTitle,
                      style: GoogleFonts.amiri(
                        fontSize: 14.sp,
                        color: const Color(0xFF26A69A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Instruction Image & Text
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: const Center(child: Icon(Icons.image, color: Colors.grey)),
                ),
                SizedBox(height: 15.h),
                Center(
                  child: Column(
                    children: [
                      Text(
                        instructionTitle,
                        style: TextStyle(
                          color: const Color(0xFF76FF03),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      if (instructionDesc.isNotEmpty)
                        Text(
                          instructionDesc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.bodyColor,
                            fontSize: 12.sp,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // What to do section
          if (whatToDo.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                "WHAT TO DO:",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            ...whatToDo.map((item) => Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.chevron_right, color: const Color(0xFF76FF03), size: 18.sp),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(fontSize: 13.sp, color: AppColors.titleColor),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
          // Recite section
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "RECITE:",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: isRecitationDark ? const Color(0xFF121212) : const Color(0xFFF0FDFB),
                    borderRadius: BorderRadius.circular(15.r),
                    border: isRecitationDark ? null : Border.all(color: const Color(0xFF26A69A).withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      if (recitationTitle.isNotEmpty)
                        Text(
                          recitationTitle,
                          style: TextStyle(
                            color: const Color(0xFF26A69A),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      Text(
                        recitationTranslation,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isRecitationDark ? Colors.grey : AppColors.bodyColor,
                          fontSize: 12.sp,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        recitationArabic,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.amiri(
                          color: isRecitationDark ? Colors.white : AppColors.titleColor,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (extraContent != null) extraContent,
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  Widget _buildSurahFatihah() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "THEN: SURAH AL-FATIHAH (REQUIRED)",
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF26A69A),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDFB),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: const Color(0xFF26A69A).withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Text(
                  "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\nالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ\nالرَّحْمَنِ الرَّحِيمِ\nمَالِكِ يَوْمِ الدِّينِ\nإِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\nاهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ\nصِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.8,
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  "Bismillāhir-raḥmānir-raḥīm. Al-ḥamdu lillāhi rabbil-ʿālamīn. Ar-raḥmānir-raḥīm. Māliki yawmid-dīn. Iyyāka naʿbudu wa iyyāka nastaʿīn. Ihdināṣ-ṣirāṭal-mustaqīm. ṣirāṭallaḏīna anʿamta ʿalayhim, ghayril-maghḍūbi ʿalayhim walaḍ-ḍāllīn. (Āmeen)",
                  style: TextStyle(fontSize: 11.sp, color: AppColors.bodyColor, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRabbanaWalakalHamd() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "THEN:",
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDFB),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: const Color(0xFF26A69A).withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Text(
                  "Rabbanâ wa lakal-Hamd",
                  style: TextStyle(color: const Color(0xFF26A69A), fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                Text(
                  "\"Our Lord, to You is all praise\"",
                  style: TextStyle(color: AppColors.bodyColor, fontSize: 12.sp, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 10.h),
                Text(
                  "رَبَّنَا وَلَكَ الْحَمْدُ",
                  style: GoogleFonts.amiri(fontSize: 22.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
