import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_feed_provider.dart';
import 'package:jaansay_public_user/service/feed_service.dart';
import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/profile/officials_profile_head.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    final official = ModalRoute.of(context).settings.arguments;
    final feedProvider = Provider.of<OfficialFeedProvider>(context);

    if (!isCheck) {
      isCheck = true;
      feedProvider.getFeedData(official);
    }

    return Scaffold(
      body: Container(
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
