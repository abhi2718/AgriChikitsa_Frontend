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
      child: Opacity(
        opacity: 0.55,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          width: dimension['width']! * 0.90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 1.0,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BaseText(
                  title: title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
