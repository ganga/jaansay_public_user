import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AadhaarVerificationScreen extends StatefulWidget {
  @override
  State<AadhaarVerificationScreen> createState() =>
      _AadhaarVerificationScreen();
}

class _AadhaarVerificationScreen extends State<AadhaarVerificationScreen> {
  TextEditingController controller = TextEditingController();
  bool isLoad = false;

// Future<void> aadhaarVerify() async {
//   if (controller.text.length == 10) {
//     isLoad = true;
//     setState(() {});

// AuthService authService = AuthService();
// final response = await authService.checkUser(controller.text.trim());
// if (response) {
//   Get.to(() => PasscodeScreen(), arguments: controller.text.trim());
//   isLoad = false;
//   setState(() {});
// } else {
//   String phoneNumber = "+91" + controller.text;
//
//   await FirebaseAuth.instance.verifyPhoneNumber(
//     phoneNumber: phoneNumber,
//     timeout: const Duration(seconds: 15),
//     verificationCompleted: (AuthCredential authCredential) {
//       print("${tr("Your account is successfully verified")}");
//     },
//     verificationFailed: (FirebaseAuthException authException) {
//       isLoad = false;
//       setState(() {});
//       Get.rawSnackbar(message: tr("Oops! Something went wrong"));
//
//       print("${authException.message}");
//     },
//     codeSent: (String verId, [int forceCodeResent]) {
//       isLoad = false;
//       setState(() {});
//       Get.to(
//             () => OtpVerificationScreen(verId, controller.text.trim()),
//       );
//     },
//     codeAutoRetrievalTimeout: (String verId) {
//       print("${tr("TIMEOUT")}");
//     },
//   );
// }}

// else {
// Get.rawSnackbar(message: tr("Please enter valid phone number"));
// }


@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}

}