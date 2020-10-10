import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/screens/feed/image_view_screen.dart';
import 'package:jaansay_public_user/screens/feed/pdf_view_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedDetailScreen extends StatefulWidget {
  @override
  _FeedDetailScreenState createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  Map<String, dynamic> _feedList;

  Color _color;
  double height = 0, width = 0;
  final box = GetStorage();
  bool isLoad = false;

  Widget _topDetail() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: _color,
            backgroundImage: NetworkImage(
              "https://cdn.fastly.picmonkey.com/contentful/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=800&q=70",
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Alice Josh",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              Text(
                "Sept 20, 2020",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getImg(String url) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ImageViewScreen.routeName, arguments: url);
      },
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }

  Widget _midDetail() {
    return Hero(
      tag: _feedList['feedId'].toString(),
      child: SizedBox(
          height: 250.0,
          width: width,
          child: Carousel(
            images: _feedList['feedRes'].map((e) {
              return _getImg(e);
            }).toList(),
            dotSize: 4.0,
            dotSpacing: 15.0,
            dotColor: Theme.of(context).accentColor,
            indicatorBgPadding: 5.0,
            dotBgColor: Colors.transparent,
            borderRadius: false,
            autoplay: false,
          )),
    );
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
          SelectableLinkify(
            onOpen: (link) async {
              if (await canLaunch(link.url)) {
                await launch(link.url);
              } else {
                throw 'Could not launch $link';
              }
            },
            enableInteractiveSelection: true,
            text: _feedList['feedDescription'].toString(),
            textAlign: TextAlign.start,
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
            return _getDoc(_feedList['feedRes'][index]);
          },
          itemCount: _feedList['feedRes'].length),
    );
  }

  @override
  Widget build(BuildContext context) {
    _feedList = {
      'feedId': 1,
      'feedDescription': "Description",
      'time': DateTime.now(),
      'feedType': "Image",
      'feedRes': [
        "https://i.pinimg.com/originals/ca/76/0b/ca760b70976b52578da88e06973af542.jpg",
        "https://i.pinimg.com/originals/ca/76/0b/ca760b70976b52578da88e06973af542.jpg"
      ],
      'userName': "User",
      'userId': 1,
      'userProfile':
          "https://cdn.fastly.picmonkey.com/contentful/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=800&q=70",
      'categoryName': "public",
    };

    final _mediaQuery = MediaQuery.of(context).size;
    height = _mediaQuery.height;
    width = _mediaQuery.width;

    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              _topDetail(),
              SizedBox(
                height: 10,
              ),
              if (_feedList['feedType'] == 'Image') _midDetail(),
              _bottomDetail(),
              if (_feedList['feedType'] == 'Document') _midPdfDetail(),
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
