import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/feed/top_details.dart';

class AlertScreen extends StatelessWidget {
  Widget alertTile() {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            TopDetails(),
            SizedBox(
              height: 12,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                  "Dengue alert in your area. Please keep your windows closed after 5PM. Use anti mosquito spray."),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
        body: ListView.builder(
      itemBuilder: (context, index) {
        return alertTile();
      },
      itemCount: 8,
    ));
  }
}
