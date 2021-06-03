import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/screens/login_signup/follow_screen.dart';
import 'package:jaansay_public_user/service/user_service.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';
import 'package:jaansay_public_user/utils/misc_utils.dart';
import 'package:jaansay_public_user/widgets/general/custom_button.dart';
import 'package:jaansay_public_user/widgets/general/custom_fields.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/login_signup/screen_progress.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key key}) : super(key: key);
  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "User Setup",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ).tr(),
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                      _About(),
                      _Finish(),
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

class _About extends StatefulWidget {
  @override
  __AboutState createState() => __AboutState();
}

class __AboutState extends State<_About> {
  File _image;
  GetStorage box = GetStorage();
  TextEditingController nameController = TextEditingController();
  final LoginController _loginController = Get.put(LoginController());

  Future getImage() async {
    Get.focusScope.unfocus();
    _image = await MiscUtils.pickImage();
    if (_image != null) {
      setState(() {});
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
            child: ClipOval(
              child: _image != null
                  ? Image.file(
                      _image,
                      fit: BoxFit.cover,
                    )
                  : Image.asset("assets/images/profileHolder.jpg"),
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

class _Finish extends StatefulWidget {
  @override
  __FinishState createState() => __FinishState();
}

class __FinishState extends State<_Finish> {
  bool isLoad = false;
  bool isComplete = false;
  GetStorage box = GetStorage();

  sendData() async {
    isLoad = true;
    setState(() {});
    UserService userService = UserService();
    final response = await userService.createUser();
    if (response) {
      isLoad = false;
      setState(() {});
      Get.offAll(FollowScreen(), transition: Transition.rightToLeft);
    } else {
      Get.rawSnackbar(
        message: tr("Oops! Something went wrong"),
      );
    }
  }

  onSubmit(String val) {
    if (val.length == 4) {
      Get.focusScope.unfocus();
      box.write("register_password", val.toString());
      isComplete = true;
      setState(() {});
    } else {
      isComplete = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoad
          ? CustomLoading()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/signup.png",
                      height: Get.height * 0.3,
                      width: Get.height * 0.3,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${tr("Enter Your Passcode")}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.1, vertical: 8),
                    child: CustomPinField(onSubmit, 4),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomAuthButton(
                    onTap: isComplete
                        ? () {
                            sendData();
                          }
                        : null,
                    title: "${tr("Sign Up")}",
                  )
                ],
              ),
            ),
    );
  }
}
