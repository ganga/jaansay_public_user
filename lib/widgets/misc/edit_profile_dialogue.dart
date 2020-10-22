import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaansay_public_user/service/user_service.dart';
import 'package:jaansay_public_user/widgets/loading.dart';

class EditProfileDailogue extends StatefulWidget {
  EditProfileDailogue({Key key}) : super(key: key);

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
    if (_image != null) {
      isLoad = true;
      setState(() {});
      UserService userService = UserService();
      await userService.updateUser(_image);
      isLoad = false;
      setState(() {});
      Get.close(1);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoad
          ? Loading()
          : Column(
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
                            : Image.network(
                                box.read("photo"),
                              ),
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
                RaisedButton(
                  color: Get.theme.primaryColor,
                  onPressed: () {
                    sendData();
                  },
                  child: Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
    );
  }
}
