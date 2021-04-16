import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/service/user_service.dart';
import 'package:jaansay_public_user/utils/misc_utils.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class EditProfileDailogue extends StatefulWidget {
  final Function updatePhoto;

  EditProfileDailogue(this.updatePhoto);

  @override
  _EditProfileDailogueState createState() => _EditProfileDailogueState();
}

class _EditProfileDailogueState extends State<EditProfileDailogue> {
  File _image;
  bool isLoad = false;
  GetStorage box = GetStorage();

  Future getImage() async {
    _image = await MiscUtils.pickImage();
    if (_image != null) {
      setState(() {});
    }
  }

  sendData() async {
    if (_image != null) {
      isLoad = true;
      setState(() {});
      UserService userService = UserService();
      await userService.updateUser(_image);
      widget.updatePhoto();
      isLoad = false;
      setState(() {});
      Get.close(2);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoad
          ? CustomLoading()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 125,
                  width: 125,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: InkWell(
                    onTap: () {
                      getImage();
                    },
                    child: ClipOval(
                      child: _image != null
                          ? Image.file(
                              _image,
                              fit: BoxFit.cover,
                            )
                          : CustomNetWorkImage(
                              box.read("photo"),
                            ),
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
                ElevatedButton(
                  onPressed: () {
                    sendData();
                  },
                  child: Text(
                    "Update",
                  ).tr(),
                ),
              ],
            ),
    );
  }
}
