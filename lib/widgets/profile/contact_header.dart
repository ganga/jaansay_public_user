import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/community/review_screen.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class ContactHeader extends StatelessWidget {
  final Official official;

  ContactHeader(this.official);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: Get.width * 0.18,
            width: Get.width * 0.18,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: CustomNetWorkImage(official.photo),
            ),
          ),
          SizedBox(
            width: Get.width * 0.05,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${official.officialsName}",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                SizedBox(
                  height: 2,
                ),
                InkWell(
                  onTap: () {

                    Get.to(ReviewScreen(official), transition: Transition.rightToLeft);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RatingBar(
                        itemSize: 20,
                        initialRating:
                            double.parse(official.averageRating.toString()),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ignoreGestures: true,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0),
                        ratingWidget: RatingWidget(
                            full: Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            half: Icon(
                              Icons.star_half,
                              color: Colors.amber,
                            ),
                            empty: Icon(
                              Icons.star_border,
                              color: Colors.amber,
                            )),
                        onRatingUpdate: (rating) {},
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "(${official.totalRating})",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 13),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text("${tr("Timings")}: ${official.businessHours}"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
