import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/grievance/grievance_history_screen.dart';
import 'package:jaansay_public_user/screens/grievance/grievance_send_screen.dart';

class GrievanceScreen extends StatefulWidget {
  @override
  _GrievanceScreenState createState() => _GrievanceScreenState();
}

class _GrievanceScreenState extends State<GrievanceScreen> {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: AppBar(
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(tabs: [
                    Tab(
                      text: "Send",
                    ),
                    Tab(
                      text: "History",
                    ),
                  ]),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              GrievanceSendScreen(),
              GrievanceHistoryScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
