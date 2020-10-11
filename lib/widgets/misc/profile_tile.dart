import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({Key key, @required this.mediaQuery}) : super(key: key);
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaQuery.height * 0.1,
      width: double.infinity,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: NetworkImage(
              "https://cdn.fastly.picmonkey.com/contentful/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=800&q=70",
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
      ),
    );
  }
}
