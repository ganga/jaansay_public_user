// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:jaansay_public_user/screens/login_signup/passcode_change_screen.dart';
import 'package:jaansay_public_user/screens/login_signup/register_screen.dart';
import 'package:jaansay_public_user/widgets/general/custom_fields.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  OtpVerificationScreen(this.verificationId, this.phoneNumber);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  GetStorage box = GetStorage();
  bool isLoad = false;
  String verificationId;

  Future<void> submitOtp(String otp) async {
    Get.focusScope.unfocus();
    isLoad = true;
    setState(() {});
    final _phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    FirebaseAuth.instance
        .signInWithCredential(_phoneAuthCredential)
        .then((user) async {
      if (widget.verificationId == null) {
        Get.offAll(PasscodeChangeScreen(widget.phoneNumber));
      } else {
        box.write("register_phone", widget.phoneNumber);
        Get.to(() => RegisterScreen());
      }
    }).catchError((error) {
      isLoad = false;
      setState(() {});
      Get.rawSnackbar(message: tr("Incorrect OTP, please try again"));
    });
  }

  Future<void> resendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91" + widget.phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        print("${tr("Your account is successfully verified")}");
      },
      verificationFailed: (FirebaseAuthException authException) {
        Get.rawSnackbar(message: tr("Oops! Something went wrong"));
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
  void initState() {
    // TODO: implement initState
    super.initState();
    verificationId = widget.verificationId;
    if (widget.verificationId == null) {
      isLoad = true;
      resendOTP();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          ? CustomLoading()
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
                    child: CustomPinField(submitOtp, 6),
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
