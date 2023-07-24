import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../../utils/utils.dart';

class ChatHistory extends StatelessWidget {
  const ChatHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, false);
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 25.5),
        height: dimension['height']! - 120,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back)),
                const Text(
                  "Chat History",
                  style: TextStyle(fontSize: 20),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Remix.close_circle_line,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
