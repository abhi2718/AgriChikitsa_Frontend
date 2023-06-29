import 'package:agriChikitsa/l10n/l10n.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/createPost.screen/create_post_model.dart';
import 'package:agriChikitsa/screens/tab.screens/myprofile.screen/myprofile_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/notifications.screen/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './screens/auth.screen/signin.auth/signin_view_model.dart';
//import './services/socket_io.dart';
import './screens/tab.screens/hometab.screen/hometab_view_model.dart';
import './res/primary_swatch.dart';
import './screens/auth.screen/signup.auth/signup_view_model.dart';
import './services/auth.dart';
import './screens/tab.screens/profiletab.screen/profile_view_model.dart';
import 'screens/tab.screens/chattab.screen/chat_tab_view_model.dart';
import './screens/tab.screens/profiletab.screen/edit_profile/edit_profile_view_model.dart';
import './screens/tab.screens/jankaritab.screen/jankari_view_model.dart';
import 'screens/tab.screens/tab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAGfebkdT45UkYPIZZL4EA3rAQDMfpHaCE",
      appId: "1:137132429712:android:0f81a104411dcbf64c6315",
      messagingSenderId: "137132429712",
      projectId: "agrichikitsa-8be74",
    ),
  );
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(const App()));
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInViewModel>(
          create: (_) => SignInViewModel(),
        ),
        ChangeNotifierProvider<SignUpViewModel>(
          create: (_) => SignUpViewModel(),
        ),
        // ChangeNotifierProvider<SocketService>(
        //   create: (_) => SocketService(),
        // ),
        ChangeNotifierProvider<HomeTabViewModel>(
          create: (_) => HomeTabViewModel(),
        ),
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<ProfileViewModel>(
          create: (_) => ProfileViewModel(),
        ),
        //EditProfileViewModel
        ChangeNotifierProvider<ChatTabViewModel>(
          create: (_) => ChatTabViewModel(),
        ),
        ChangeNotifierProvider<EditProfileViewModel>(
          create: (_) => EditProfileViewModel(),
        ),
        //
        ChangeNotifierProvider<JankariViewModel>(
          create: (_) => JankariViewModel(),
        ),
        ChangeNotifierProvider<CreatePostModel>(
          create: (_) => CreatePostModel(),
        ),
        ChangeNotifierProvider<TabViewModel>(
          create: (_) => TabViewModel(),
        ),
        ChangeNotifierProvider<MyProfileViewModel>(
          create: (_) => MyProfileViewModel(),
        ),
        ChangeNotifierProvider<NotificationViewModel>(
          create: (_) => NotificationViewModel(),
        ),
      ],
      child: Consumer<ProfileViewModel>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Agrichikitsa',
            theme: ThemeData(primarySwatch: primaryswatch),
            routes: Routes().routes,
            locale: Locale(
                provider.locale["language"]!, provider.locale["country"]!),
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
          );
        },
      ),
    );
  }
}
