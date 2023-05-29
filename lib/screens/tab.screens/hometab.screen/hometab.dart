import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../services/auth.dart';
import '../../../services/socket_io.dart';
import '../../../widgets/text.widgets/text.dart';
import './hometab_view_model.dart';


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
            
          });
        }
      });
      binding.addObserver(observer);
      return () => binding.removeObserver(observer);
    }, []);
    return  const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
             HeadingText("HomeTab Screen")
            ],
          ),
        ),
      ),
    );
  }
}
