import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/feed.dart';
import 'package:jaansay_public_user/screens/feed/pdf_view_screen.dart';
import 'package:jaansay_public_user/widgets/feed/feed_top_details.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FeedDetailScreen extends StatefulWidget {
  @override
  _FeedDetailScreenState createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  Feed feed;

  Color _color;
  double height = 0, width = 0;
  final box = GetStorage();
  bool isLoad = false;
  Function likeFeedMain;

  Widget _getImg(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget _midDetail() {
    return feed.media.length == 0
        ? SizedBox.shrink()
        : SizedBox(
            height: 250.0,
            width: width,
            child: Hero(
              tag: "${feed.feedId}",
              child: Carousel(
                images: feed.media.map((e) {
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
            feed.feedDescription.toString(),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${feed.likes} Likes",
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
              return _getDoc(feed.media[index].mediaUrl);
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
              likeFeed();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.thumb_up,
                    color: feed.isLiked == 1
                        ? Get.theme.primaryColor
                        : Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    feed.isLiked == 1 ? "Liked" : "Like",
                    style: TextStyle(
                        color: feed.isLiked == 1
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
            onTap: () {},
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

  likeFeed() {
    likeFeedMain();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List response = ModalRoute.of(context).settings.arguments;
    final _mediaQuery = MediaQuery.of(context).size;
    height = _mediaQuery.height;
    width = _mediaQuery.width;
    feed = response[0];
    likeFeedMain = response[1];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              FeedTopDetails(feed),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (feed.docId == 0) _midDetail(),
                  _bottomDetail(),
                  if (feed.docId == 2) _midPdfDetail(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              _likeShare(context),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
