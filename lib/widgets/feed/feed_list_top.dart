import 'package:flutter/material.dart';

class FeedListTop extends StatelessWidget {
  FeedListTop({Key key, @required this.mediaQuery}) : super(key: key);
  final Size mediaQuery;

  Row buildLeftRow(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: Image.network(
              "https://cdn.fastly.picmonkey.com/contentful/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=800&q=70",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Alice Josh",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              "#public_user",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: mediaQuery.height * 0.1,
      width: mediaQuery.width * 0.9,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildLeftRow(context),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Text(
                  "Accept",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Text("Reject"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
