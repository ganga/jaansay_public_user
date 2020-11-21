import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/providers/official_feed_provider.dart';
import 'package:jaansay_public_user/providers/user_feed_provider.dart';
import 'package:jaansay_public_user/screens/feed/feed_detail_screen.dart';
import 'package:jaansay_public_user/screens/feed/image_view_screen.dart';
import 'package:jaansay_public_user/screens/feed/pdf_view_screen.dart';
import 'package:jaansay_public_user/widgets/feed/feed_top_details.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:easy_localization/easy_localization.dart';

class FeedCard extends StatelessWidget {
  final Feed feed;
  final bool isDetail;
  final bool isBusiness;

  FeedCard({this.feed, this.isDetail, this.isBusiness});

  Color _color;
  double height = 0, width = 0;

  UserFeedProvider _userFeedProvider;
  OfficialFeedProvider _businessFeedProvider;

  Widget _getImg(String url, BuildContext context) {
    return InkWell(
      onTap: isDetail
          ? () {
              pushNewScreenWithRouteSettings(context,
                  screen: ImageViewScreen(),
                  settings: RouteSettings(arguments: url),
                  pageTransitionAnimation: PageTransitionAnimation.fade);
            }
          : null,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }

  Widget _midDetail(BuildContext context) {
    return feed.media.length == 0
        ? SizedBox.shrink()
        : SizedBox(
            height: 250.0,
            width: width,
            child: Hero(
              tag: "${feed.feedId}",
              child: Carousel(
                images: feed.media.map((e) {
                  return _getImg(e, context);
                }).toList(),
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotColor: Get.theme.accentColor,
                indicatorBgPadding: 5.0,
                dotBgColor: Colors.transparent,
                borderRadius: false,
                autoplay: false,
              ),
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

  Widget _getDoc(String docPath) {
    return InkWell(
      onTap: () {
        if (!isDetail) {
          Navigator.of(Get.context)
              .pushNamed(PDFViewScreen.routeName, arguments: docPath);
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shadowColor: _color,
        elevation: 2,
        child: Container(
          width: 75,
          height: 75,
          alignment: Alignment.center,
          child: Icon(
            MdiIcons.filePdfBox,
            color: _color,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _midPdfDetail() {
    return Container(
        height: 95,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return _getDoc(feed.media[index]);
            },
            itemCount: feed.media.length));
  }

  Widget _likeShare(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.loose,
          child: InkWell(
            onTap: () {
              if (isBusiness) {
                _businessFeedProvider.likeFeed(feed, _userFeedProvider);
              } else {
                _userFeedProvider.likeFeed(feed);
              }
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
                  subject: 'Check out this post');
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

  mainBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        FeedTopDetails(feed),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            if (!isDetail) {
              pushNewScreenWithRouteSettings(context,
                  screen: FeedDetailScreen(),
                  settings: RouteSettings(arguments: [feed, isBusiness]),
                  pageTransitionAnimation: PageTransitionAnimation.fade);
            }
          },
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (feed.docId == 0) _midDetail(context),
                _bottomDetail(),
                if (feed.docId == 2) _midPdfDetail(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        _likeShare(Get.context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _businessFeedProvider = Provider.of<OfficialFeedProvider>(context);
    _userFeedProvider = Provider.of<UserFeedProvider>(context);

    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    height = _mediaQuery.height;
    width = _mediaQuery.width;

    return isDetail
        ? Container(
            child: mainBody(context),
          )
        : Card(margin: EdgeInsets.only(bottom: 10), child: mainBody(context));
  }
}
