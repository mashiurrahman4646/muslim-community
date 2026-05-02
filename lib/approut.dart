import 'package:get/get.dart';
import 'package:muslim_community/female_role/auth/ui/IdentityVerification.dart';
import 'package:muslim_community/female_role/auth/ui/location_access.dart';
import 'package:muslim_community/female_role/auth/ui/login.dart';
import 'package:muslim_community/female_role/auth/ui/signup.dart';
import 'package:muslim_community/female_role/auth/ui/signupotp.dart';
import 'package:muslim_community/female_role/auth/ui/verification_complete.dart';
import 'package:muslim_community/jummarole/auth/ui/login.dart';
import 'package:muslim_community/jummarole/auth/ui/signup.dart';
import 'package:muslim_community/jummarole/auth/ui/signupotp.dart';
import 'package:muslim_community/male_role/auth/ui/IdentityVerification.dart';
import 'package:muslim_community/male_role/auth/ui/location_access.dart';
import 'package:muslim_community/male_role/auth/ui/login.dart';
import 'package:muslim_community/male_role/auth/ui/signup.dart';
import 'package:muslim_community/male_role/auth/ui/signupotp.dart';
import 'package:muslim_community/male_role/auth/ui/verification_complete.dart';
import 'package:muslim_community/selecterole/selecteroleui.dart';
import 'package:muslim_community/splashscreen/splashscreen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String selectRole = '/selectRole';
  
  static const String femaleSignUp = '/femaleSignUp';
  static const String maleSignUp = '/maleSignUp';
  static const String jummaSignUp = '/jummaSignUp';
  
  static const String femaleLogin = '/femaleLogin';
  static const String maleLogin = '/maleLogin';
  static const String jummaLogin = '/jummaLogin';

  static const String femaleLocationAccess = '/femaleLocationAccess';
  static const String maleLocationAccess = '/maleLocationAccess';

  static const String femaleSignUpOTP = '/femaleSignUpOTP';
  static const String maleSignUpOTP = '/maleSignUpOTP';
  static const String jummaSignUpOTP = '/jummaSignUpOTP';

  static const String femaleIdentityVerification = '/femaleIdentityVerification';
  static const String maleIdentityVerification = '/maleIdentityVerification';

  static const String femaleVerificationComplete = '/femaleVerificationComplete';
  static const String maleVerificationComplete = '/maleVerificationComplete';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: selectRole, page: () => const SelecteRoleUI()),
    
    // Female Auth
    GetPage(name: femaleSignUp, page: () => const FemaleSignUpUI()),
    GetPage(name: femaleLogin, page: () => const FemaleLoginUI()),
    GetPage(name: femaleLocationAccess, page: () => const FemaleLocationAccessUI()),
    GetPage(name: femaleSignUpOTP, page: () => const FemaleSignUpOTPUI()),
    GetPage(name: femaleIdentityVerification, page: () => const FemaleIdentityVerificationUI()),
    GetPage(name: femaleVerificationComplete, page: () => const FemaleVerificationCompleteUI()),

    // Male Auth
    GetPage(name: maleSignUp, page: () => const MaleSignUpUI()),
    GetPage(name: maleLogin, page: () => const MaleLoginUI()),
    GetPage(name: maleLocationAccess, page: () => const MaleLocationAccessUI()),
    GetPage(name: maleSignUpOTP, page: () => const MaleSignUpOTPUI()),
    GetPage(name: maleIdentityVerification, page: () => const MaleIdentityVerificationUI()),
    GetPage(name: maleVerificationComplete, page: () => const MaleVerificationCompleteUI()),

    // Jumma Auth
    GetPage(name: jummaSignUp, page: () => const JummaSignUpUI()),
    GetPage(name: jummaLogin, page: () => const JummaLoginUI()),
    GetPage(name: jummaSignUpOTP, page: () => const JummaSignUpOTPUI()),
  ];
}
