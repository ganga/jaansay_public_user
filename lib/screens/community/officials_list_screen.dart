import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/profile_full_screen.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';
import 'package:provider/provider.dart';

class OfficialListScreen extends StatefulWidget {
  @override
  _OfficialListScreenState createState() => _OfficialListScreenState();
}

class _OfficialListScreenState extends State<OfficialListScreen> {
  String title = "Business";
  String districtId;
  String selectedType = 'ALL';

  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    List response = ModalRoute.of(context).settings.arguments;
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context);
    final type = response[0];
    districtId = response[1];

    if (type == '103') {
      title = "Appointed Officials and Elected Members";
    } else if (type == '102') {
      title = "Associations and Bodies";
    }

    if (!isCheck) {
      isCheck = true;
      officialProfileProvider.getData(type, districtId);
    }

    return Scaffold(
      body: officialProfileProvider.isListLoad
          ? CustomLoading()
          : officialProfileProvider.officials.length == 0
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
                              tr(title),
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
                                          ),
                                          value: 'ALL',
                                        )
                                      ] +
                                      officialProfileProvider.officialTypes
                                          .map((e) {
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
                                  ? officialProfileProvider.officialTypes[index]
                                  : selectedType,
                            ),
                            itemCount: selectedType == 'ALL'
                                ? officialProfileProvider.officialTypes.length
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

  _OfficialsListGroup(this.type);

  @override
  Widget build(BuildContext context) {
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context);

    List<Official> filteredList =
        officialProfileProvider.getOfficialsOfType(type);

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
                itemCount: filteredList.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                    horizontal: 5, vertical: Get.height * 0.02),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: Get.width * 0.03,
                    mainAxisSpacing: Get.height * 0.02),
                itemBuilder: (context, index) {
                  return _BusinessListItem(filteredList[index]);
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
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context);

    return InkWell(
      onTap: () {
        if (official.isPrivate == 1 && official.isFollow == null) {
          Get.dialog(AlertDialog(
            title: Text("Private Association").tr(),
            content: Text(
                    "Sorry, this is an private association. Only users part of this assocation can view the details. Please contact the admin to join this group.")
                .tr(),
            actions: [
              TextButton(
                onPressed: () {
                  Get.close(1);
                },
                child: Text(
                  "Okay",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ).tr(),
              )
            ],
          ));
        } else {
          officialProfileProvider.clearData();
          officialProfileProvider.selectOfficialIndex(official);
          Get.to(() => ProfileFullScreen(), transition: Transition.rightToLeft);
        }
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
