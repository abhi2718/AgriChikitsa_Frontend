import 'package:flutter/material.dart';

import '../../../../../utils/utils.dart';
import '../../../../../widgets/text.widgets/text.dart';

class EmptyDetailsList extends StatelessWidget {
  const EmptyDetailsList({super.key, required this.onTap, required this.title});
  final Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: dimension['width']! * 0.90,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.grey[400]!,
              blurRadius: 1.0,
              spreadRadius: 1,
              offset: const Offset(0, 3))
        ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: DropdownButton(
            hint: BaseText(
              title: title,
              style: const TextStyle(),
            ),
            value: null,
            alignment: AlignmentDirectional.centerStart,
            isExpanded: true,
            underline: Container(),
            items: const [],
            onChanged: (value) {}),
      ),
    );
  }
}
