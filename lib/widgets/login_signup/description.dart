import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';
import 'package:jaansay_public_user/widgets/login_signup/regoister_follow.dart';
import 'package:jaansay_public_user/widgets/misc/profile_tile.dart';

class Description extends StatelessWidget {
  Description({Key key}) : super(key: key);
  final LoginController c = Get.find();

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ListView.builder(itemBuilder: (context, index) {
                  return RegisterFollow(mediaQuery: _mediaQuery);
                })),
          ),
          Container(
            height: _mediaQuery.height * 0.07,
            width: double.infinity,
            margin: EdgeInsets.all(8),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text(
                "Finish",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Text("Skip for now"),
          ),
        ],
      ),
    );
  }
}
