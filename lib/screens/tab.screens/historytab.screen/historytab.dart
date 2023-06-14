import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import './history_tab_view_model.dart';

class HistortTabScreen extends HookWidget {
  const HistortTabScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<HistoryTabViewModel>(context, listen: true));
    useEffect(() {
      Future.delayed(Duration.zero, () {});
    }, []);
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: dimension["height"]!,
          child: const Column(
            children: [HeadingText('Chat screen')],
          ),
        ),
      ),
    );
  }
}
