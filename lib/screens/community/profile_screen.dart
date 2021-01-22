import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/models/review.dart';
import 'package:jaansay_public_user/providers/official_feed_provider.dart';
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

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isCheck = false;
  bool isLoad = true;
  bool isReview = false;
  Official official;
  List<Review> reviews = [];

  getOfficialById(String officialId, OfficialFeedProvider feedProvider) async {
    OfficialService officialService = OfficialService();
    official = await officialService.getOfficialById(officialId);
    feedProvider.getFeedData(official);
    isLoad = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List response = ModalRoute.of(context).settings.arguments;
    final feedProvider = Provider.of<OfficialFeedProvider>(context);

    if (!isCheck) {
      isCheck = true;
      if (response[0]) {
        isLoad = false;
        official = response[1];
        feedProvider.getFeedData(official);
      } else {
        getOfficialById(response[1], feedProvider);
      }
    }

    return Scaffold(
      body: isLoad
          ? CustomLoading('Please wait')
          : Container(
              width: double.infinity,
              child: Column(
                children: [
                  OfficialsProfileHead(official),
                  Expanded(
                    child: official.isFollow == 1
                        ? feedProvider.getLoading()
                            ? Loading()
                            : ListView.builder(
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
                  ),
                ],
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
    return Scaffold(
      body: isLoad
          ? Loading()
          : reviews.length == 0 && widget.official.isFollow != 1
              ? CustomErrorWidget(
                  title: "No reviews",
                  iconData: Icons.not_interested,
                )
              : ListView.builder(
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
