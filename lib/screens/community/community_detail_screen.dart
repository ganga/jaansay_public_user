// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// Project imports:
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/community/officials_list_screen.dart';
import 'package:jaansay_public_user/service/misc_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';

class CommunityDetailsScreen extends StatefulWidget {
  @override
  _CommunityDetailsScreenState createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  MiscService miscService = MiscService();
  bool isLoad = true;
  Map count = {};

  getDistrictData() async {
    count.clear();
    await miscService.getAllCountDistrict(count);
    isLoad = false;
    setState(() {});
  }

  Widget _dataBox(
      String number, OfficialType officialType, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 120),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Theme.of(context).primaryColor)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                pushNewScreen(context,
                    screen: OfficialListScreen(officialType),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      tr(officialType.typeName),
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Divider(
                        thickness: 0.5,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      number,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    ),
                  ],
                ),
              ),
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
    getDistrictData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad
          ? CustomLoading()
          : Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // SizedBox(
                  //   height: Get.height * 0.03,
                  // ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Bommarbettu",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ).tr(),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                  // _dataBox(
                  //     "${count['user']}",
                  //     "Public Users",
                  //     context,
                  //     _mediaQuery.height,
                  //     _mediaQuery.width,
                  //     ProfileListScreen(),
                  //     "public"),
                  _dataBox(count['business'],
                      OfficialType(typeId: 101, typeName: "Business"), context),
                  _dataBox(
                      count['entity'],
                      OfficialType(
                          typeId: 103,
                          typeName: "Appointed Officials and Elected Members"),
                      context),
                  _dataBox(
                      count['association'],
                      OfficialType(
                          typeId: 102, typeName: "Associations and Bodies"),
                      context),
                ],
              ),
            ),
    );
  }
}
