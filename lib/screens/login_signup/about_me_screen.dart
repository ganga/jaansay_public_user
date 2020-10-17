import 'package:flutter/material.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';
import 'package:jaansay_public_user/widgets/login_signup/address.dart';
import 'package:jaansay_public_user/widgets/login_signup/description.dart';
import 'package:jaansay_public_user/widgets/login_signup/finish.dart';
import 'package:jaansay_public_user/widgets/login_signup/register_follow.dart';
import 'package:jaansay_public_user/widgets/misc/screen_progress.dart';

class AboutMeScreen extends StatelessWidget {
  AboutMeScreen({Key key}) : super(key: key);
  final LoginController _loginController = Get.put(LoginController());
  var _selectedDate = "Choose DOB".obs;
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
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
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

  _datePicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
      helpText: "Choose the date",
    );
  }

  Widget about(BuildContext context, Size mediaQuery) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 10,
        ),
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: Image.network(
              "https://cdn.fastly.picmonkey.com/contentful/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=800&q=70",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        FlatButton(
          onPressed: () {},
          child: Text("Choose photo"),
        ),
        _customTextField("Enter your Name", "Full name"),
        InkWell(
          onTap: () async {
            var temp = await _datePicker(context);
            _selectedDate(temp.toString());
          },
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 30),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Obx(() => Text(
                  _selectedDate.value,
                  style: TextStyle(color: Colors.grey),
                )),
          ),
        ),
        Container(
          margin: EdgeInsets.all(8),
          child: genderPicker(),
        ),
        Container(
          height: mediaQuery.height * 0.07,
          width: double.infinity,
          margin: EdgeInsets.all(8),
          child: RaisedButton(
            color: Get.theme.primaryColor,
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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "User Setup",
          textAlign: TextAlign.center,
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (_loginController.index.value == 0) {
            return true;
          } else {
            _loginController.index(_loginController.index.value - 1);
            return false;
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(8),
                alignment: Alignment.center,
                child: ScreenProgress(),
              ),
              Obx(() {
                return Expanded(
                  child: IndexedStack(
                    index: _loginController.index.value,
                    children: [
                      about(context, _mediaQuery),
                      Address(),
                      Description(),
                      Finish(),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
