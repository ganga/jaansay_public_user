import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/providers/grievance_provider.dart';
import 'package:jaansay_public_user/utils/misc_utils.dart';
import 'package:jaansay_public_user/widgets/general/custom_dialog.dart';
import 'package:jaansay_public_user/widgets/general/custom_fields.dart';
import 'package:provider/provider.dart';

class GrievanceAddScreen extends StatefulWidget {
  @override
  _GrievanceAddScreenState createState() => _GrievanceAddScreenState();
}

class _GrievanceAddScreenState extends State<GrievanceAddScreen> {
  @override
  Widget build(BuildContext context) {
    final grievanceProvider = Provider.of<GrievanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Add Grievance",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [_AddSection()],
          ),
        ),
      ),
    );
  }
}

class _AddSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final grievanceProvider = Provider.of<GrievanceProvider>(context);

    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Text(
                "Enter your grievance in detail, also attach necessary files."),
            const SizedBox(
              height: 8,
            ),
            LongTextField(
              controller: grievanceProvider.controller,
              hint: "Enter your grievance here",
            ),
            const SizedBox(
              height: 8,
            ),
            _FileAttachSection(),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
                onPressed: () {
                  grievanceProvider.addGrievanceMaster();
                },
                child: Text("Add Grievance"))
          ],
        ),
      ),
    );
  }
}

class _FileAttachSection extends StatelessWidget {
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
                size: 35,
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
