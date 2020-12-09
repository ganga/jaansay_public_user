import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/models/review.dart';
import 'package:jaansay_public_user/providers/official_feed_provider.dart';
import 'package:jaansay_public_user/service/feed_service.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_loading.dart';
import 'package:jaansay_public_user/widgets/profile/officials_profile_head.dart';
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

  // getReviews() async {
  //   isLoad = true;
  //   setState(() {});
  //   reviews.clear();
  //   userReview = null;
  //   OfficialService officialService = OfficialService();
  //   final List response = await officialService
  //       .getOfficialRatings(official.officialsId.toString());
  //   userReview = response[0];
  //   reviews = response[1];
  //   isLoad = false;
  //   setState(() {});
  // }

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
                    child: feedProvider.getLoading()
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
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
