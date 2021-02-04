import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/community/profile_full_screen.dart';
import 'package:jaansay_public_user/screens/community/profile_screen.dart';
import 'package:jaansay_public_user/service/follow_service.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class OfficialTile extends StatelessWidget {
  final Official official;

  OfficialTile(this.official);

  Future<bool> followUser(int officialId) async {
    GetStorage box = GetStorage();

    final userId = box.read("user_id");
    final token = box.read("token");

    print(userId);
    Dio dio = Dio();
    Response response = await dio.post(
      "${ConnUtils.url}follow",
      data: {
        "official_id": "$officialId",
        "user_id": "$userId",
        "is_follow": "1",
        "updated_at": "${DateTime.now()}"
      },
      options:
          Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"}),
    );
    if (response.data["success"]) {
      FirebaseMessaging fbm = FirebaseMessaging();
      fbm.subscribeToTopic("${officialId}follow");
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    var isAllowFollow =
        (official.isFollow == null || official.isFollow == 0).obs;

    return InkWell(
      onTap: () {
        Get.to(ProfileFullScreen(),
            arguments: [false, official.officialsId.toString()],
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
            if (official.isPrivate == 0)
              Obx(() => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: isAllowFollow.value
                                ? Theme.of(context).primaryColor
                                : Colors.black54,
                            width: 0.5),
                        color: isAllowFollow.value
                            ? Theme.of(context).primaryColor
                            : Colors.black.withOpacity(0.01)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          if (official.isFollow == 0) {
                            official.isFollow = 1;
                            isAllowFollow(false);
                            FollowService followService = FollowService();
                            followService.followUser(official.officialsId);
                          } else if (isAllowFollow.value) {
                            isAllowFollow(false);
                            official.isFollow = 1;
                            followUser(official.officialsId);
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                isAllowFollow.value ? "Follow" : "Following",
                                style: TextStyle(
                                    color: isAllowFollow.value
                                        ? Colors.white
                                        : Colors.black),
                              ).tr(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
