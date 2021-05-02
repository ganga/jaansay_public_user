import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/providers/feed_provider.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/profile_full_screen.dart';
import 'package:jaansay_public_user/screens/feed/feed_detail_screen.dart';
import 'package:jaansay_public_user/screens/feed/image_view_screen.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class FeedCard extends StatelessWidget {
  final Feed feed;
  final bool isDetail;

  FeedCard({this.feed, this.isDetail});

  Widget _getImg(String url, BuildContext context) {
    return InkWell(
      onTap: isDetail
          ? () {
              pushNewScreen(context,
                  screen: ImageViewScreen(url),
                  pageTransitionAnimation: PageTransitionAnimation.fade);
            }
          : null,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.fitWidth,
        width: double.infinity,
      ),
    );
  }

  Widget _midDetail(BuildContext context) {
    return feed.media.length == 0
        ? SizedBox.shrink()
        : SizedBox(
            height: Get.height * 0.5,
            width: Get.width,
            child: Carousel(
              images: feed.media.map((e) {
                return _getImg(e, context);
              }).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotColor: Get.theme.accentColor,
              dotIncreasedColor: Get.theme.primaryColor,
              indicatorBgPadding: 5.0,
              dotBgColor: Colors.transparent,
              borderRadius: false,
              autoplay: false,
            ));
  }

  Widget _bottomDetail() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            feed.feedDescription.toString(),
            textAlign: TextAlign.start,
            maxLines: !isDetail ? 3 : 1000,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${feed.likes} ${tr("Likes")}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _likeShare(BuildContext context, FeedProvider feedProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: InkWell(
            onTap: () {
              feedProvider.likeFeed(feed);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.thumb_up,
                    color: feed.isLiked > 0
                        ? Get.theme.primaryColor
                        : Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    feed.isLiked > 0 ? tr("Liked") : tr("Like"),
                    style: TextStyle(
                        color: feed.isLiked > 0
                            ? Get.theme.primaryColor
                            : Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: InkWell(
            onTap: () {
              Share.share(
                  'Check this feed on the JaanSay mobile app. ${feed.feedTitle}',
                  subject: "${tr('Check out this post')}");
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Share",
                    style: TextStyle(color: Colors.black),
                  ).tr(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  mainBody(BuildContext context, FeedProvider feedProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        _FeedTopDetails(feed),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            if (!isDetail) {
              pushNewScreen(context,
                  screen: FeedDetailScreen(feed),
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  withNavBar: false);
            }
          },
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (feed.docId == 1) _midDetail(context),
                _bottomDetail(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        _likeShare(Get.context, feedProvider),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    FeedProvider feedProvider = Provider.of<FeedProvider>(context);

    return isDetail
        ? Container(
            child: mainBody(context, feedProvider),
          )
        : Card(
            margin: EdgeInsets.only(bottom: 10),
            child: mainBody(context, feedProvider));
  }
}

class _FeedTopDetails extends StatelessWidget {
  final Feed feed;

  _FeedTopDetails(this.feed);

  @override
  Widget build(BuildContext context) {
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context, listen: false);

    return InkWell(
      onTap: () {
        officialProfileProvider.clearData();
        pushNewScreen(context,
            screen: ProfileFullScreen(
              feed.userId,
            ),
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
            withNavBar: false);
      },
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(child: CustomNetWorkImage(feed.photo)),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${feed.officialsName}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.65),
                      letterSpacing: 0.45,
                      fontSize: 16),
                ),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                          text: "#${feed.typeName} ",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).primaryColor,
                          )),
                      TextSpan(
                        text:
                            DateFormat.yMMMd().add_jm().format(feed.updatedAt),
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
