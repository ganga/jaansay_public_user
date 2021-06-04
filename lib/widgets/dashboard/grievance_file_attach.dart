// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:jaansay_public_user/providers/grievance_provider.dart';
import 'package:jaansay_public_user/utils/misc_utils.dart';
import 'package:jaansay_public_user/widgets/general/custom_dialog.dart';

class GrievanceFileAttachSection extends StatelessWidget {
  Widget attachmentHolder(int index, GrievanceProvider grievanceProvider) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 16, 10),
      width: 120,
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
                CustomDialog("Remove Item", "Do you want to remove this item?",
                    negativeButtonOnTap: () => Get.close(1),
                    positiveButtonOnTap: () async {
                      grievanceProvider.files.removeAt(index);
                      grievanceProvider.notify();
                      Get.close(1);
                    },
                    positiveButtonColor: Colors.red,
                    negativeButtonColor: Colors.green,
                    positiveButtonText: "Remove"));
          },
          child: Image.file(
            File(grievanceProvider.files[index].path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget addAttachmentHolder(GrievanceProvider grievanceProvider) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 16, 10),
      width: 100,
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
          onTap: () async {
            FocusScope.of(Get.context).unfocus();
            File file = await MiscUtils.pickImage();
            if (file != null) {
              grievanceProvider.files.add(file);
              grievanceProvider.notify();
            }
          },
          child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.add_a_photo_rounded,
                size: 30,
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grievanceProvider = Provider.of<GrievanceProvider>(context);

    return Container(
      width: double.infinity,
      height: 100,
      child: ListView.builder(
        padding: EdgeInsets.only(right: 16),
        itemBuilder: (context, index) {
          if (grievanceProvider.files.length == 5) {
            return attachmentHolder(index, grievanceProvider);
          } else if (index == 0) {
            return addAttachmentHolder(grievanceProvider);
          } else {
            return attachmentHolder(index - 1, grievanceProvider);
          }
        },
        itemCount: grievanceProvider.files.length == 5
            ? grievanceProvider.files.length
            : grievanceProvider.files.length + 1,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
