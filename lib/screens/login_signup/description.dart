import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/utils/loginController.dart';

class Description extends StatelessWidget {
  Description({Key key}) : super(key: key);
  final LoginController c = Get.find();

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: TextField(
            maxLines: 6,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: "Write about yourself",
              border: InputBorder.none,
            ),
          ),
        ),
        Container(
          height: _mediaQuery.height * 0.07,
          width: double.infinity,
          margin: EdgeInsets.all(8),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()));
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
    );
  }
}
