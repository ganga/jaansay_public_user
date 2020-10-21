import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/community/contact_screen.dart';
import 'package:jaansay_public_user/screens/community/review_screen.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:jaansay_public_user/widgets/profile/profile_head_button.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class OfficialsProfileHead extends StatefulWidget {
  final Official official;

  OfficialsProfileHead(this.official);

  @override
  _OfficialsProfileHeadState createState() => _OfficialsProfileHeadState();
}

class _OfficialsProfileHeadState extends State<OfficialsProfileHead> {
  followUser() async {
    widget.official.isFollow = 1;
    setState(() {});
    GetStorage box = GetStorage();

    final userId = box.read("user_id");
    final token = box.read("token");

    Dio dio = Dio();
    Response response = await dio.post(
      "${ConnUtils.url}follow",
      data: {
        "official_id": "${widget.official.officialsId}",
        "user_id": "$userId",
        "is_follow": "1",
        "updated_at": "${DateTime.now()}"
      },
      options:
          Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _mediaQuery.width * 0.06,
            vertical: _mediaQuery.height * 0.03),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: _mediaQuery.width * 0.2,
                  width: _mediaQuery.width * 0.2,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                      child: CustomNetWorkImage(widget.official.photo)),
                ),
                SizedBox(
                  width: _mediaQuery.width * 0.05,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.official.officialsName}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      InkWell(
                        onTap: () {
                          pushNewScreenWithRouteSettings(context,
                              screen: ReviewScreen(),
                              withNavBar: true,
                              settings: RouteSettings(
                                arguments:
                                    widget.official.officialsId.toString(),
                              ));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RatingBar(
                              itemSize: 20,
                              initialRating: widget.official.averageRating ?? 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              ignoreGestures: true,
                              itemPadding: EdgeInsets.symmetric(horizontal: 0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "(${widget.official.totalRating})",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 13),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text("${widget.official.officialsDescription}"),
                      SizedBox(
                        height: _mediaQuery.height * 0.02,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: _mediaQuery.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ProfileHeadButton(double.infinity, 0, "Reviews", () {
                    pushNewScreenWithRouteSettings(context,
                        screen: ReviewScreen(),
                        withNavBar: true,
                        settings: RouteSettings(
                          arguments: widget.official.officialsId.toString(),
                        ));
                  }),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ProfileHeadButton(double.infinity,
                      widget.official.isFollow, "Requested", followUser),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ProfileHeadButton(double.infinity, 0, "Contact", () {
                    pushNewScreenWithRouteSettings(context,
                        screen: ContactScreen(),
                        settings: RouteSettings(arguments: widget.official));
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
