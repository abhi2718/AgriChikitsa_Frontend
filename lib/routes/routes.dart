import 'package:agriChikitsa/screens/tab.screens/hometab.screen/createPost.screen/createPost.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofilescreen.dart';
import 'package:flutter/material.dart';
import '../screens/auth.screen/auth.landing/landing.dart';
import '../screens/auth.screen/signin.auth/otp_Verification.dart';
import '../screens/auth.screen/signin.auth/signin.dart';
import '../screens/auth.screen/signup.auth/signup.dart';
import '../screens/splash_screen.dart';
import '../screens/tab.screens/chattab.screen/chattab.dart';
import '../screens/tab.screens/profiletab.screen/edit_profile/edit_profile.dart';
import '../screens/tab.screens/tab_screen.dart';
import './routes_name.dart';

class Routes {
  Map<String, Widget Function(BuildContext)> routes = {
    RouteName.splashRoute: (context) => const SplashScreen(),
    RouteName.signInRoute: (context) => const SignInScreen(),
    RouteName.homeRoute: (context) => const TabScreen(),
    RouteName.authLandingRoute: (context) => const LandingAuthScreen(),
    RouteName.otpVerificationRoute: (context) => const OtpVerification(),
    RouteName.signUpRoute: (context) => const SignUpScreen(),
    RouteName.editProfileRoute: (context) => const EditProfileScreen(),
    RouteName.createPostRoute: (context) => const CreatePostScreen(),
    RouteName.chatBotRoute: (context) => const ChatTabScreen(),
    RouteName.myProfileScreenRoute: (context) => const MyProfileScreen(),
  };
}
