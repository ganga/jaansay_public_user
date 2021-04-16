import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/community/profile_full_screen.dart';
import 'package:jaansay_public_user/screens/home_screen.dart';
import 'package:jaansay_public_user/service/catalog_service.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/catalog/catalog_discount_text_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_divider.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_network_image.dart';
import 'package:share/share.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  ProductDetailScreen({this.productId = "LKEqxD0DVHuk"});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isProductLoad = true;
  bool isOfficialLoad = true;
  CatalogService catalogService = CatalogService();
  OfficialService officialService = OfficialService();
  Product product;
  Official official;

  getProductById() async {
    product = await catalogService.getProductById(widget.productId);
    isProductLoad = false;
    setState(() {});
    official =
        await officialService.getOfficialById(product.officialId.toString());
    isOfficialLoad = false;
    setState(() {});
  }

  imageCard(String url) {
    return CustomNetWorkImage(url);
  }

  optionCard(String title, IconData iconData, Function onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: Get.theme.primaryColor,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductById();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Colors.white,
          leading: InkWell(
              onTap: () {
                Get.offAll(HomeScreen());
              },
              child: Icon(Icons.arrow_back_outlined)),
          title: Text(
            "Product",
            style: TextStyle(
              color: Get.theme.primaryColor,
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            await Get.offAll(HomeScreen());
            return false;
          },
          child: isProductLoad
              ? CustomLoading()
              : SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            height: 250.0,
                            width: double.infinity,
                            child: product.cpPhoto.length == 0
                                ? CustomNetWorkImage(
                                    '',
                                    assetLink: Constants.productHolderURL,
                                  )
                                : Carousel(
                                    images: product.cpPhoto.map((e) {
                                      return imageCard(e);
                                    }).toList(),
                                    dotSize: 4.0,
                                    dotSpacing: 15.0,
                                    dotColor: Get.theme.accentColor,
                                    indicatorBgPadding: 5.0,
                                    dotBgColor: Colors.transparent,
                                    borderRadius: false,
                                    autoplay: false,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (product.cpPriority == 1 || product.cpStock == 0)
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (product.cpStock == 0)
                                  Container(
                                    margin: EdgeInsets.only(right: 8),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 6),
                                    decoration:
                                        BoxDecoration(color: Colors.red),
                                    child: Text(
                                      "Out of Stock",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                if (product.cpPriority == 1)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 6),
                                    decoration: BoxDecoration(
                                        color: Get.theme.primaryColor),
                                    child: Text(
                                      "Featured",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        Text(
                          product.cpName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(product.cpDescription),
                        const SizedBox(
                          height: 8,
                        ),
                        CatalogDiscountTextWidget(
                            product.cpCost, product.cpDiscountCost),
                        const SizedBox(
                          height: 16,
                        ),
                        if (!isOfficialLoad)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomDivider(),
                              const SizedBox(
                                height: 16,
                              ),
                              Text("Seller Details:"),
                              _OfficialTile(official),
                              optionCard("Share", Icons.share, () {
                                Share.share(
                                  'Check out this product from ${official.officialsName}.\n${product.cpName}, ${product.cpDescription}.\n\nClick here to view more details ${product.cpUrl}',
                                );
                              }),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}

class _OfficialTile extends StatelessWidget {
  final Official official;

  _OfficialTile(this.official);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 12,
        bottom: 24,
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(child: CustomNetWorkImage(official.photo)),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${official.officialsName}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RatingBar(
                      itemSize: 20,
                      initialRating: official.averageRating ?? 5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: true,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0),
                      ratingWidget: RatingWidget(
                          full: Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          half: Icon(
                            Icons.star_half,
                            color: Colors.amber,
                          ),
                          empty: Icon(
                            Icons.star_border,
                            color: Colors.amber,
                          )),
                      onRatingUpdate: (rating) {},
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "(${official.totalRating})",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          if (official.isPrivate == 0)
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 0.5),
                  color: Theme.of(context).primaryColor),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.white,
                  onTap: () {
                    Get.to(
                        () => ProfileFullScreen(
                              officialId: official.officialsId.toString(),
                            ),
                        transition: Transition.rightToLeft);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "View Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
