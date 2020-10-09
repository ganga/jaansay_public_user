import 'package:flutter/material.dart';

class TopDetails extends StatelessWidget {
  const TopDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            children: [
              Text(
                "Chethan",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                    TextSpan(
                        text: "#public_user",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).primaryColor,
                        )),
                    TextSpan(
                      text: "12 Sep 2020",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                    )
                  ]))
            ],
          ),
        ],
      ),
    );
  }
}
