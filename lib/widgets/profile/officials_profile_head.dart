import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OfficialsProfileHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _mediaQuery.width * 0.06,
            vertical: _mediaQuery.height * 0.03),
        child: Column(
          children: [
            Row(
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
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      RatingBar(
                        itemSize: 20,
                        initialRating: 3.5,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ignoreGestures: true,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                          "I am a tech enthusiast, looking for work in and around my locality. I have 12 years of experience in IT industry."),
                      SizedBox(
                        height: _mediaQuery.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: _mediaQuery.width * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Colors.black54, width: 0.5),
                                color: Colors.black.withOpacity(0.01)),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            child: Text("Deals"),
                          ),
                          Container(
                            width: _mediaQuery.width * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Colors.black54, width: 0.5),
                                color: Colors.black.withOpacity(0.01)),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            child: Text("Contact"),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
