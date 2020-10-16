import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:jaansay_public_user/screens/login_signup/sign_up_screen.dart';
import 'package:jaansay_public_user/service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "login";

  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controller = TextEditingController();

  loginPhone() async {
    String phone = controller.text;
    if (GetUtils.isPhoneNumber(phone)) {
      bool _response = await GetIt.I<AuthService>().loginPhone();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: "mainlogo",
                child: Image.asset(
                  "assets/images/logo.png",
                  height: _mediaQuery.width * 0.3,
                  width: _mediaQuery.width * 0.3,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Welcome to JaanSAY!",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "Lets get started!",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Phone Number",
                  hintText: "Enter your phone number",
                ),
              ),
            ),
            FlatButton(
              child: Text(
                "New User ? Register now",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(8),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 15),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  loginPhone();
                },
                child: Text(
                  "Log in",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
