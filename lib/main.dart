import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/models/feed_resource.dart';
import 'package:jaansay_public_user/screens/feed/feedDetailScreen.dart';
import 'package:jaansay_public_user/screens/feed/homeScreen.dart';
import 'package:jaansay_public_user/screens/feed/image_view_screen.dart';
import 'package:jaansay_public_user/screens/feed/pdf_view_screen.dart';
import 'package:jaansay_public_user/widgets/feed/feedDetails.dart';

GetIt getIt = GetIt.instance;
void main() {
  getIt.registerSingleton<FeedResource>(FeedResource(), signalsReady: true);
  getIt.registerSingleton<Feed>(Feed(), signalsReady: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FeedDetails(),
      routes: {
        FeedDetailScreen.routeName: (context) => FeedDetailScreen(),
        PDFViewScreen.routeName: (context) => PDFViewScreen(),
        ImageViewScreen.routeName: (context) => ImageViewScreen(),
      },
    );
  }
}
