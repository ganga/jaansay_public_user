import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class ProfileListScreen extends StatelessWidget {
  Widget profileCard() {
    return Column(
      children: [
        Expanded(
          child: ClipPolygon(
            sides: 6,
            borderRadius: 5.0,
            // Default 0.0 degrees
            rotate: 90.0,
            // Default 0.0 degrees
            boxShadows: [
              PolygonBoxShadow(color: Colors.black, elevation: 1.0),
              PolygonBoxShadow(color: Colors.grey, elevation: 5.0)
            ],
            child: Image.network(
              "https://cdn.fastly.picmonkey.com/contentful/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=800&q=70",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text("Alice Josh")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: GridView.builder(
        itemCount: 32,
        padding: EdgeInsets.symmetric(
            horizontal: _mediaQuery.width * 0.03,
            vertical: _mediaQuery.height * 0.02),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: _mediaQuery.width * 0.03,
            mainAxisSpacing: _mediaQuery.height * 0.02),
        itemBuilder: (context, index) {
          return profileCard();
        },
      ),
    );
  }
}
