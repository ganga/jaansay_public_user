import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/screens/feed/feed_detail_screen.dart';
import 'package:jaansay_public_user/screens/feed/pdf_view_screen.dart';
import 'package:jaansay_public_user/service/feed_service.dart';
import 'package:jaansay_public_user/widgets/feed/feed_top_details.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share/share.dart';

class FeedCard extends StatefulWidget {
  final Feed feed;

  FeedCard(this.feed);

  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  Color _color;
  double height = 0, width = 0;

  Widget _getImg(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget _midDetail() {
    return widget.feed.media.length == 0
        ? SizedBox.shrink()
        : SizedBox(
            height: 250.0,
            width: width,
            child: Hero(
              tag: "${widget.feed.feedId}",
              child: Carousel(
                images: widget.feed.media.map((e) {
                  return _getImg(e);
                }).toList(),
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotColor: Theme.of(context).accentColor,
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
            widget.feed.feedDescription.toString(),
            textAlign: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${widget.feed.likes} Likes",
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
        Navigator.of(context)
            .pushNamed(PDFViewScreen.routeName, arguments: docPath);
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
              return _getDoc(widget.feed.media[index]);
            },
            itemCount: widget.feed.media.length));
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
              likeFeed();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.thumb_up,
                    color: widget.feed.isLiked == 1
                        ? Get.theme.primaryColor
                        : Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.feed.isLiked == 1 ? "Liked" : "Like",
                    style: TextStyle(
                        color: widget.feed.isLiked == 1
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
              Share.share('${widget.feed.feedTitle}',
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  likeFeed() async {
    if (widget.feed.isLiked == 0) {
      FeedService feedService = FeedService();
      widget.feed.isLiked = 1;
      widget.feed.likes = widget.feed.likes + 1;
      setState(() {});
      await feedService.likeFeed(widget.feed.feedId);
    }
  }

  @override
  Widget build(BuildContext context) {
    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    height = _mediaQuery.height;
    width = _mediaQuery.width;

    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          FeedTopDetails(widget.feed),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              pushNewScreenWithRouteSettings(context,
                  screen: FeedDetailScreen(),
                  settings: RouteSettings(arguments: [widget.feed, likeFeed]),
                  pageTransitionAnimation: PageTransitionAnimation.fade);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.feed.docId == 0) _midDetail(),
                _bottomDetail(),
                if (widget.feed.docId == 2) _midPdfDetail(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          _likeShare(context),
        ],
      ),
    );
  }
}
