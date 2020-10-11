import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jaansay_public_user/screens/community/profile_screen.dart';

class OfferSellerProfile extends StatelessWidget {
  final bool isOffer;

  OfferSellerProfile(this.isOffer);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isOffer ? "Seller Information" : "Posted by",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                      settings: RouteSettings(
                          arguments: isOffer ? "business" : "public"),
                    ),
                  );
                },
                child: Text(
                  "See Profile",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                  settings:
                      RouteSettings(arguments: isOffer ? "business" : "public"),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: _mediaQuery.width * 0.15,
                  width: _mediaQuery.width * 0.15,
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
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      isOffer
                          ? Row(
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
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
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
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13),
                                )
                              ],
                            )
                          : Text(
                              "#public_user",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                      SizedBox(
                        height: _mediaQuery.height * 0.02,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
