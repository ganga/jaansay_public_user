import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/screens/login_signup/about_me_screen.dart';
import 'package:jaansay_public_user/service/auth_service.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  static const routeName = "/otp";

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  String verificationId = "";
  String phoneNumber = "";

  Widget pincodeField(BuildContext context) {
    return PinCodeTextField(
      controller: controller,
      pinTheme: PinTheme.defaults(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          activeColor: Theme.of(context).primaryColor,
          selectedColor: Theme.of(context).primaryColor,
          inactiveColor: Colors.black12),
      appContext: context,
      length: 6,
      obscureText: false,
      autoFocus: true,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      animationDuration: Duration(milliseconds: 300),
      onChanged: (val) {},
      onCompleted: (val) {
        submitOtp(val);
      },
    );
  }

  Future<void> submitOtp(String otp) async {
    final _phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    FirebaseAuth.instance
        .signInWithCredential(_phoneAuthCredential)
        .then((user) async {
      print("${user.user.phoneNumber}");
      bool response = await GetIt.I<AuthService>().loginUser(phoneNumber);
      if (response) {
        Get.offAll(HomeScreen());
      } else {
        Get.offAll(AboutMeScreen());
      }
    }).catchError((error) {
      print("${error.hashCode}");
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text("Incorrect OTP, please try again")));
      controller.clear();
    });
  }

  Future<void> resendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        print("Your account is successfully verified");
      },
      verificationFailed: (FirebaseAuthException authException) {
        _scaffoldKey.currentState.showSnackBar(
            new SnackBar(content: new Text("Oops! Something went wrong")));
      },
      codeSent: (String verId, [int forceCodeResent]) {
        verificationId = verId;
      },
      codeAutoRetrievalTimeout: (String verId) {
        print("TIMEOUT");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    List response = ModalRoute.of(context).settings.arguments;

    verificationId = response[0];
    phoneNumber = response[1];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          "OTP",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/l2.png",
                height: _mediaQuery.height * 0.3,
                width: _mediaQuery.height * 0.3,
              ),
            ),
            Text(
              "Please enter the One Time Password",
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
              onPressed: () {
                resendOTP();
              },
            ),
          ],
        ),
      ),
    );
  }
}
