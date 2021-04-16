import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/service/user_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class ReviewAddCard extends StatefulWidget {
  final String officialId;
  final Function getReviews;

  ReviewAddCard(this.officialId, this.getReviews);

  @override
  _ReviewAddCardState createState() => _ReviewAddCardState();
}

class _ReviewAddCardState extends State<ReviewAddCard> {
  TextEditingController controller = TextEditingController();
  OfficialService officialService = OfficialService();
  GetStorage box = GetStorage();
  String rating = "5";
  bool isLoad = false;
  bool isVerified = true;

  List<OfficialDocument> officialDocuments = [];

  getData() async {
    isLoad = true;
    setState(() {});
    officialDocuments.clear();
    await officialService.getOfficialDocuments(
        officialDocuments, widget.officialId.toString());
    officialDocuments.map((e) {
      if (e.isVerified != 1) {
        isVerified = false;
      }
    }).toList();
    isLoad = false;
    setState(() {});
  }

  addReview() async {
    isLoad = true;
    setState(() {});
    UserService userService = UserService();
    print(controller.text);
    await userService.addReview(widget.officialId, rating, controller.text);
    widget.getReviews();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Card(
      child: isLoad
          ? Container(
              height: Get.height * 0.2,
              alignment: Alignment.center,
              child: CustomLoading())
          : isVerified
              ? Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: _mediaQuery.width * 0.06,
                      vertical: _mediaQuery.height * 0.03),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: _mediaQuery.width * 0.15,
                            width: _mediaQuery.width * 0.15,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipOval(
                              child: CustomNetWorkImage(box.read("photo")),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${box.read("user_name")}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                RatingBar(
                                  itemSize: 30,
                                  initialRating: 5,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
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
                                  onRatingUpdate: (val) {
                                    rating = val.toString();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15, bottom: 2),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          decoration: InputDecoration.collapsed(
                              hintText: tr(
                                  "Share details of your experience at this place"),
                              hintStyle: TextStyle(fontSize: 14)),
                          minLines: 5,
                          maxLines: 5,
                          style: TextStyle(fontSize: 14),
                          textCapitalization: TextCapitalization.sentences,
                          controller: controller,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            addReview();
                          },
                          child: Text(
                            "Submit",
                          ).tr(),
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Get.height * 0.05, horizontal: 16),
                  child: Column(
                    children: [
                      CustomErrorWidget(
                        title: "${tr("Documents not verified")}",
                        iconData: Icons.file_present,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text("Please upload the requested documents to add reviews")
                          .tr(),
                    ],
                  ),
                ),
    );
  }
}
