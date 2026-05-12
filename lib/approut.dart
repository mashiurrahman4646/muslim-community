import 'package:get/get.dart';
import 'package:muslim_community/female_role/auth/ui/IdentityVerification.dart';
import 'package:muslim_community/female_role/auth/ui/forgetpasswordemail.dart';
import 'package:muslim_community/female_role/auth/ui/location_access.dart';
import 'package:muslim_community/female_role/auth/ui/login.dart';
import 'package:muslim_community/female_role/auth/ui/otpverificationforforgetpasswod.dart';
import 'package:muslim_community/female_role/auth/ui/signup.dart';
import 'package:muslim_community/female_role/auth/ui/signupotp.dart';
import 'package:muslim_community/female_role/auth/ui/verification_complete.dart';
import 'package:muslim_community/jummarole/auth/ui/forgetpasswordemail.dart';
import 'package:muslim_community/jummarole/auth/ui/forgetpasswordotp.dart';
import 'package:muslim_community/jummarole/auth/ui/login.dart';
import 'package:muslim_community/jummarole/auth/ui/signup.dart';
import 'package:muslim_community/jummarole/auth/ui/signupotp.dart';
import 'package:muslim_community/jummarole/home/ui/jummahomeui.dart';
import 'package:muslim_community/jummarole/home/ui/jummanowplayingui.dart';
import 'package:muslim_community/jummarole/navbar/navbarui.dart';
import 'package:muslim_community/male_role/auth/ui/IdentityVerification.dart';
import 'package:muslim_community/male_role/auth/ui/location_access.dart';
import 'package:muslim_community/male_role/auth/ui/login.dart';
import 'package:muslim_community/male_role/auth/ui/forgetpasswordemail.dart';
import 'package:muslim_community/male_role/auth/ui/forgetpasswordotp.dart';
import 'package:muslim_community/male_role/auth/ui/signup.dart';
import 'package:muslim_community/male_role/auth/ui/signupotp.dart';
import 'package:muslim_community/male_role/auth/ui/verification_complete.dart';
import 'package:muslim_community/selecterole/selecteroleui.dart';
import 'package:muslim_community/splashscreen/splashscreen.dart';
import 'package:muslim_community/male_role/navbar/navbarui.dart';
import 'package:muslim_community/female_role/navbar/navbarui.dart';
import 'package:muslim_community/female_role/notifications/ui/notificationsui.dart';
import 'package:muslim_community/male_role/group/ui/group_details_ui.dart';
import 'package:muslim_community/male_role/group/ui/post_details_ui.dart';
import 'package:muslim_community/female_role/group/ui/group_details_ui.dart';

import 'package:muslim_community/male_role/discover/ui/learning_details_ui.dart';
import 'package:muslim_community/female_role/discover/ui/learning_details_ui.dart';
import 'package:muslim_community/male_role/discover/ui/mosque_details_ui.dart';
import 'package:muslim_community/female_role/discover/ui/mosque_details_ui.dart';

