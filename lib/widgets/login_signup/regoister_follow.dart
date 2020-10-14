import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterFollow extends StatelessWidget {
  RegisterFollow({Key key, @required this.mediaQuery}) : super(key: key);
  final Size mediaQuery;
  var isFollow = "Follow".obs;
  Color _color = Colors.blue;
  Color _textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaQuery.height * 0.1,
      width: double.infinity,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
          ),
          InkWell(
            onTap: () {
              if (isFollow.value == "Follow") {
                isFollow("Unfollow");
                _color = Colors.white;
                _textColor = Colors.black;
              } else {
                isFollow("Follow");
                _color = Colors.blue;
                _textColor = Colors.white;
              }
            },
            child: Obx(
              () => Container(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                decoration: BoxDecoration(
                  color: _color,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Text(
                  isFollow.value,
                  style: TextStyle(color: _textColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
