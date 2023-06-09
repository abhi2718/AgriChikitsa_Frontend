import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/widgets/jankari_card.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class JankariHomeTab extends HookWidget {
  const JankariHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final dimension = Utils.getDimensions(context, true);
    final appLifecycleState = useState(AppLifecycleState.resumed);
    final authService = Provider.of<AuthService>(context, listen: false);

    final useViewModel = useMemoized(
        () => Provider.of<JankariViewModel>(context, listen: false));
    useEffect(() {
      Future.delayed(Duration.zero, () {
        useViewModel.getJankariCategory(context);
      });
    }, []);

    return Scaffold(body: SingleChildScrollView(
      child: Consumer<JankariViewModel>(
        builder: (context, provider, child) {
          return provider.loading
              ? Container(
                  height: dimension['height'],
                  width: dimension['width'],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final jankari = provider.jankaricatList[index];
                    return JankariCard(jankari: jankari);
                  },
                  itemCount: provider.jankaricatList.length,
                );
        },
      ),
    ));
  }
}
