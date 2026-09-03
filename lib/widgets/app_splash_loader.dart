import 'package:agriChikitsa/res/color.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AppSplashLoader extends StatelessWidget {
  final String? subtitle;
  final bool showAnimation;

  const AppSplashLoader({
    super.key,
    this.subtitle,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80.0),
              child: Image.asset(
                "assets/images/logoagrichikitsa.png",
                height: 120,
                width: 120,
              ),
            ),
            const SizedBox(height: 16),
            if (showAnimation)
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    subtitle ?? 'एग्रीचिकित्सा',
                    speed: const Duration(milliseconds: 90),
                    textStyle: const TextStyle(
                      fontSize: 22,
                      color: AppColor.extraDark,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
                isRepeatingAnimation: false,
                totalRepeatCount: 1,
              )
            else
              Text(
                subtitle ?? 'एग्रीचिकित्सा',
                style: const TextStyle(
                  fontSize: 22,
                  color: AppColor.extraDark,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            const SizedBox(height: 28),
            const CircularProgressIndicator(
              color: AppColor.extraDark,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
