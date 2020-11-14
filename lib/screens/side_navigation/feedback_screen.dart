import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/service/feedback_service.dart';
import 'package:jaansay_public_user/service/grievance_service.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';

class FeedbackScreen extends StatefulWidget {
  FeedbackScreen({Key key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  var isLoad = false.obs;

  TextEditingController controller = TextEditingController();

  var files = [].obs;

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

  sendData() async {
    if (controller.text != "") {
      isLoad(true);
      FeedbackService feedbackService = FeedbackService();
      await feedbackService.addFeedback(
        message: controller.text,
        files: files,
      );
      controller.clear();
      files.clear();
      isLoad(false);
      Get.dialog(
        AlertDialog(
          title: Text("Feedback Sent").tr(),
          content: Text("${tr("Your Feedback has been sent")}."),
          actions: [
            FlatButton(
                onPressed: () {
                  Get.close(0);
                },
                child: Text("Okay").tr())
          ],
        ),
      );
    } else {
      Get.rawSnackbar(
          title: "${tr("Error")}",
          message: "${tr("Feedback cant be empty")}",
          backgroundColor: Get.theme.primaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Feedback",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ).tr(),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/feedback.png",
                  height: Get.width * 0.5,
                  width: Get.width * 0.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "${tr("Feedback")}",
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "${tr("Add Photos")}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
              Obx(() {
                return isLoad.value
                    ? Loading()
                    : Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 24),
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            sendData();
                          },
                          child: Text(
                            "${tr("Send")}",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
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
