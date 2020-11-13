import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/grievance/grievance_send_screen.dart';
import 'package:jaansay_public_user/widgets/misc/custom_divider.dart';
import 'package:jaansay_public_user/widgets/profile/contact_header.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Official official;

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
              title,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.1,
                  fontSize: 12),
            ).tr(),
          ],
        ),
      ),
    );
  }

  Widget contactSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          contactSectionItems(context, "CALL", MdiIcons.phone, () async {
            final url = "tel:${official.officialsPhone}";
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          }),
          contactSectionItems(context, "GRIEVANCE", MdiIcons.messageAlert, () {
            pushNewScreenWithRouteSettings(context,
                screen: GrievanceSendScreen(),
                settings: RouteSettings(arguments: official),
                withNavBar: true);
          }),
          contactSectionItems(context, "SHARE", MdiIcons.shareVariant, () {}),
        ],
      ),
    );
  }

  Widget addressSection(BuildContext context) {
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
    official = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Card(
        margin: EdgeInsets.zero,
        child: Container(
          child: Column(
            children: [
              ContactHeader(),
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
              addressSection(context),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CustomDivider()),
              contactSection(context)
            ],
          ),
        ),
      ),
    );
  }
}
