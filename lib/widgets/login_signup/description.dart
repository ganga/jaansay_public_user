import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';
import 'package:jaansay_public_user/widgets/login_signup/custom_auth_button.dart';
import 'package:jaansay_public_user/widgets/login_signup/register_follow.dart';

class Description extends StatelessWidget {
  Description({Key key}) : super(key: key);
  final LoginController c = Get.find();

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: Container(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return RegisterFollow(mediaQuery: _mediaQuery);
              },
            ),
          ),
        ),
        CustomAuthButton(
          title: "Continue",
          onTap: () => c.index(3),
        ),
        FlatButton(
          onPressed: () {
            c.index(3);
          },
          child: Text("Skip for now"),
        ),
      ],
    );
  }
}
