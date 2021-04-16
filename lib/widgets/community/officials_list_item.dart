import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/profile_full_screen.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_network_image.dart';
import 'package:provider/provider.dart';

class BusinessListItem extends StatelessWidget {
  final Official official;

  BusinessListItem(this.official);

  @override
  Widget build(BuildContext context) {
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context);

    return InkWell(
      onTap: () {
        if (official.isPrivate == 1 && official.isFollow == null) {
          Get.dialog(AlertDialog(
            title: Text("Private Association").tr(),
            content: Text(
                    "Sorry, this is an private association. Only users part of this assocation can view the details. Please contact the admin to join this group.")
                .tr(),
            actions: [
              TextButton(
                onPressed: () {
                  Get.close(1);
                },
                child: Text(
                  "Okay",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ).tr(),
              )
            ],
          ));
        } else {
          officialProfileProvider.clearData();
          officialProfileProvider.selectOfficialIndex(official);
          Get.to(() => ProfileFullScreen(), transition: Transition.rightToLeft);
        }
      },
      child: Container(
        child: Column(
          children: [
            Expanded(child: CustomNetWorkImage(official.photo)),
            SizedBox(
              height: 4,
            ),
            AutoSizeText(
              official.officialsName,
              minFontSize: 12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
