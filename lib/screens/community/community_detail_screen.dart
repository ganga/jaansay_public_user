import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/officials_list_screen.dart';
import 'package:jaansay_public_user/screens/community/profile_list_screen.dart';
import 'package:jaansay_public_user/service/misc_service.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CommunityDetailsScreen extends StatefulWidget {
  @override
  _CommunityDetailsScreenState createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  OfficialProfileProvider officialProvider;
  bool isLoad = true;

  bool isCheck = false;

  Map count = {};
  List<String> districts = [];
  GetStorage box = GetStorage();
  String selectedDistrict = "";
  String districtId = "1";

  getData() async {
    isLoad = true;
    setState(() {});
    MiscService miscService = MiscService();
    districts.clear();
    count.clear();
    await miscService.getAllCount(
      count,
    );

    isLoad = false;
    setState(() {});
  }

  getDistrictData() async {
    isLoad = true;
    setState(() {});
    MiscService miscService = MiscService();
    count.clear();
    await miscService.getAllCountDistrict(count, districtId.toString());
    isLoad = false;
    setState(() {});
  }

  Widget _dataBox(String number, String title, BuildContext context,
      Widget widget, String type) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.only(bottom: Get.height * 0.04),
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
                officialProvider.clearData(allData: true);
                pushNewScreenWithRouteSettings(context,
                    screen: widget,
                    settings: RouteSettings(arguments: [type, districtId]),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      tr(title),
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
  Widget build(BuildContext context) {
    officialProvider =
        Provider.of<OfficialProfileProvider>(context, listen: false);

    if (!isCheck) {
      isCheck = true;
      getDistrictData();
    }
    return Scaffold(
      body: isLoad
          ? Loading()
          : SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.08),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
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
                            "Udupi",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ).tr(),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    // _dataBox(
                    //     "${count['user']}",
                    //     "Public Users",
                    //     context,
                    //     _mediaQuery.height,
                    //     _mediaQuery.width,
                    //     ProfileListScreen(),
                    //     "public"),
                    _dataBox("${count['business']}", "Business", context,
                        OfficialListScreen(), "101"),
                    _dataBox(
                        "${count['entity']}",
                        "Appointed Officials and Elected Members",
                        context,
                        OfficialListScreen(),
                        "103"),
                    _dataBox(
                        "${count['association']}",
                        "Associations and Bodies",
                        context,
                        OfficialListScreen(),
                        "102"),
                  ],
                ),
              ),
            ),
    );
  }
}
