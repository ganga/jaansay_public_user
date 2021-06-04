// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/profile_full_screen.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class OfficialListScreen extends StatefulWidget {
  final OfficialType officialType;

  OfficialListScreen(this.officialType);

  @override
  _OfficialListScreenState createState() => _OfficialListScreenState();
}

class _OfficialListScreenState extends State<OfficialListScreen> {
  OfficialService officialService = OfficialService();

  List<Official> officials = [];
  List<String> officialTypes = [];

  String selectedType = 'ALL';

  bool isLoad = true;

  getData() async {
    await officialService.getAllOfficialsType(
        officials, widget.officialType.typeId, "1");
    officials.removeWhere(
        (element) => element.isPrivate == 1 && element.isFollow != 1);

    officials.map((e) {
      if (!officialTypes.contains(e.businesstypeName)) {
        officialTypes.add(e.businesstypeName);
      }
    }).toString();

    officialTypes.sort((a, b) => a.compareTo(b));
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad
          ? CustomLoading()
          : officials.length == 0
              ? CustomErrorWidget(
                  title: tr("No users found"),
                  iconData: Icons.supervised_user_circle_sharp,
                )
              : SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Card(
                          margin: EdgeInsets.zero,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.08,
                                vertical: Get.height * 0.05),
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              tr(widget.officialType.typeName),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 26),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.04,
                          ),
                          child: Row(
                            children: [
                              Text("Filter:"),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: DropdownButton(
                                  value: selectedType,
                                  isExpanded: true,
                                  iconEnabledColor:
                                      Theme.of(context).primaryColor,
                                  items: [
                                        DropdownMenuItem(
                                          child: Text(
                                            'ALL',
                                            style: TextStyle(fontSize: 14),
                                          ).tr(),
                                          value: 'ALL',
                                        )
                                      ] +
                                      officialTypes.map((e) {
                                        return DropdownMenuItem(
                                          child: Text(
                                            e,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          value: e,
                                        );
                                      }).toList(),
                                  onChanged: (val) {
                                    selectedType = val;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                _OfficialsListGroup(
                                    selectedType == 'ALL'
                                        ? officialTypes[index]
                                        : selectedType,
                                    officials),
                            itemCount: selectedType == 'ALL'
                                ? officialTypes.length
                                : 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class _OfficialsListGroup extends StatelessWidget {
  final String type;
  final List<Official> officials;

  _OfficialsListGroup(this.type, this.officials);

  @override
  Widget build(BuildContext context) {
    List<Official> filteredOfficials = [];

    officials.map((e) {
      if (e.businesstypeName == type) {
        return filteredOfficials.add(e);
      }
    }).toList();

    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: Get.width * 0.04, vertical: Get.height * 0.02),
      child: Container(
        width: double.infinity,
        padding:
            EdgeInsets.symmetric(vertical: 10, horizontal: Get.width * 0.03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type),
            Divider(
              thickness: 1,
              color: Colors.black54,
            ),
            Container(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredOfficials.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                    horizontal: 5, vertical: Get.height * 0.02),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: Get.width * 0.03,
                    mainAxisSpacing: Get.height * 0.02),
                itemBuilder: (context, index) {
                  return _BusinessListItem(filteredOfficials[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusinessListItem extends StatelessWidget {
  final Official official;

  _BusinessListItem(this.official);

  @override
  Widget build(BuildContext context) {
    OfficialProfileProvider officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context, listen: false);

    return InkWell(
      onTap: () {
        officialProfileProvider.clearData();

        Get.to(() => ProfileFullScreen(official.officialsId),
            transition: Transition.rightToLeft);
      },
      child: Container(
        child: Column(
          children: [
            Expanded(child: CustomNetWorkImage(official.photo)),
            SizedBox(
              height: 4,
            ),
            AutoSizeText(
              official.officialsName,
              minFontSize: 12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
