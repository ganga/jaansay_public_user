import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/screens/login_signup/about_me.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerification extends StatelessWidget {
  const OtpVerification({Key key, this.type}) : super(key: key);
  final int type;
  Widget pincodeField(BuildContext context) {
    return PinCodeTextField(
      pinTheme: PinTheme.defaults(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          activeColor: Theme.of(context).primaryColor,
          selectedColor: Theme.of(context).primaryColor,
          inactiveColor: Colors.black12),
      appContext: context,
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      animationDuration: Duration(milliseconds: 300),
      onChanged: (val) {},
      onCompleted: (val) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          "OTP",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        actions: [
          FlatButton(
            onPressed: () {},
            child: Text("Register"),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Please enter the One Time Password we have sent to +917259331064",
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: pincodeField(context),
          ),
          FlatButton(
            child: Text(
              "Resend OTP",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onPressed: () {},
          ),
          Container(
            height: _mediaQuery.height * 0.07,
            width: double.infinity,
            margin: EdgeInsets.all(8),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                type == 1
                    ? Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()))
                    : Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AboutMe()));
              },
              child: Text(
                "Continue",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
