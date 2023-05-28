import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import '../../../../widgets/card.widgets/card.dart';

class EmpatyTaskCard extends HookWidget {
  const EmpatyTaskCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LightContainer(
      child: SizedBox(
        height: 250,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            ParagraphHeadingText("No New task assigned yet !"),
            SizedBox(
              height: 20,
            ),
            ParagraphText(
              "When a new task is assigned, it will be displayed here. To receive the task, make sure you are online and connect to the Internet",
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
