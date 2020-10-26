import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/grievance.dart';
import 'package:jaansay_public_user/service/grievance_service.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_divider.dart';
import 'package:jaansay_public_user/widgets/misc/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GrievanceHistoryScreen extends StatefulWidget {
  @override
  _GrievanceHistoryScreenState createState() => _GrievanceHistoryScreenState();
}

class _GrievanceHistoryScreenState extends State<GrievanceHistoryScreen> {
  List<Grievance> grievances = [];

  bool isLoad = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  getData() async {
    grievances.clear();
    GrievanceService grievanceService = GrievanceService();
    grievances = await grievanceService.getAllUserGrievances();
    isLoad = false;
    _refreshController.refreshCompleted();
    setState(() {});
  }

  grievanceTile(BuildContext context, Grievance grievance) {
    String status = grievance.statusId == 3
        ? "Acknowledged"
        : grievance.statusId == 2
            ? "Seen"
            : "Not Seen";
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: Get.width * 0.05,
                right: Get.width * 0.05),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child:
                          ClipOval(child: CustomNetWorkImage(grievance.photo)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${grievance.officialsName}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "+91 ${grievance.officialsPhone}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 13),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${grievance.grievanceMessage}",
                                    style: TextStyle(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                      text: "Status: ",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      )),
                                  TextSpan(
                                    text: "$status",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).primaryColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: CustomDivider()),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? Loading()
        : SmartRefresher(
            enablePullDown: true,
            header: ClassicHeader(),
            onRefresh: getData,
            controller: _refreshController,
            child: grievances.length == 0
                ? CustomErrorWidget(
                    title: 'No grievances found',
                    iconData: MdiIcons.messageAlertOutline,
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      return grievanceTile(context, grievances[index]);
                    },
                    itemCount: grievances.length,
                  ));
  }
}
