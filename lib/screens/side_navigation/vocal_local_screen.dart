import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jaansay_public_user/service/vocalforlocal_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_fields.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_auth_button.dart';
import 'package:jaansay_public_user/widgets/misc/location_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class VocalLocalScreen extends StatefulWidget {
  final bool isHome;

  VocalLocalScreen({this.isHome = false});

  @override
  _VocalLocalScreenState createState() => _VocalLocalScreenState();
}

class _VocalLocalScreenState extends State<VocalLocalScreen> {
  LatLng userPosition = LatLng(13.331781, 74.747334);

  String latitude = "0", longitude = "0";
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  VocalForLocalService vocalforlocalService = VocalForLocalService();

  bool isLoad = false;

  updateLocation(String lat, String lon) {
    latitude = lat;
    longitude = lon;
    setState(() {});
  }

  Widget attachments(String label, IconData icon, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              pushNewScreenWithRouteSettings(context,
                  screen: LocationPicker(),
                  settings: RouteSettings(arguments: updateLocation));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Icon(icon),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    latitude == "0"
                        ? tr(label)
                        : "${latitude.substring(0, 9)} ${longitude.substring(0, 9)}",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  sendData() async {
    if (nameController.text == "" || phoneController.text == "") {
      Get.rawSnackbar(message: tr("Please fill all the fields"));
    } else {
      isLoad = true;
      setState(() {});
      await vocalforlocalService.addStore(
        shopName: nameController.text,
        phone: phoneController.text,
        latitude: latitude,
        longitude: longitude,
      );
      nameController.clear();
      phoneController.clear();
      latitude = "0";
      longitude = "0";
      isLoad = false;
      Get.dialog(
        AlertDialog(
          title: Text("Successful").tr(),
          content: Text("${tr("Your request has been sent")}."),
          actions: [
            TextButton(
                onPressed: () {
                  Get.close(1);
                },
                child: Text("Okay").tr())
          ],
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isHome
          ? null
          : AppBar(
              automaticallyImplyLeading: true,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              backgroundColor: Colors.white,
              title: Text(
                "Vocal For Local",
                style: TextStyle(
                  color: Get.theme.primaryColor,
                ),
              ).tr(),
            ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/localshop.png",
                  height: Get.width * 0.3,
                  width: Get.width * 0.3,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Can't find local business near you?\nPlease let us know & we will add them here.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ).tr(),
              SizedBox(
                height: 16,
              ),
              CustomTextField(
                  hint: "Enter Business name",
                  label: "Business Name",
                  controller: nameController,
                  isNum: false),
              SizedBox(
                height: 16,
              ),
              CustomTextField(
                  hint: "Enter Phone Number",
                  label: "Phone",
                  controller: phoneController),
              SizedBox(
                height: 16,
              ),
              Text(
                "Add Location",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ).tr(),
              SizedBox(
                height: 16,
              ),
              attachments("Add Location", Icons.location_pin, 1),
              SizedBox(
                height: 16,
              ),
              isLoad
                  ? CustomLoading()
                  : CustomAuthButton(
                      title: "Send",
                      onTap: () => sendData(),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
