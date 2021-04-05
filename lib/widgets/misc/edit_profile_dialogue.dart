import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaansay_public_user/service/user_service.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';

class EditProfileDailogue extends StatefulWidget {
  final Function updatePhoto;

  EditProfileDailogue(this.updatePhoto);

  @override
  _EditProfileDailogueState createState() => _EditProfileDailogueState();
}

class _EditProfileDailogueState extends State<EditProfileDailogue> {
  File _image;
  var _isPicked = 0.obs;
  bool isLoad = false;
  GetStorage box = GetStorage();
  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
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
      print("${tr('No image selected.')}");
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
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitChasingDots(
                  color: Get.theme.primaryColor,
                  size: 30,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Please wait").tr(),
              ],
            )
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
                  child: Obx(() => InkWell(
                        onTap: () {
                          getImage();
                        },
                        child: ClipOval(
                          child: _isPicked.value == 1
                              ? Image.file(
                                  _image,
                                  fit: BoxFit.cover,
                                )
                              : CustomNetWorkImage(
                                  box.read("photo"),
                                ),
                        ),
                      )),
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
