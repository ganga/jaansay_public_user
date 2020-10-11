import 'package:flutter/material.dart';

class PublicProfileHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _mediaQuery.width * 0.06,
            vertical: _mediaQuery.height * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  height: _mediaQuery.width * 0.2,
                  width: _mediaQuery.width * 0.2,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.network(
                      "https://cdn.fastly.picmonkey.com/contentful/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=800&q=70",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: _mediaQuery.width * 0.05,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Alice Josh",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: "201",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        TextSpan(text: " posts"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                      "I am a tech enthusiast, looking for work in and around my locality. I have 12 years of experience in IT industry.")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
