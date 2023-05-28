import 'dart:async';
import 'dart:convert';
import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/routes_name.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    Future<bool> isAuthenticated() async {
      final localStorage = await SharedPreferences.getInstance();
      final rawProfile = localStorage.getString('profile');
      if (rawProfile == null) {
        return false;
      }
      final profile = jsonDecode(rawProfile);
      authService.setUser(profile);
      return true;
    }
    useEffect(() {
      const duration = Duration(milliseconds: 2000);
      final timmer = Timer(duration, () {
        isAuthenticated().then((isAuth) {
          if (isAuth) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(RouteName.homeRoute, (route) => false);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                RouteName.authLandingRoute, (route) => false);
          }
        });
      });
      return () => timmer.cancel();
    }, []);
    
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(
          height: 300,
        ),
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(80.0),
            child: Image.asset(
              "assets/images/logoagrichikitsa.png",
              height: 160,
              width: 160,
            ),
          ),
        ),
        AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'फसलो की सुरझा',
              textStyle:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ],
          onTap: null,
          isRepeatingAnimation: false,
          totalRepeatCount: 1,
        ),
        AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'AGRICHIKITSA',
              textStyle: const TextStyle(
                  fontSize: 40,
                  color: AppColor.extraDark,
                  fontWeight: FontWeight.w800),
            ),
          ],
          onTap: null,
          isRepeatingAnimation: false,
          totalRepeatCount: 1,
        )
      ]),
    );
  }
}
