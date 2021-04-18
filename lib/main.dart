import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jaansay_public_user/providers/catalog_provider.dart';
import 'package:jaansay_public_user/providers/coupon_provider.dart';
import 'package:jaansay_public_user/providers/grievance_provider.dart';
import 'package:jaansay_public_user/providers/official_feed_provider.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/providers/user_feed_provider.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/screens/splash_screen.dart';
import 'package:jaansay_public_user/service/dynamic_link_service.dart';
import 'package:provider/provider.dart';

GetIt getIt = GetIt.instance;

void main() async {
  GetIt.I.registerLazySingleton(() => DynamicLinkService());
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

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
        ChangeNotifierProvider<CouponProvider>(create: (_) => CouponProvider()),
        ChangeNotifierProvider<CatalogProvider>(
            create: (_) => CatalogProvider()),
        ChangeNotifierProvider<GrievanceProvider>(
            create: (_) => GrievanceProvider()),
      ],
      child: EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('kn', 'IN')],
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
        primaryColorLight: Color(0xffFBEBE6),
        accentColor: Colors.amber,
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        fontFamily: GoogleFonts.poppins().fontFamily,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Color(0xffDF5D37),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
