import 'package:flutter/material.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/screens/login_signup/address.dart';
import 'package:jaansay_public_user/screens/login_signup/description.dart';
import 'package:jaansay_public_user/utils/loginController.dart';
import 'package:jaansay_public_user/widgets/misc/custom_appbar.dart';
import 'package:jaansay_public_user/widgets/misc/screen_progress.dart';

class AboutMe extends StatelessWidget {
  AboutMe({Key key}) : super(key: key);
  final LoginController _loginController = Get.put(LoginController());

  Widget _customTextField(String hint, String label) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }

  Widget genderPicker() {
    return GenderPickerWithImage(
      showOtherGender: true,
      verticalAlignedText: false,
      selectedGender: null,
      selectedGenderTextStyle:
          TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      unSelectedGenderTextStyle:
          TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
      onChanged: (Gender gender) {
        print(gender);
      },
      equallyAligned: true,

      animationDuration: Duration(milliseconds: 300),
      isCircular: true,
      // default : true,
      opacityOfGradient: 0.4,
      padding: const EdgeInsets.all(3),
      size: 50, //default : 40
    );
  }

  Widget about(BuildContext context, Size mediaQuery) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _customTextField("Enter your Name", "Full name"),
        _customTextField("Enter your Email", "Email"),
        Container(
          margin: EdgeInsets.all(8),
          child: genderPicker(),
        ),
        Container(
          height: mediaQuery.height * 0.07,
          width: double.infinity,
          margin: EdgeInsets.all(8),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _loginController.index(1);
            },
            child: Text(
              "Log in",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    List<Widget> progresStack = [
      about(context, _mediaQuery),
      Address(),
      Description(),
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "User Setup",
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: ScreenProgress(),
          ),
          //about(context, _mediaQuery),
          //Address(),
          Obx(() {
            return progresStack[_loginController.index.value];
          }),
          //Description(),
        ],
      ),
    );
  }
}
