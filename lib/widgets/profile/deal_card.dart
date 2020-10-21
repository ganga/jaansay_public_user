import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/screens/feed/pdf_view_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DealCard extends StatelessWidget {
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

  Widget _midDetail(BuildContext context) {
    return SizedBox(
        height: 250.0,
        width: width,
        child: Carousel(
          images: [0, 1, 2].map((e) {
            return _getImg(
                "https://images.freekaamaal.com/post_images/1576047645.png");
          }).toList(),
          dotSize: 4.0,
          dotSpacing: 15.0,
          dotColor: Theme.of(context).accentColor,
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
            "Sale start from October to January. Get it soon on all types of clothing.",
            textAlign: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _getDoc(String docPath, BuildContext context) {
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

  Widget _likeShare() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(Icons.thumb_up_alt_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {},
        ),
      ],
    );
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
          //FeedTopDetails(),
          SizedBox(
            height: 10,
          ),
          _midDetail(context),
          _bottomDetail(),
          SizedBox(
            height: 10,
          ),
          _likeShare(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
