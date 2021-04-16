import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';
import 'package:jaansay_public_user/utils/misc_utils.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_auth_button.dart';

import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_fields.dart';

class About extends StatefulWidget {
  About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  File _image;
  GetStorage box = GetStorage();

  var _isPicked = 0.obs;

  var isLoad = false.obs;

  TextEditingController nameController = TextEditingController();

  final LoginController _loginController = Get.put(LoginController());

  Future getImage() async {
    Get.focusScope.unfocus();
    _image = await MiscUtils.pickImage();
    if (_image != null) {
      _isPicked(1);
    }
  }

  sendData() async {
    if (nameController.text == "") {
      Get.rawSnackbar(
        message: "${tr("Please fill the fields")}",
      );
    } else {
      box.write("register_name", nameController.text.trim());
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
        children: [
          SizedBox(
            width: Get.height * 0.2,
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
          TextButton(
            onPressed: () {
              getImage();
            },
            child: Text(
              "Choose Photo",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ).tr(),
          ),
          CustomTextField(
              hint: tr("Enter your Name"),
              label: tr("Full Name"),
              controller: nameController),
          SizedBox(
            width: 16,
          ),
          CustomAuthButton(
            title: "Next",
            onTap: () {
              Get.focusScope.unfocus();
              sendData();
            },
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
