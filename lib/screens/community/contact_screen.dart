import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/grievance/grievance_detail_screen.dart';
import 'package:jaansay_public_user/widgets/profile/contact_header.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_divider.dart';

class ContactScreen extends StatelessWidget {
  Widget contactSectionItems(
      BuildContext context, String title, IconData iconData, Function onTap) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
              child: Icon(
                iconData,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              tr(title),
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.1,
                  fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget contactSection(BuildContext context, Official official) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          contactSectionItems(context, "CALL", MdiIcons.phone, () async {
            final url =
                "tel:${official.officialDisplayPhone.length == 0 ? official.officialsPhone : official.officialDisplayPhone}";
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          }),
          contactSectionItems(context, "GRIEVANCE", MdiIcons.messageAlert, () {
            if (official.isFollow == 1) {
              pushNewScreenWithRouteSettings(context,
                  screen: GrievanceDetailScreen(),
                  settings: RouteSettings(arguments: [false, official]),
                  withNavBar: false);
            } else {
              Get.rawSnackbar(
                  message: "You need to follow the user to send grievances");
            }
          }),
          contactSectionItems(context, "SHARE", MdiIcons.shareVariant, () {
            Share.share(
              'Download JaanSay app https://play.google.com/store/apps/details?id=com.dev.jaansay_public_user',
            );
          }),
        ],
      ),
    );
  }

  Widget addressSection(BuildContext context, Official official) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Address",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ).tr(),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 35,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text("${official.officialsAddress}"),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context);
    Official official = officialProfileProvider
        .officials[officialProfileProvider.selectedOfficialIndex];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Contact",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Card(
          margin: EdgeInsets.zero,
          child: Container(
            child: Column(
              children: [
                ContactHeader(official),
                Expanded(
                  child: GoogleMap(
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(double.parse(official.lattitude),
                            double.parse(official.longitude)),
                        zoom: 18),
                    markers: {
                      Marker(
                          markerId: MarkerId("marker"),
                          position: LatLng(double.parse(official.lattitude),
                              double.parse(official.longitude)))
                    },
                  ),
                ),
                addressSection(context, official),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CustomDivider()),
                contactSection(context, official)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
