import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/providers/official_feed_provider.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/providers/user_feed_provider.dart';
import 'package:jaansay_public_user/screens/feed/feed_add_screen.dart';
import 'package:jaansay_public_user/screens/feed/image_view_screen.dart';
import 'package:jaansay_public_user/screens/feed/pdf_view_screen.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/screens/login_signup/about_me_screen.dart';
import 'package:jaansay_public_user/screens/login_signup/login_screen.dart';
import 'package:jaansay_public_user/screens/login_signup/otp_verfication_screen.dart';
import 'package:jaansay_public_user/screens/misc/survey_screen.dart';
import 'package:jaansay_public_user/screens/splash_screen.dart';
import 'package:jaansay_public_user/service/auth_service.dart';
import 'package:jaansay_public_user/service/dynamic_link_service.dart';
import 'package:provider/provider.dart';

GetIt getIt = GetIt.instance;

void main() async {
  GetIt.I.registerLazySingleton(() => AuthService());
  GetIt.I.registerLazySingleton(() => DynamicLinkService());
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserFeedProvider>(
            create: (_) => UserFeedProvider()),
        ChangeNotifierProvider<OfficialFeedProvider>(
            create: (_) => OfficialFeedProvider()),
        ChangeNotifierProvider<OfficialProfileProvider>(
            create: (_) => OfficialProfileProvider()),
      ],
      child: EasyLocalization(
        supportedLocales: [Locale('en', 'US')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xffDF5D37),
        primaryColorDark: Color(0xff1E4072),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        PDFViewScreen.routeName: (context) => PDFViewScreen(),
        ImageViewScreen.routeName: (context) => ImageViewScreen(),
        FeedAddScreen.routeName: (context) => FeedAddScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        OtpVerificationScreen.routeName: (context) => OtpVerificationScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
      },
    );
  }
}
