import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:jaansay_public_user/screens/feed/feed_add_screen.dart';
import 'package:jaansay_public_user/screens/feed/image_view_screen.dart';
import 'package:jaansay_public_user/screens/feed/pdf_view_screen.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/screens/login_signup/login_screen.dart';

GetIt getIt = GetIt.instance;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff368df6),
        primaryColorDark: Color(0xff1E4072),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: {
        PDFViewScreen.routeName: (context) => PDFViewScreen(),
        ImageViewScreen.routeName: (context) => ImageViewScreen(),
        FeedAddScreen.routeName: (context) => FeedAddScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
      },
    );
  }
}
