import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';

import '../../../../../../utils/utils.dart';

class FieldDetails extends StatelessWidget {
  const FieldDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DetailCards(
            dimension: dimension,
            title: "Report No:",
            value: "226SAI",
          ),
          DetailCards(
            dimension: dimension,
            title: "Report No:",
            value: "226SAI",
          ),
          DetailCards(
            dimension: dimension,
            title: "Report No:",
            value: "226SAI",
          ),
          DetailCards(
            dimension: dimension,
            title: "Report No:",
            value: "226SAI",
          ),
          DetailCards(
            dimension: dimension,
            title: "Report No:",
            value: "226SAI",
          ),
        ],
      ),
    );
  }
}

class DetailCards extends StatelessWidget {
  const DetailCards({
    super.key,
    required this.dimension,
    required this.title,
    required this.value,
  });

  final Map<String, double> dimension;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      height: dimension["height"]! * 0.06,
      width: dimension["width"]! * 0.25,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xffBEFFC5), Color(0xffFFFFFF00)]),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.extraDark)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
