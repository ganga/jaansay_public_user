import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/market/offer_screen.dart';

class MarketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: AppBar(
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(tabs: [
                  Tab(
                    text: "Offers",
                  ),
                  Tab(
                    text: "Community Req",
                  ),
                ]),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            OfferScreen(),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
