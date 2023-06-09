import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';

class JankariCard extends StatefulWidget {
  const JankariCard({super.key});

  @override
  State<JankariCard> createState() => _JankariCardState();
}

class _JankariCardState extends State<JankariCard> {
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 60, right: 10, left: 10),
          child: Container(
            height: 110,
            width: 357,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gehu.png'),
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    height: 50,
                    image: AssetImage('assets/images/laef.png'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BaseText(
                        title: 'Know Your crop',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColor.whiteColor),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BaseText(
                        title:
                            'Get to know about seeding,irrigation\nHarvesting etc of any crop',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColor.whiteColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
