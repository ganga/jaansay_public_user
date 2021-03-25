import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/models/review.dart';
import 'package:jaansay_public_user/providers/official_feed_provider.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/profile_description_screen.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/misc/custom_loading.dart';
import 'package:jaansay_public_user/widgets/profile/officials_profile_head.dart';
import 'package:jaansay_public_user/widgets/profile/review_add_card.dart';
import 'package:jaansay_public_user/widgets/profile/review_card.dart';
import 'package:provider/provider.dart';

class ProfileFullScreen extends StatelessWidget {
  final String officialId;
  final bool isClose;

  ProfileFullScreen({this.officialId = '', this.isClose = false});

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<OfficialFeedProvider>(context);
    final officialProvider = Provider.of<OfficialProfileProvider>(context);

    if (!officialProvider.initProfile) {
      officialProvider.initProfile = true;
      if (officialProvider.selectedOfficialIndex != null) {
        officialProvider.isProfileLoad = false;

        feedProvider.getFeedData(
            officialProvider.officials[officialProvider.selectedOfficialIndex]);
      } else {
        officialProvider.getOfficialById(officialId, feedProvider);
      }
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Colors.white,
          title: Text(
            officialProvider.isProfileLoad ||
                    officialProvider.officials[
                            officialProvider.selectedOfficialIndex] ==
                        null
                ? "${tr('Profile')}"
                : officialProvider
                    .officials[officialProvider.selectedOfficialIndex]
                    .officialsName,
            style: TextStyle(
              color: Get.theme.primaryColor,
            ),
          ),
          actions: officialProvider.isProfileLoad ||
                  officialProvider
                          .officials[officialProvider.selectedOfficialIndex] ==
                      null
              ? null
              : officialProvider
                          .officials[officialProvider.selectedOfficialIndex]
                          .detailDescription
                          .length >
                      5
                  ? [
                      InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Get.to(
                              ProfileDescriptionScreen(
                                  officialProvider.officials[
                                      officialProvider.selectedOfficialIndex]),
                              transition: Transition.rightToLeft);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 16, left: 10),
                          child: Icon(
                            Icons.help_outline,
                            size: 28,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ]
                  : null,
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (isClose) {
              await Get.offAll(HomeScreen());
              return false;
            } else {
              return true;
            }
          },
          child: officialProvider.isProfileLoad ||
                  officialProvider
                          .officials[officialProvider.selectedOfficialIndex] ==
                      null
              ? CustomLoading('Please wait')
              : SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        OfficialsProfileHead(),
                        officialProvider
                                    .officials[
                                        officialProvider.selectedOfficialIndex]
                                    .isFollow ==
                                1
                            ? feedProvider.getLoading()
                                ? Loading()
                                : ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: feedProvider.feeds.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return FeedCard(
                                        feed: feedProvider.feeds[index],
                                        isDetail: false,
                                        isBusiness: true,
                                      );
                                    },
                                  )
                            : _ReviewSection(officialProvider.officials[
                                officialProvider.selectedOfficialIndex]),
                      ],
                    ),
                  ),
                ),
        ));
  }
}

class _ReviewSection extends StatefulWidget {
  final Official official;

  _ReviewSection(this.official);

  @override
  __ReviewSectionState createState() => __ReviewSectionState();
}

class __ReviewSectionState extends State<_ReviewSection> {
  bool isLoad = true;
  List<Review> reviews = [];

  Review userReview;
  bool isCheck = false;

  getData() async {
    isLoad = true;
    setState(() {});
    reviews.clear();
    userReview = null;

    OfficialService officialService = OfficialService();

    userReview = await officialService.getOfficialRatings(
        widget.official.officialsId.toString(), reviews);
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoad
          ? Loading()
          : reviews.length == 0 && widget.official.isFollow != 1
              ? Container(
                  margin: EdgeInsets.only(top: Get.height * 0.1),
                  child: CustomErrorWidget(
                    title: tr("No reviews"),
                    iconData: Icons.not_interested,
                  ),
                )
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? userReview == null
                            ? SizedBox.shrink()
                            : ReviewCard(userReview)
                        : ReviewCard(
                            reviews[index - 1],
                          );
                  },
                  itemCount: reviews.length + 1,
                ),
    );
  }
}
