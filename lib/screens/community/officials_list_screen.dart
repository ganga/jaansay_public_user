import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/community/officials_list_group.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jaansay_public_user/widgets/misc/custom_error_widget.dart';
import 'package:provider/provider.dart';

class OfficialListScreen extends StatefulWidget {
  @override
  _OfficialListScreenState createState() => _OfficialListScreenState();
}

class _OfficialListScreenState extends State<OfficialListScreen> {
  String title = "Business";
  String districtId;

  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    List response = ModalRoute.of(context).settings.arguments;
    final _mediaQuery = MediaQuery.of(context).size;
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
      body: officialProfileProvider.isLoad
          ? Loading()
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
                                horizontal: _mediaQuery.width * 0.08,
                                vertical: _mediaQuery.height * 0.05),
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
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => OfficialsListGroup(
                                officialProfileProvider.officialTypes[index],
                                officialProfileProvider.officials),
                            itemCount:
                                officialProfileProvider.officialTypes.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
