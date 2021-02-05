import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/grievance_test_service.dart';
import 'package:jaansay_public_user/widgets/grievance/grievance_search_dialog.dart';
import 'package:jaansay_public_user/widgets/grievance/grievance_user_tile.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jaansay_public_user/widgets/misc/location_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class GrievanceSendScreen extends StatefulWidget {
  @override
  _GrievanceSendScreenState createState() => _GrievanceSendScreenState();
}

class _GrievanceSendScreenState extends State<GrievanceSendScreen> {
  Official selectedOfficial;
  var files = [].obs;
  String latitude = "0", longitude = "0";
  TextEditingController controller = TextEditingController();
  bool isLoad = false;
  bool check = false;

  File _image;
  var _isPicked = false.obs;

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        maxWidth: 1024,
        maxHeight: 1024,
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
      _isPicked(true);
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  updateUser(Official official) {
    selectedOfficial = official;
    Get.close(1);
    setState(() {});
  }

  updateLocation(String lat, String lon) {
    latitude = lat;
    longitude = lon;
    setState(() {});
  }

  pickFiles(int index) async {
    if (index == 0) {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      result.files.map((e) {
        files.add(e);
      }).toList();
    }
  }

  Widget attachments(String label, IconData icon, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              pushNewScreenWithRouteSettings(context,
                  screen: LocationPicker(),
                  settings: RouteSettings(arguments: updateLocation));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Icon(icon),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    latitude == "0"
                        ? label
                        : "${latitude.substring(0, 9)} ${longitude.substring(0, 9)}",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget attachmentHolder(
    int index,
  ) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
      height: Get.height * 0.15,
      width: Get.height * 0.15,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        child: InkWell(
          onTap: () {
            Get.dialog(
              AlertDialog(
                title: Text("${tr("Do you want to remove this item")}?"),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Get.close(1);
                    },
                    child: Text("No").tr(),
                  ),
                  FlatButton(
                    onPressed: () {
                      files.removeAt(index);
                      Get.close(1);
                    },
                    child: Text("Yes").tr(),
                  ),
                ],
              ),
            );
          },
          child: Image.file(
            File(files[index].path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  selectUser(double height, double width, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("No user selected").tr(),
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  content: GrievanceSearchDialog(updateUser),
                ),
              );
            },
            child: Text(
              "Select User",
              style: TextStyle(color: Colors.white),
            ).tr(),
          )
        ],
      ),
    );
  }

  Widget addAttachmentHolder() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: Get.height * 0.15,
      width: Get.height * 0.15,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            pickFiles(0);
          },
          child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.add_a_photo_rounded,
                size: 40,
              )),
        ),
      ),
    );
  }

  sendGrievance() async {
    isLoad = true;
    setState(() {});
    GrievanceService grievanceService = GrievanceService();
    await grievanceService.addGrievance(
        files: files,
        latitude: latitude,
        longitude: longitude,
        message: controller.text,
        officialId: selectedOfficial.officialsId.toString(),
        typename: selectedOfficial.typeName);
    controller.clear();
    files.clear();
    latitude = "0";
    longitude = "0";
    selectedOfficial = null;
    Get.dialog(
      AlertDialog(
        title: Text("Grievance Sent").tr(),
        content: Text("${tr("Your grievance has been sent to the user")}."),
        actions: [
          FlatButton(
              onPressed: () {
                Get.close(0);
              },
              child: Text("Okay").tr())
        ],
      ),
    );
    isLoad = false;

    setState(() {});
  }

  addDocument() async {
    GrievanceService grievanceService = GrievanceService();
    bool response = await grievanceService.addDocument(_image);
    GetStorage box = GetStorage();
    box.write("document", "present");
    Get.close(1);
    if (response) {
      sendGrievance();
    } else {
      Get.rawSnackbar(message: "${tr("Oops! Something went wrong")}");
    }
  }

  sendData() async {
    if (selectedOfficial != null && controller.text.length > 0) {
      GetStorage box = GetStorage();
      if (selectedOfficial.typeName != "Business" &&
          (box.read("document") == null)) {
        Get.dialog(
          AlertDialog(
              title: Text("Please upload your ID"),
              content: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "${tr("You need to upload your ID to send grievance. Please attach your Aadhar card or Driving license")}."),
                    SizedBox(
                      height: 10,
                    ),
                    _isPicked.value
                        ? Container(
                            height: 125,
                            width: 125,
                            child: InkWell(
                              onTap: () {
                                getImage();
                              },
                              child: Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      width: 8,
                    ),
                    FlatButton(
                      onPressed: () {
                        getImage();
                      },
                      child: Text(
                        "Choose photo",
                        style: TextStyle(color: Get.theme.primaryColor),
                      ).tr(),
                    ),
                    _isPicked.value
                        ? RaisedButton(
                            color: Get.theme.primaryColor,
                            onPressed: () {
                              isLoad = true;
                              setState(() {});
                              addDocument();
                            },
                            child: Text(
                              "Update",
                              style: TextStyle(color: Colors.white),
                            ).tr(),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              )),
        );
      } else {
        sendGrievance();
      }
    } else {
      if (controller.text.length == 0) {
        Get.rawSnackbar(message: "${tr("Please enter description")}");
      } else {
        Get.rawSnackbar(message: "${tr("Please select a user")}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    if (!check) {
      check = true;
      selectedOfficial = ModalRoute.of(context).settings.arguments;
    }

    return Scaffold(
      body: isLoad
          ? Loading()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    selectedOfficial != null
                        ? GrievanceUserTile(
                            selectedOfficial,
                            false,
                            () => Get.dialog(
                                  AlertDialog(
                                    content: GrievanceSearchDialog(updateUser),
                                  ),
                                ))
                        : selectUser(
                            _mediaQuery.height, _mediaQuery.width, context),
                    TextField(
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "${tr("Type your grievance here")}",
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "${tr("Add Photos")}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Obx(
                      () => Container(
                        width: double.infinity,
                        height: (Get.height * 0.15) + 20,
                        child: ListView.builder(
                          padding: EdgeInsets.only(right: 16),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return addAttachmentHolder();
                            } else {
                              return attachmentHolder(index - 1);
                            }
                          },
                          itemCount: files.length + 1,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "${tr("Add Location")}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    attachments("${tr("Add Location")}", Icons.location_pin, 1),
                    SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          sendData();
                        },
                        child: Text(
                          "Send",
                          style: TextStyle(color: Colors.white),
                        ).tr(),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
