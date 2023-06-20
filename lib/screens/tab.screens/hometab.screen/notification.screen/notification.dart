import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class NoticationScreen extends StatelessWidget {
  const NoticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Scaffold(
      appBar: AppBar(
        title: const BaseText(
          title: 'Notification',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Remix.arrow_left_line,
              color: Colors.black,
            )),
      ),
      body: ClipRRect(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Container(
              height: 90,
              width: dimension['width']! - 20,
              decoration: const BoxDecoration(
                color: Color(0xffd9d9d9),
                borderRadius: BorderRadius.all(
                  Radius.circular(18.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(),
                      ],
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseText(
                          title: 'New Notification',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColor.darkBlackColor,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        BaseText(
                          title:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit\ndolor sit amet, consectetur adipiscing elit.  ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColor.darkBlackColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
