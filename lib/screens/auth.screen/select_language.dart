import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/auth.screen/language_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../tab.screens/profiletab.screen/profile_view_model.dart';

class SelectLanguage extends HookWidget {
  const SelectLanguage({super.key, required this.phoneNumber, required this.firebaseId});
  final String phoneNumber;
  final String firebaseId;
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final languageViewModel = Provider.of<LanguageViewModel>(context, listen: false);
    useEffect(() {
      languageViewModel.getLocaleLanguage();
    }, []);
    return Consumer<LanguageViewModel>(
      builder: (context, provider, child) {
        return provider.langLoader
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: AppColor.extraDark,
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text(
                    provider.lang == "en" ? "Change Language" : "भाषा बदलें",
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                body: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 26),
                          height: 40,
                          width: 7,
                          decoration: const BoxDecoration(
                              color: AppColor.extraDark,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8), bottomRight: Radius.circular(8))),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.lang == "en" ? "English" : "हिंदी",
                              style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.extraDark),
                            ),
                            Text(
                              provider.lang == "en" ? "language selected" : "भाषा चुनी गई",
                              style: GoogleFonts.inter(
                                  fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black87),
                            ),
                          ],
                        )
                      ],
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => provider.unconfirmLocaleChange("en"),
                            child: LanguageCard(
                              dimension: dimension,
                              langCharacter: "A",
                              language: "English",
                              description:
                                  "One stop solution for all your farming needs, welcome to Agrichikitsa.\nThis is how text will appear throughout the application.",
                              isSelected: provider.lang == "en" ? true : false,
                            ),
                          ),
                          InkWell(
                            onTap: () => provider.unconfirmLocaleChange("hi"),
                            child: LanguageCard(
                              dimension: dimension,
                              langCharacter: "अ",
                              language: "हिंदी",
                              description:
                                  "आपकी सभी कृषि आवश्यकताओं के लिए एक स्थान पर समाधान, एग्रीचिकित्सा में आपका स्वागत है.\nऐप में शब्द कुछ इस तरह दिखाई देंगे",
                              isSelected: provider.lang == "hi" ? true : false,
                            ),
                          ),
                        ],
                      ),
                    )),
                    Text(
                      provider.lang == "en"
                          ? "*Changes will not be saved. Please confirm."
                          : "*किए गए परिवर्तन स्वचालित रूप से सहेजे नहीं जाएंगे. कृपया पुष्टि करें",
                      style: GoogleFonts.inter(
                          fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 4),
                      child: InkWell(
                        onTap: () {
                          profileViewModel.handleLocaleChange(context, provider.lang,
                              provider.lang == "en" ? "US" : "IN", phoneNumber, firebaseId);
                        },
                        child: GradientButton(
                            height: dimension["height"]! * 0.09,
                            width: dimension['width']! * 0.8,
                            title: provider.lang == "en" ? "Continue" : "आगे बढ़ें"),
                      ),
                    )
                  ],
                ),
              );
      },
    );
  }
}

class LanguageCard extends StatelessWidget {
  const LanguageCard({
    super.key,
    required this.dimension,
    required this.langCharacter,
    required this.language,
    required this.description,
    required this.isSelected,
  });

  final Map<String, double> dimension;
  final String langCharacter;
  final String language;
  final String description;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.only(bottom: 8),
            width: dimension["width"]! * 0.75,
            decoration: BoxDecoration(
                color:
                    isSelected ? const Color.fromARGB(255, 48, 142, 47) : const Color(0xff154f59),
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 16, left: 12),
                      alignment: Alignment.center,
                      width: 90.0,
                      height: 90.0,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xff09601D) : const Color(0xff0e3d45),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        langCharacter,
                        style: GoogleFonts.inter(
                            fontSize: 62, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 90,
                      width: 100,
                      decoration: BoxDecoration(
                          color: isSelected ? const Color(0xff09601D) : const Color(0xff0e3d45),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(16))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            langCharacter == "अ" ? "भाषा" : "Language",
                            style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                          ),
                          Text(
                            language,
                            style: GoogleFonts.inter(
                                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    description,
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ),
        isSelected
            ? Positioned(
                top: 88,
                right: 20,
                child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff09601D),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ))))
            : Container()
      ],
    );
  }
}
