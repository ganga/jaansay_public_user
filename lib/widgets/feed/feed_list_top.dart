import 'package:flutter/material.dart';

class FeedListTop extends StatelessWidget {
  FeedListTop({Key key, @required this.mediaQuery}) : super(key: key);
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaQuery.height * 0.1,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
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
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                height: mediaQuery.height * 0.07,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Text(
                  "What's going on in your locality ? ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          IconButton(icon: Icon(Icons.photo_library), onPressed: () {})
        ],
      ),
    );
  }
}
