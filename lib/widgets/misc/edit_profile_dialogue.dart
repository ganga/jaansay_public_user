// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/service/aadhaar_verification_service.dart';

// Project imports:
import 'package:jaansay_public_user/service/user_service.dart';
import 'package:jaansay_public_user/utils/misc_utils.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class EditProfileDialogue extends StatefulWidget {

  @override
  _EditProfileDialogueState createState() => _EditProfileDialogueState();
}

class _EditProfileDialogueState extends State<EditProfileDialogue> {
  bool otpSubmitProcess = false;
  GetStorage box = GetStorage();
  bool isAadhaarVerified = false;

  AadhaarVerificationService aadhaarVerificationService =
      new AadhaarVerificationService();
  String clientId;
  File _image;
  bool isLoad = false;
  TextEditingController aadhaarController = TextEditingController();
  TextEditingController aadhaarOtpController = TextEditingController();

  Future getImage() async {
    _image = await MiscUtils.pickImage();
    if (_image != null) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    isAadhaarVerified = box.read("isAadhaarVerified") ?? false;
  }

  getAadhaarOtp() async {
    clientId =
        await aadhaarVerificationService.verifyAadhaar(aadhaarController.text.trim());
    setState(() {
      otpSubmitProcess = true;
    });
  }

  submitAadhaarOtp() async {
    bool isVerified = await aadhaarVerificationService.submitOtp(clientId, aadhaarOtpController.text.trim());
    box.write("isAadhaarVerified", isVerified);
    setState(() {
      otpSubmitProcess = false;
      isAadhaarVerified = true;
    });
  }

  enableEditAadhaar() {
    setState(() {
      otpSubmitProcess = false;
    });
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

                (isAadhaarVerified != null && isAadhaarVerified) ?
                Column(
                   children: [Icon(Icons.check_circle_outline_rounded,
                    size: 50.0,
                    color: Colors.green
                ),
                Text("Verified Account", style: TextStyle(color: Colors.green),)]
                )
                : Column(children: getAadhaarWidgets()),
              ],
            ),
    );
  }

  List<Widget> getAadhaarWidgets() {
      return [
          TextField(
          keyboardType: TextInputType.number,
          controller: aadhaarController,
          autofocus: true,
          readOnly: otpSubmitProcess,
          decoration: InputDecoration(
              hintText: "${tr("Your aadhaar number")}",
              hintStyle: TextStyle(color: Colors.grey),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )),
        ),

        ElevatedButton(
          onPressed: () {
            otpSubmitProcess ? enableEditAadhaar() : getAadhaarOtp();
          },
          child: Text(
            otpSubmitProcess ? "Edit Aadhaar" : "Get OTP",
          ).tr(),
        ),
        TextField(
          keyboardType: TextInputType.number,
          controller: aadhaarOtpController,
          autofocus: true,
          readOnly: !otpSubmitProcess,
          // style: Li,
          decoration: InputDecoration(
              hintText: "${tr("OTP")}",
              hintStyle: TextStyle(color: Colors.grey),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )),
        ),
        ElevatedButton(
          onPressed: () {
            submitAadhaarOtp();
          },
          child: Text(
            "Submit OTP",
          ).tr(),
        )
      ];
  }
}
