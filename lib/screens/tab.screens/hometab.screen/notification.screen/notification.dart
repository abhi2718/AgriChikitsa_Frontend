import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/hometab_view_model.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/text.widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

class _AppLifecycleObserver extends WidgetsBindingObserver {
  final ValueChanged<AppLifecycleState> onAppLifecycleStateChanged;

  _AppLifecycleObserver(this.onAppLifecycleStateChanged);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    onAppLifecycleStateChanged(state);
  }
}

class NoticationScreen extends HookWidget {
  const NoticationScreen({super.key});

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

    return Scaffold(
      appBar: AppBar(
        title: const BaseText(
          title: 'Notification',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Remix.arrow_left_line,
              color: Colors.black,
            )),
      ),
      body: ClipRRect(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Container(
              height: 90,
              width: dimension['width']! - 20,
              decoration: const BoxDecoration(
                color: Color(0xffd9d9d9),
                borderRadius: BorderRadius.all(
                  Radius.circular(18.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(),
                      ],
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseText(
                          title: 'New Notification',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColor.darkBlackColor,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        BaseText(
                          title:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit\ndolor sit amet, consectetur adipiscing elit.  ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColor.darkBlackColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
