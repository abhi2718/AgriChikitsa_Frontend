import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:agriChikitsa/widgets/card.widgets/card.dart';
import 'package:provider/provider.dart';
import '../../../services/auth.dart';
import '../../../services/socket_io.dart';
import '../../../widgets/text.widgets/text.dart';
import './hometab_view_model.dart';
import './widgets/task_card.dart';
import './widgets/empty_task_card.dart';

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
    final socketService =
        useMemoized(() => Provider.of<SocketService>(context, listen: true));
    final authService = Provider.of<AuthService>(context, listen: false);

    useEffect(() {
      useViewModel.getUserProfile(authService);
      useViewModel.initializeSocket(socketService);
      Future.delayed(Duration.zero, () {
        useViewModel.fetchAssignedTasks(context, authService);
      });
    }, []);

    useEffect(() {
      Future.delayed(Duration.zero, () {
        useViewModel.handleAssignedTask(socketService, authService);
      });
    }, [socketService.newTask]);

    useEffect(() {
      final binding = WidgetsBinding.instance;
      final observer = _AppLifecycleObserver((state) {
        appLifecycleState.value = state;
        if (state == AppLifecycleState.resumed) {
          Future.delayed(Duration.zero, () {
            useViewModel.fetchAssignedTasks(context, authService);
          });
        }
      });
      binding.addObserver(observer);
      return () => binding.removeObserver(observer);
    }, []);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Consumer<HomeTabViewModel>(builder: (context, provider, child) {
                return LightContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          provider.isOnline
                              ? const HeadingText("Online")
                              : const HeadingText("Offline"),
                          provider.isOnline
                              ? const ParagraphText("You will receive task ")
                              : const ParagraphText("Go online to receive task")
                        ],
                      ),
                      Switch(
                        value: provider.isOnline,
                        onChanged: (value) =>
                            provider.handleSwitchToggle(value, socketService),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),
              const HeadingText("Today Task"),
              const SizedBox(
                height: 16,
              ),
              Consumer<HomeTabViewModel>(builder: (context, provider, child) {
                if (provider.loading) {
                  return const LightContainer(
                    child: SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                } else {
                  return useViewModel.assignedTask != null
                      ? TaskCard(
                          assignedTasks: provider.assignedTask,
                          socketService: socketService,
                        )
                      : const EmpatyTaskCard();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
