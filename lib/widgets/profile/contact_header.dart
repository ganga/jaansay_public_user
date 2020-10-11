import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jaansay_public_user/screens/community/review_screen.dart';

class ContactHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: _mediaQuery.width * 0.18,
            width: _mediaQuery.width * 0.18,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Image.network(
                "https://cdn.fastly.picmonkey.com/contentful/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=800&q=70",
                fit: BoxFit.cover,
              ),
            ),
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
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReviewScreen()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                        width: 5,
                      ),
                      Text(
                        "(324)",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 13),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text("Timings: 9:00AM to 5:00PM"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
