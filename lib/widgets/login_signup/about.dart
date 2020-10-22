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

class About extends StatelessWidget {
  About({Key key}) : super(key: key);
  File _image;
  var _isPicked = 0.obs;
  var isLoad = false.obs;
  String gender = "";
  TextEditingController controller = TextEditingController();

  Widget genderPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text("Choose Gender"),
        ),
        GenderPickerWithImage(
          showOtherGender: true,
          verticalAlignedText: false,
          selectedGender: null,
          selectedGenderTextStyle:
              TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          unSelectedGenderTextStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          onChanged: (Gender val) {
            if (gender == "male") {
              gender = "m";
            } else if (gender == "female") {
              gender = "f";
            } else {
              gender = "o";
            }
            gender = val.toString();
          },
          equallyAligned: true,

          animationDuration: Duration(milliseconds: 300),
          isCircular: true,
          // default : true,
          opacityOfGradient: 0.4,
          padding: const EdgeInsets.all(3),
          size: 50, //default : 40
        ),
      ],
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

  final LoginController _loginController = Get.put(LoginController());
  var _selectedDate = "Choose DOB".obs;

  Widget _customTextField(
      String hint, String label, TextEditingController controller) {
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
        controller: controller,
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

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (pickedFile != null) {
      _image = File(croppedFile.path);
      _isPicked(1);
    } else {
      print('No image selected.');
    }
  }

  sendData() async {
    if (controller.text == "" || _selectedDate == null || gender == "") {
      Get.snackbar("title", "message", snackPosition: SnackPosition.BOTTOM);
    } else {
      GetStorage box = GetStorage();
      box.write("register_name", controller.text);
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
            child: Obx(() => ClipOval(
                  child: _isPicked.value == 1
                      ? Image.file(
                          _image,
                          fit: BoxFit.cover,
                        )
                      : Image.asset("assets/images/profileHolder.jpg"),
                )),
          ),
          SizedBox(
            width: 8,
          ),
          FlatButton(
            onPressed: () {
              getImage();
            },
            child: Text("Choose photo"),
          ),
          _customTextField("Enter your Name", "Full name", controller),
          InkWell(
            onTap: () async {
              var temp = await _datePicker(context);
              if (temp != null) {
                temp = DateFormat("dd-MM-yyyy").format(temp);
                _selectedDate(temp.toString());
              }
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      _selectedDate.value,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Icon(Icons.calendar_today_outlined),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: genderPicker(),
          ),
          Container(
            height: Get.height * 0.07,
            width: double.infinity,
            margin: EdgeInsets.all(8),
            child: RaisedButton(
              color: Get.theme.primaryColor,
              onPressed: () {
                sendData();
                _loginController.index(1);
              },
              child: Text(
                "Next",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
