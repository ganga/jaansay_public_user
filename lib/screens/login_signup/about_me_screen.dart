import 'package:flutter/material.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';
import 'package:jaansay_public_user/widgets/login_signup/address.dart';
import 'package:jaansay_public_user/widgets/login_signup/description.dart';
import 'package:jaansay_public_user/widgets/misc/screen_progress.dart';

class AboutMeScreen extends StatelessWidget {
  AboutMeScreen({Key key}) : super(key: key);
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Date of birth"),
            FlatButton(
                onPressed: () {
                  _datePicker(context);
                },
                child: Text(
                  "Choose date",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ))
          ],
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
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
      ),
    );
  }
}
