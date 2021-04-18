import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jaansay_public_user/models/grievance.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/grievance_provider.dart';
import 'package:jaansay_public_user/screens/grievance/grievance_add_screen.dart';
import 'package:jaansay_public_user/screens/grievance/grievance_detail_screen.dart';
import 'package:jaansay_public_user/service/grievance_service.dart';
import 'package:jaansay_public_user/widgets/dashboard/grievance_status.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class GrievanceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final grievanceProvider = Provider.of<GrievanceProvider>(context);

    Official official = grievanceProvider.selectedOfficial;

    if (!grievanceProvider.initMaster) {
      grievanceProvider.initMaster = true;
      grievanceProvider.getAllGrievanceMasters();
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leadingWidth: 50,
        title: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(child: CustomNetWorkImage(official.photo)),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              official.officialsName,
              style: TextStyle(
                color: Get.theme.primaryColor,
              ),
            ).tr(),
          ],
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () async {
              final url = "tel:${official.officialDisplayPhone}";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw '${tr("Could not launch")} $url';
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.call,
                size: 26,
                color: Get.theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: grievanceProvider.isMasterLoad
          ? null
          : FloatingActionButton.extended(
              backgroundColor: Get.theme.primaryColor,
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text(
                "Add Grievance",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Get.to(() => GrievanceAddScreen(),
                    transition: Transition.rightToLeft);
              },
            ),
      body: grievanceProvider.isMasterLoad
          ? CustomLoading()
          : Container(
              child: ListView.builder(
                itemCount: grievanceProvider.grievanceMasters.length,
                itemBuilder: (context, index) {
                  return _ListItem(grievanceProvider.grievanceMasters[index]);
                },
              ),
            ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final GrievanceMaster grievanceMaster;

  _ListItem(this.grievanceMaster);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          Get.to(GrievanceDetailScreen(grievanceMaster),
              transition: Transition.rightToLeft);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.flag_sharp,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "TICKET #${grievanceMaster.ticketNumber}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withAlpha(155),
                            letterSpacing: 0.7),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 21,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        DateFormat("dd MMMM yyyy")
                            .format(grievanceMaster.createdAt),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withAlpha(155),
                            letterSpacing: 0.7),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                height: 0.5,
                width: double.infinity,
                color: Colors.black.withAlpha(155),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          grievanceMaster.message,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Icon(Icons.navigate_next)
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              GrievanceStatus(grievanceMaster.isClosed)
            ],
          ),
        ),
      ),
    );
  }
}
