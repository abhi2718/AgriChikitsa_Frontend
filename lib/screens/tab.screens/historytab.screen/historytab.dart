import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../../widgets/text.widgets/text.dart';
import './widgets/history_card.dart';
import './history_tab_view_model.dart';

class HistortTabScreen extends HookWidget {
  const HistortTabScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<HistoryTabViewModel>(context, listen: true));
    useEffect(() {
      Future.delayed(Duration.zero, () {
        useViewModel.fetchTaskHistory(context);
      });
    }, []);
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: dimension["height"]!,
          child: Column(
            children: [
              SizedBox(
                width: dimension["width"],
                height: 16,
              ),
              const HeadingText("History"),
              const SizedBox(
                height: 20,
              ),
              useViewModel.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      height: dimension["height"]! - 80,
                      child: ListView.builder(
                        itemBuilder: ((context, index) {
                          return HistoryCard(
                            data: useViewModel.taskHistory[index],
                          );
                        }),
                        itemCount: useViewModel.taskHistory.length,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
