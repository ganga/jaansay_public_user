// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:jaansay_public_user/models/grievance.dart';
import 'package:jaansay_public_user/providers/grievance_provider.dart';
import 'package:jaansay_public_user/widgets/dashboard/grievance_head.dart';
import 'package:jaansay_public_user/widgets/dashboard/reply_bottom_sheet.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class GrievanceDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final grievanceProvider = Provider.of<GrievanceProvider>(context);

    GrievanceMaster grievanceMaster = grievanceProvider.selectedGrievanceMaster;

    if (!grievanceProvider.initReply) {
      grievanceProvider.initReply = true;
      grievanceProvider.getAllGrievanceReplies();
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Grievance Details",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  GrievanceHead(grievanceMaster, null),
                  _ReplySection(),
                  SizedBox(
                    height: Get.height * 0.1,
                  )
                ],
              ),
            ),
            if (grievanceMaster.isClosed == 0)
              Positioned(
                right: 0,
                bottom: 16,
                left: 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.bottomSheet(
                        ReplyBottomSheet(),
                        isScrollControlled: true,
                      );
                    },
                    child: Text("COMMENT"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _ReplySection extends StatelessWidget {
  listItem(GrievanceReply grievanceReply) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.hardEdge,
                  child: CustomNetWorkImage(grievanceReply.officialsPhoto ??
                      grievanceReply.userPhoto),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grievanceReply.officialsName ?? grievanceReply.userName,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Text(
                      DateFormat("dd MMMM yyyy")
                          .format(grievanceReply.createdAt),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(grievanceReply.message),
            if (grievanceReply.media.length > 0)
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 16, top: 12),
                height: 80,
                child: ListView.builder(
                  padding: EdgeInsets.only(right: 16),
                  itemBuilder: (context, index) {
                    return ImageHolder(grievanceReply.media[index]);
                  },
                  itemCount: grievanceReply.media.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grievanceProvider = Provider.of<GrievanceProvider>(context);

    return grievanceProvider.isReplyLoad
        ? SizedBox(
            height: Get.height * 0.25,
            child: CustomLoading(
              title: "Loading Comments",
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: grievanceProvider.grievanceReplies.length,
            itemBuilder: (context, index) {
              return listItem(grievanceProvider.grievanceReplies[index]);
            },
          );
  }
}
