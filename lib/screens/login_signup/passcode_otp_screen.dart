import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/screens/login_signup/passcode_change_screen.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PasscodeOtpScreen extends StatefulWidget {
  @override
  _PasscodeOtpScreenState createState() => _PasscodeOtpScreenState();
}

class _PasscodeOtpScreenState extends State<PasscodeOtpScreen> {
  String verificationId = "";
  String phoneNumber = "";
  GetStorage box = GetStorage();
  bool isLoad = true;
  bool isCheck = false;

  Widget pincodeField(BuildContext context) {
    return PinCodeTextField(
      backgroundColor: Colors.transparent,
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
    Get.focusScope.unfocus();
    isLoad = true;
    setState(() {});
    final _phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    FirebaseAuth.instance
        .signInWithCredential(_phoneAuthCredential)
        .then((user) async {
      Get.offAll(PasscodeChangeScreen(), arguments: phoneNumber);
    }).catchError((error) {
      isLoad = false;
      setState(() {});
      print("${error.hashCode}");
      Get.rawSnackbar(message: tr("Incorrect OTP, please try again"));
    });
  }

  Future<void> resendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91" + phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        print("${tr("Your account is successfully verified")}");
      },
      verificationFailed: (FirebaseAuthException authException) {
        Get.rawSnackbar(message: tr("Oops! Something went wrong"));
        Get.close(1);
        setState(() {});
      },
      codeSent: (String verId, [int forceCodeResent]) {
        Get.rawSnackbar(message: "${tr("OTP sent to your mobile number")}");
        verificationId = verId;
        isLoad = false;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verId) {
        print("${tr("TIMEOUT")}");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    phoneNumber = ModalRoute.of(context).settings.arguments;

    if (!isCheck) {
      isCheck = true;
      resendOTP();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          "${tr("otp")}",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: isLoad
          ? Loading()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/l2.png",
                      height: Get.height * 0.3,
                      width: Get.height * 0.3,
                    ),
                  ),
                  Text(
                    "${tr("otpSubtitle")}",
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
                  TextButton(
                    child: Text(
                      "${tr("otpResend")}",
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
