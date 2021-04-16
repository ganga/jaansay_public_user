import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/profile_full_screen.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_network_image.dart';
import 'package:provider/provider.dart';

class OfficialTile extends StatelessWidget {
  final int index;

  OfficialTile(this.index);

  @override
  Widget build(BuildContext context) {
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context);

    Official official = officialProfileProvider.officials[index];

    return InkWell(
      onTap: () {
        officialProfileProvider.clearData();
        officialProfileProvider.selectedOfficialIndex = index;
        Get.close(1);
        Get.to(
            () => ProfileFullScreen(
                  officialId: official.officialsId.toString(),
                ),
            transition: Transition.rightToLeft);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(child: CustomNetWorkImage(official.photo)),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${official.officialsName}",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "#${official.businesstypeName}",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            if (official.isPrivate == 0)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: official.isFollow == 0
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                        width: 0.5),
                    color: official.isFollow == 0
                        ? Theme.of(context).primaryColor
                        : Colors.black.withOpacity(0.01)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white,
                    onTap: () {
                      if (official.isFollow == 0) {
                        officialProfileProvider.followOfficial(index: index);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            official.isFollow == 0
                                ? "${tr("Follow")}"
                                : "${tr("Following")}",
                            style: TextStyle(
                                color: official.isFollow == 0
                                    ? Colors.white
                                    : Colors.black),
                          ).tr(),
                        ),
                      ),
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
