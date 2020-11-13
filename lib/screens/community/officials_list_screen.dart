import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/community/officials_list_group.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';

class OfficialListScreen extends StatefulWidget {
  @override
  _OfficialListScreenState createState() => _OfficialListScreenState();
}

class _OfficialListScreenState extends State<OfficialListScreen> {
  String title = "Business";

  bool isLoad = true;

  bool isCheck = false;

  List<Official> officials = [];
  List<String> officialTypes = [];
  String type = "";

  getData() async {
    isLoad = true;
    setState(() {});
    OfficialService officialService = OfficialService();
    officials = await officialService.getAllOfficialsType(type);
    officialTypes = officialService.getOfficialTypes(officials);
    isLoad = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    type = ModalRoute.of(context).settings.arguments;
    final _mediaQuery = MediaQuery.of(context).size;

    if (type == '102') {
      title = "Appointed Officials and Elected Members";
    } else if (type == '103') {
      title = "Associations and Bodies";
    }

    if (!isCheck) {
      isCheck = true;
      getData();
    }

    return Scaffold(
      body: isLoad
          ? Loading()
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
                          style: TextStyle(color: Colors.black, fontSize: 26),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            OfficialsListGroup(officialTypes[index], officials),
                        itemCount: officialTypes.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
