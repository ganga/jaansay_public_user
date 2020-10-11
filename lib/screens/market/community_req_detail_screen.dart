import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/market/offer_seller_profile.dart';
import 'package:jaansay_public_user/widgets/misc/custom_divider.dart';

class CommunityReqDetailScreen extends StatefulWidget {
  @override
  _CommunityReqDetailScreenState createState() =>
      _CommunityReqDetailScreenState();
}

class _CommunityReqDetailScreenState extends State<CommunityReqDetailScreen> {
  Widget _getImg() {
    return CachedNetworkImage(
      imageUrl:
          "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg",
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget _photoCarousel() {
    return SizedBox(
      height: 250.0,
      width: double.infinity,
      child: Carousel(
        images: [0, 1, 2].map((e) {
          return _getImg();
        }).toList(),
        dotSize: 4.0,
        dotSpacing: 15.0,
        dotColor: Theme.of(context).accentColor,
        indicatorBgPadding: 5.0,
        dotBgColor: Colors.transparent,
        borderRadius: false,
        autoplay: false,
      ),
    );
  }

  Widget descriptionSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Description of lost pet including: general height/weight, nature of pet (friendly/timid/etc.), detailed coloring, any distinguishing markings or characteristics. Also include where the pet was lost and phone numbers whereyou can be reached at. Make sure all phone numbers are correct and current and number is bolded.",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget headerSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Missing dog, Gooffy",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "12th Oct 2020",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _photoCarousel(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerSection(),
                    CustomDivider(),
                    descriptionSection(),
                    CustomDivider(),
                    OfferSellerProfile(false)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
