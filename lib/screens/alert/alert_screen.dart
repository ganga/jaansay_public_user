import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaansay_public_user/models/alert.dart';
import 'package:jaansay_public_user/service/alert_service.dart';
import 'package:jaansay_public_user/widgets/misc/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  bool isLoad = true;
  List<Alert> alerts = [];

  getAlert() async {
    alerts.clear();
    AlertService alertService = AlertService();
    alerts = await alertService.getAllAlerts();
    isLoad = false;
    setState(() {});
  }

  Widget alertTop(Alert alert) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(child: CustomNetWorkImage(alert.photo)),
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${alert.officialsName}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                        text: "#${alert.typeName} ",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).primaryColor,
                        )),
                    TextSpan(
                      text: DateFormat.yMMMd().add_jm().format(alert.updatedAt),
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget alertTile(Alert alert) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            alertTop(alert),
            SizedBox(
              height: 12,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Text("${alert.alertMessage}"),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAlert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: alerts.length == 0
            ? CustomErrorWidget(
                iconData: Icons.add_alert,
                title: "No alerts found",
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return alertTile(alerts[index]);
                },
                itemCount: alerts.length,
              ));
  }
}
