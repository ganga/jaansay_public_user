import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';

class GrievanceUserTile extends StatelessWidget {
  final Official official;
  final bool isSearch;
  final Function onTap;

  GrievanceUserTile(this.official, this.isSearch, this.onTap);

  Future<bool> followUser(int officialId) async {
    GetStorage box = GetStorage();

    final userId = box.read("user_id");
    final token = box.read("token");

    Dio dio = Dio();
    Response response = await dio.post(
      "${Constants.url}follow",
      data: {
        "official_id": "$officialId",
        "user_id": "$userId",
        "is_follow": "1",
        "updated_at": "${DateTime.now()}"
      },
      options:
          Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"}),
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
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
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 0.5),
                color: Theme.of(context).primaryColor),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.white,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if (isSearch) {
                    onTap(official);
                  } else {
                    onTap();
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        isSearch ? "${tr("Add")}": "${tr("Change")}",
                        style: TextStyle(color: Colors.white),
                      ).tr(),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
