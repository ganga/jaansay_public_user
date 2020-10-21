import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/grievance_service.dart';
import 'package:jaansay_public_user/widgets/grievance/grievance_search_dialog.dart';
import 'package:jaansay_public_user/widgets/grievance/grievance_user_tile.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/misc/location_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class GrievanceScreen extends StatefulWidget {
  @override
  _GrievanceScreenState createState() => _GrievanceScreenState();
}

class _GrievanceScreenState extends State<GrievanceScreen> {
  Official selectedOfficial;
  var files = [].obs;
  String latitude = "0", longitude = "0";
  TextEditingController controller = TextEditingController();
  bool isLoad = false;

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
                title: Text("Do you want to remove this item?"),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Get.close(1);
                    },
                    child: Text("No"),
                  ),
                  FlatButton(
                    onPressed: () {
                      files.removeAt(index);
                      Get.close(1);
                    },
                    child: Text("Yes"),
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
          Text("No user selected"),
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
            ),
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

  sendData() async {
    isLoad = true;
    setState(() {});
    GrievanceService grievanceService = GrievanceService();
    await grievanceService.addGrievance(
        files: files,
        latitude: latitude,
        longitude: longitude,
        message: controller.text,
        official_id: selectedOfficial.officialsId.toString());
    controller.clear();
    files.clear();
    latitude = "0";
    longitude = "0";
    selectedOfficial = null;
    isLoad = false;
    Get.dialog(
      AlertDialog(
        title: Text("Grievance Sent"),
        content: Text("Your grievance has been sent to the user."),
        actions: [
          FlatButton(
              onPressed: () {
                Get.close(0);
              },
              child: Text("Okay"))
        ],
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
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
                        hintText: "Type your grievance here",
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Add Photos",
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
                      "Add Location",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    attachments("Add Location", Icons.location_pin, 1),
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
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
