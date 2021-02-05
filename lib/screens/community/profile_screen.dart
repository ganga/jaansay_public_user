import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/models/review.dart';
import 'package:jaansay_public_user/providers/official_feed_provider.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/review_screen.dart';
import 'package:jaansay_public_user/service/feed_service.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/misc/custom_loading.dart';
import 'package:jaansay_public_user/widgets/profile/officials_profile_head.dart';
import 'package:jaansay_public_user/widgets/profile/review_add_card.dart';
import 'package:jaansay_public_user/widgets/profile/review_card.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  bool isCheck = false;
  Official official;

  @override
  Widget build(BuildContext context) {
    List response = ModalRoute.of(context).settings.arguments;
    final feedProvider = Provider.of<OfficialFeedProvider>(context);
    final officialProvider = Provider.of<OfficialProfileProvider>(context);

    if (!isCheck) {
      isCheck = true;
      if (response[0]) {
        official = response[1];
        feedProvider.getFeedData(official);
      } else {
        officialProvider.getOfficialById(response[1], feedProvider);
      }
    }

    if (!officialProvider.isLoad) {
      official = officialProvider.official;
    }

    return Scaffold(
      body: officialProvider.isLoad
          ? CustomLoading('Please wait')
          : SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    OfficialsProfileHead(officialProvider, feedProvider),
                    official.isFollow == 1
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
                        : _ReviewSection(official),
                  ],
                ),
              ),
            ),
    );
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
  List<OfficialDocument> officialDocuments = [];

  Review userReview;
  bool isCheck = false;

  getData() async {
    isLoad = true;
    setState(() {});
    reviews.clear();
    userReview = null;

    OfficialService officialService = OfficialService();
    officialDocuments.clear();
    await officialService.getOfficialDocuments(
        officialDocuments, widget.official.officialsId.toString());
    final List response = await officialService
        .getOfficialRatings(widget.official.officialsId.toString());
    userReview = response[0];
    reviews = response[1];
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
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
                    title: "No reviews",
                    iconData: Icons.not_interested,
                  ),
                )
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? userReview == null
                            ? widget.official.isFollow != 1
                                ? SizedBox.shrink()
                                : ReviewAddCard(
                                    widget.official.officialsId.toString(),
                                    getData)
                            : ReviewCard(userReview)
                        : ReviewCard(reviews[index - 1]);
                  },
                  itemCount: reviews.length + 1,
                ),
    );
  }
}