import 'female_role/group/ui/female_post_details_ui.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String selectRole = '/selectRole';

  static const String femaleSignUp = '/femaleSignUp';
  static const String maleSignUp = '/maleSignUp';
  static const String jummaSignUp = '/jummaSignUp';

  static const String femaleLogin = '/femaleLogin';
  static const String maleLogin = '/maleLogin';
  static const String jummaLogin = '/jummaLogin';

  static const String femaleForgetPasswordEmail = '/femaleForgetPasswordEmail';
  static const String femaleForgetPasswordOTP = '/femaleForgetPasswordOTP';
  static const String maleForgetPasswordEmail = '/maleForgetPasswordEmail';
  static const String maleForgetPasswordOTP = '/maleForgetPasswordOTP';
  static const String jummaForgetPasswordEmail = '/jummaForgetPasswordEmail';
  static const String jummaForgetPasswordOTP = '/jummaForgetPasswordOTP';
  static const String jummaNavbar = '/jummaNavbar';
  static const String maleNavbar = '/maleNavbar';
  static const String femaleNavbar = '/femaleNavbar';
  static const String jummaNowPlaying = '/jummaNowPlaying';

  static const String femaleNotifications = '/femaleNotifications';
  static const String femaleLocationAccess = '/femaleLocationAccess';
  static const String maleLocationAccess = '/maleLocationAccess';

  static const String maleGroupDetails = '/maleGroupDetails';
  static const String femaleGroupDetails = '/femaleGroupDetails';
  static const String malePostDetails = '/malePostDetails';
  static const String femalePostDetails = '/femalePostDetails';

  static const String maleLearningDetails = '/maleLearningDetails';
  static const String femaleLearningDetails = '/femaleLearningDetails';

  static const String maleMosqueDetails = '/maleMosqueDetails';
  static const String femaleMosqueDetails = '/femaleMosqueDetails';

  static const String femaleSignUpOTP = '/femaleSignUpOTP';
  static const String maleSignUpOTP = '/maleSignUpOTP';
  static const String jummaSignUpOTP = '/jummaSignUpOTP';

  static const String femaleIdentityVerification =
      '/femaleIdentityVerification';
  static const String maleIdentityVerification = '/maleIdentityVerification';

  static const String femaleVerificationComplete =
      '/femaleVerificationComplete';
  static const String maleVerificationComplete = '/maleVerificationComplete';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: selectRole, page: () => const SelecteRoleUI()),

    // Female Auth
    GetPage(name: femaleSignUp, page: () => const FemaleSignUpUI()),
    GetPage(name: femaleLogin, page: () => const FemaleLoginUI()),
    GetPage(
      name: femaleLocationAccess,
      page: () => const FemaleLocationAccessUI(),
    ),
    GetPage(name: femaleSignUpOTP, page: () => const FemaleSignUpOTPUI()),
    GetPage(
      name: femaleIdentityVerification,
      page: () => const FemaleIdentityVerificationUI(),
    ),
    GetPage(
      name: femaleVerificationComplete,
      page: () => const FemaleVerificationCompleteUI(),
    ),

    // Male Auth
    GetPage(name: maleSignUp, page: () => const MaleSignUpUI()),
    GetPage(name: maleLogin, page: () => const MaleLoginUI()),
    GetPage(name: maleLocationAccess, page: () => const MaleLocationAccessUI()),
    GetPage(name: maleSignUpOTP, page: () => const MaleSignUpOTPUI()),
    GetPage(
      name: maleIdentityVerification,
      page: () => const MaleIdentityVerificationUI(),
    ),
    GetPage(
      name: maleVerificationComplete,
      page: () => const MaleVerificationCompleteUI(),
    ),

    // Jumma Auth
    GetPage(name: jummaSignUp, page: () => const JummaSignUpUI()),
    GetPage(name: jummaLogin, page: () => const JummaLoginUI()),
    GetPage(name: jummaSignUpOTP, page: () => const JummaSignUpOTPUI()),

    // Forget Password
    GetPage(
      name: femaleForgetPasswordEmail,
      page: () => const FemaleForgetPasswordEmailUI(),
    ),
    GetPage(
      name: femaleForgetPasswordOTP,
      page: () => const FemaleForgetPasswordOTPUI(),
    ),
    GetPage(
      name: maleForgetPasswordEmail,
      page: () => const MaleForgetPasswordEmailUI(),
    ),
    GetPage(
      name: maleForgetPasswordOTP,
      page: () => const MaleForgetPasswordOTPUI(),
    ),
    GetPage(
      name: jummaForgetPasswordEmail,
      page: () => const JummaForgetPasswordEmailUI(),
    ),
    GetPage(
      name: jummaForgetPasswordOTP,
      page: () => const JummaForgetPasswordOTPUI(),
    ),
    GetPage(name: jummaNavbar, page: () => const JummaNavbarUI()),
    GetPage(name: maleNavbar, page: () => const MaleNavbarUI()),
    GetPage(name: femaleNavbar, page: () => const FemaleNavbarUI()),
    GetPage(
      name: femaleNotifications,
      page: () => const FemaleNotificationsUI(),
    ),
    GetPage(name: jummaNowPlaying, page: () => const JummaNowPlayingUI()),

    // Group & Posts
    GetPage(name: maleGroupDetails, page: () => const MaleGroupDetailsUI()),
    GetPage(name: femaleGroupDetails, page: () => const FemaleGroupDetailsUI()),
    GetPage(name: malePostDetails, page: () => const MalePostDetailsUI()),
    GetPage(name: femalePostDetails, page: () => const FemalePostDetailsUI()),
    GetPage(
      name: maleLearningDetails,
      page: () => const MaleLearningDetailsUI(),
    ),
    GetPage(
      name: femaleLearningDetails,
      page: () => const FemaleLearningDetailsUI(),
    ),
    GetPage(name: maleMosqueDetails, page: () => const MaleMosqueDetailsUI()),
    GetPage(
      name: femaleMosqueDetails,
      page: () => const FemaleMosqueDetailsUI(),
    ),
  ];
}
