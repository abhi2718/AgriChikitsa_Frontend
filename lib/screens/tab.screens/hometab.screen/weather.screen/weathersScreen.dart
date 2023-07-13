import 'package:agriChikitsa/screens/tab.screens/hometab.screen/weather.screen/weatherScreenViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../widgets/text.widgets/text.dart';

class WeatherScreen extends HookWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final useViewModel = useMemoized(
        () => Provider.of<WeatherViewModel>(context, listen: false));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
            onTap: () => useViewModel.goBack(context),
            child: const Icon(Icons.arrow_back)),
        title: const BaseText(
          // title: AppLocalizations.of(context)!.createPosthi,
          title: "Birkuniya, M.P",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
        elevation: 0.0,
      ),
    );
  }
}
