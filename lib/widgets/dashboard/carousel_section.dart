// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:carousel_pro/carousel_pro.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/misc.dart';
import 'package:jaansay_public_user/providers/coupon_provider.dart';
import 'package:jaansay_public_user/screens/coupon/coupon_screen.dart';
import 'package:jaansay_public_user/service/misc_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class CarouselSection extends StatefulWidget {
  @override
  _CarouselSectionState createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> {
  MiscService miscService = MiscService();
  List<CarouselData> carouselDataList = [];
  bool isLoad = true;

  getData() async {
    await miscService.getCarouselData(carouselDataList);
    isLoad = false;
    setState(() {});
  }

  Widget _getImg(CarouselData carouselData, BuildContext context) {
    return CustomNetWorkImage(carouselData.url,
        assetLink: Constants.productHolderURL);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);

    return !isLoad && carouselDataList.length == 0
        ? SizedBox.shrink()
        : AspectRatio(
            aspectRatio: 2,
            child: Container(
              width: Get.width,
              child: isLoad
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    )
                  : Carousel(
                      images: carouselDataList.map((e) {
                        return _getImg(e, context);
                      }).toList(),
                      dotSize: 4.0,
                      dotSpacing: 15.0,
                      dotColor: Colors.white,
                      dotIncreasedColor: Get.theme.primaryColor,
                      indicatorBgPadding: 5.0,
                      dotBgColor: Colors.black.withOpacity(0.1),
                      borderRadius: false,
                      autoplay: true,
                      autoplayDuration: Duration(seconds: 4),
                      onImageTap: (index) async {
                        if (carouselDataList[index].code == 1) {
                          await canLaunch(carouselDataList[index].onTap)
                              ? await launch(
                                  carouselDataList[index].onTap,
                                  forceWebView: true,
                                  enableJavaScript: true,
                                )
                              : throw 'Could not launch';
                        } else if (carouselDataList[index].code == 2) {
                          if (carouselDataList[index].onTap == 'AVAIL_COUPON') {
                            couponProvider.clearData();
                            Get.to(
                                () => CouponScreen(
                                      initialIndex: 1,
                                    ),
                                transition: Transition.rightToLeft);
                          }
                        }
                      },
                    ),
            ),
          );
  }
}
