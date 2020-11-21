import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jaansay_public_user/widgets/login_signup/custom_auth_button.dart';

class About extends StatefulWidget {
  About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  File _image;

  var _isPicked = 0.obs;

  var isLoad = false.obs;

  String gender = "";

  TextEditingController nameController = TextEditingController();

  Widget genderPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text("Choose Gender").tr(),
        ),
        GenderPickerWithImage(
          showOtherGender: true,
          verticalAlignedText: false,
          selectedGender: null,
          selectedGenderTextStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
          unSelectedGenderTextStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          onChanged: (Gender val) {
            Get.focusScope.unfocus();

            print(val.toString());
            if (val.toString() == "Gender.Male") {
              gender = "m";
            } else if (val.toString() == "Gender.Female") {
              gender = "f";
            } else {
              gender = "o";
            }
            print(gender);
          },
          equallyAligned: true,

          animationDuration: Duration(milliseconds: 300),
          isCircular: true,
          // default : true,
          opacityOfGradient: 0.25,
          linearGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor
              ]),
          padding: const EdgeInsets.all(3),
          size: 50, //default : 40
        ),
      ],
    );
  }

  _datePicker(BuildContext context) async {
    Get.focusScope.unfocus();
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 5000)),
      firstDate: DateTime(1950),
      lastDate: DateTime(2010),
      helpText: "Choose the date",
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
  }

  final LoginController _loginController = Get.put(LoginController());

  var _selectedDate = "${tr("Choose DOB")}".obs;

  Widget _customTextField(
      String hint, String label, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }

  Future getImage() async {
    Get.focusScope.unfocus();
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File croppedFile;
    if (pickedFile != null) {
      croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          maxHeight: 512,
          maxWidth: 512,
          compressFormat: ImageCompressFormat.jpg,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
    }
    if (pickedFile != null) {
      _image = File(croppedFile.path);
      _isPicked(1);
    }
  }

  sendData() async {
    if (nameController.text == "" || _selectedDate == null || gender == "") {
      Get.rawSnackbar(
        message: "${tr("Please fill the fields")}",
      );
    } else {
      GetStorage box = GetStorage();
      box.write("register_name", nameController.text.trim());
      box.write("register_dob", _selectedDate.toString());
      box.write("register_gender", gender);
      _image == null
          ? box.write("register_profile", "no photo")
          : box.write(
              "register_profile",
              base64Encode(
                _image.readAsBytesSync(),
              ),
            );
      _loginController.index(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          Container(
            height: 125,
            width: 125,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Obx(
              () => ClipOval(
                child: _isPicked.value == 1
                    ? Image.file(
                        _image,
                        fit: BoxFit.cover,
                      )
                    : Image.asset("assets/images/profileHolder.jpg"),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          FlatButton(
            onPressed: () {
              getImage();
            },
            child: Text(
              "Choose Photo",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ).tr(),
          ),
          _customTextField(
              tr("Enter your Name"), tr("Full Name"), nameController),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: InkWell(
              onTap: () async {
                var temp = await _datePicker(context);
                if (temp != null) {
                  temp = DateFormat("dd-MM-yyyy").format(temp);
                  _selectedDate(temp.toString());
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        _selectedDate.value,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Icon(Icons.calendar_today_outlined),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: genderPicker(),
          ),
          CustomAuthButton(
              title: "Next",
              onTap: () {
                Get.focusScope.unfocus();
                sendData();
              })
        ],
      ),
    );
  }
}
