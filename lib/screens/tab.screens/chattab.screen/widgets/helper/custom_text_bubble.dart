import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomTextBubble extends StatelessWidget {
  const CustomTextBubble({super.key, required this.text, required this.isSender});
  final String text;
  final bool isSender;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Container(
      alignment: !isSender ? Alignment.centerLeft : Alignment.centerRight,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: !isSender
          ? Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: const AssetImage('assets/images/botIcon.png'),
                  radius: dimension['height']! * 0.035,
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xffB6D6BD),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      text,
                      style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xffB6D6BD),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      text,
                      style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Consumer<AuthService>(builder: (context, provider, child) {
                  return CircleAvatar(
                    backgroundImage: provider.userInfo != null
                        ? NetworkImage(provider.userInfo["user"]['profileImage'])
                        : const NetworkImage(
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                    radius: dimension['height']! * 0.035,
                  );
                }),
              ],
            ),
    );
  }
}
