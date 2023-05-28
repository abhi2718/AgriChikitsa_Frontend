import 'package:flutter/material.dart';

class SmallLogo extends StatelessWidget {
  const SmallLogo({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Image.asset(
        "assets/images/logoSmall.png",
        height: 90,
        width: 90,
      ),
    );
  }
}

class BackIconButton extends StatelessWidget {
  final VoidCallback onTap;
  const BackIconButton({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(
          "assets/images/back.png",
          height: 38,
          width: 38,
        ),
    );
  }
}
