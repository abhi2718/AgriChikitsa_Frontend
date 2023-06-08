import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/jankari_card.dart';
import 'package:flutter/material.dart';

class JankariHomeTab extends StatefulWidget {
  const JankariHomeTab({super.key});

  @override
  State<JankariHomeTab> createState() => _JankariHomeTabState();
}

class _JankariHomeTabState extends State<JankariHomeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JankariCard(),
    );
  }
}
