import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/market/offer_seller_profile.dart';

class OfferDetailScreen extends StatefulWidget {
  @override
  _OfferDetailScreenState createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen> {
  Widget _getImg() {
    return CachedNetworkImage(
      imageUrl: "https://images.freekaamaal.com/post_images/1576047645.png",
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
            "Catalog Name:*Urbane Sensational Men Shirt FabricFabric: Cotton Pattern: Variable (Product Dependent) Multipack: 1 Sizes: 2.5m Dispatch: 2-3 Days Easy Returns Available In Case Of Any Issue  *Proof of Safe Delivery! Click to know on Safety Standards of Delivery Partners- https://bit.ly/30lPKZF",
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
            "Urbane Sensational Men Shirt Fabric: Cotton",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "₹ 299",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Divider(
      thickness: 0.5,
      color: Colors.black.withOpacity(0.3),
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
                    divider(),
                    descriptionSection(),
                    divider(),
                    OfferSellerProfile()
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
