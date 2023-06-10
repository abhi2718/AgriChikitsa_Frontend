import 'package:agriChikitsa/screens/tab.screens/hometab.screen/widgets/feed.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import './hometab_view_model.dart';
import '../../../services/auth.dart';
import 'widgets/header.dart';

class _AppLifecycleObserver extends WidgetsBindingObserver {
  final ValueChanged<AppLifecycleState> onAppLifecycleStateChanged;

  _AppLifecycleObserver(this.onAppLifecycleStateChanged);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    onAppLifecycleStateChanged(state);
  }
}

class HomeTabScreen extends HookWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final appLifecycleState = useState(AppLifecycleState.resumed);
    final useViewModel = useMemoized(
        () => Provider.of<HomeTabViewModel>(context, listen: false));
    final authService = Provider.of<AuthService>(context, listen: false);
    
    useEffect(() {
      useViewModel.getUserProfile(authService);
    }, []);

    useEffect(() {
      final binding = WidgetsBinding.instance;
      final observer = _AppLifecycleObserver((state) {
        appLifecycleState.value = state;
        if (state == AppLifecycleState.resumed) {
          Future.delayed(Duration.zero, () {
            useViewModel.fetchFeeds(context);
          });
        }
      });
      binding.addObserver(observer);
      return () => binding.removeObserver(observer);
    }, []);

    useEffect(() {
      Future.delayed(Duration.zero, () {
        useViewModel.fetchFeeds(context);
        useViewModel.fetchFeedsCategory(context);
      });
    }, []);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const HeaderWidget(),
              SizedBox(
                height: dimension['height']! - 100,
                child: Consumer<HomeTabViewModel>(
                    builder: (context, provider, child) {
                  return ListView.builder(
                    itemCount: provider.feedList.length,
                    itemBuilder: (context, index) {
                      final feed = provider.feedList[index];
                      return Feed(
                        feed: feed,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
