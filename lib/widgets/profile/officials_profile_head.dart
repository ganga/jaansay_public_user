import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/screens/community/contact_screen.dart';
import 'package:jaansay_public_user/screens/community/deals_screen.dart';
import 'package:jaansay_public_user/screens/community/review_screen.dart';
import 'package:jaansay_public_user/widgets/profile/profile_head_button.dart';

class OfficialsProfileHead extends StatefulWidget {
  final String type;

  OfficialsProfileHead(this.type);

  @override
  _OfficialsProfileHeadState createState() => _OfficialsProfileHeadState();
}

class _OfficialsProfileHeadState extends State<OfficialsProfileHead> {
  bool isBusiness = false;

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    if (widget.type == 'business') {
      isBusiness = true;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _mediaQuery.width * 0.06,
            vertical: _mediaQuery.height * 0.03),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        height: 2,
                      ),
                      Text(
                          "I am a tech enthusiast, looking for work in and around my locality. I have 12 years of experience in IT industry."),
                      SizedBox(
                        height: _mediaQuery.height * 0.02,
                      ),
                      if (isBusiness)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProfileHeadButton(_mediaQuery.width * 0.3, "Deals",
                                () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DealsScreen()));
                            }),
                            ProfileHeadButton(
                                _mediaQuery.width * 0.3, "Contact", () {}),
                          ],
                        ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: _mediaQuery.height * 0.01,
            ),
            if (!isBusiness)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ProfileHeadButton(double.infinity, "Programs", () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DealsScreen()));
                    }),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ProfileHeadButton(double.infinity, "Grievance", () {
                      Get.dialog(
                        AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Grievance",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ),
                              Text(
                                  "Please keep your message short and precise."),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                color: Colors.black.withOpacity(0.02),
                                child: TextField(
                                  maxLines: 4,
                                ),
                              ),
                              RaisedButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {},
                                child: Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ProfileHeadButton(double.infinity, "Contact", () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ContactScreen()));
                    }),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
