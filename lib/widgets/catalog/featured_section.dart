// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/catalog_service.dart';
import 'package:jaansay_public_user/widgets/catalog/catalog_discount_text_widget.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_network_image.dart';

class FeatureSection extends StatefulWidget {
  final Official official;

  FeatureSection(this.official);

  @override
  __FeatureSectionState createState() => __FeatureSectionState();
}

class __FeatureSectionState extends State<FeatureSection> {
  bool isLoad = true;
  List<Product> featuredProducts = [];
  CatalogService catalogService = CatalogService();

  getAllFeaturedProducts() async {
    isLoad = true;
    featuredProducts.clear();
    await catalogService.getFeaturedProducts(
        featuredProducts, widget.official.officialsId.toString());
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllFeaturedProducts();
  }

  @override
  Widget build(BuildContext context) {
    if (featuredProducts.length == 0) {
      return SizedBox.shrink();
    } else {
      return Card(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Featured Products",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.65),
                      letterSpacing: 0.45),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: Get.height * 0.2,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredProducts.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 175,
                      margin: EdgeInsets.only(right: 16),
                      child: InkWell(
                        onTap: () {
                          // Get.bottomSheet(
                          //   ProductDetailBottomSheet(index,
                          //       featuredProducts[index], widget.official),
                          //   isScrollControlled: true,
                          // );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomNetWorkImage(
                                featuredProducts[index].cpPhoto.length == 0
                                    ? ''
                                    : featuredProducts[index].cpPhoto.first,
                                assetLink: Constants.productHolderURL,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(featuredProducts[index].cpName),
                            const SizedBox(
                              height: 4,
                            ),
                            CatalogDiscountTextWidget(
                                featuredProducts[index].cpCost,
                                featuredProducts[index].cpDiscountCost)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
