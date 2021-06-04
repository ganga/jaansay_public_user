// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// Project imports:
import 'package:jaansay_public_user/models/misc.dart';
import 'package:jaansay_public_user/service/vocalforlocal_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_fields.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/misc/location_picker.dart';
import 'file:///C:/Users/Deepak/FlutterProjects/jaansay_public_user/lib/widgets/general/custom_auth_button.dart';

class VocalLocalScreen extends StatefulWidget {
  final bool isHome;

  VocalLocalScreen({this.isHome = false});

  @override
  _VocalLocalScreenState createState() => _VocalLocalScreenState();
}

class _VocalLocalScreenState extends State<VocalLocalScreen> {
  LatLng userPosition = LatLng(13.331781, 74.747334);

  String latitude = "0", longitude = "0";
  List<UserType> userTypes = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  VocalForLocalService vocalforlocalService = VocalForLocalService();

  UserType selectedType;
  String selectedSubType;
  bool isLoad = true;

  getUserTypes() async {
    await vocalforlocalService.getTypes(userTypes);
    selectedType = userTypes.first;
    if (selectedType.subTypeNames.length > 0) {
      selectedSubType = selectedType.subTypeNames.first;
    }
    isLoad = false;
    setState(() {});
  }

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
          Radius.circular(10),
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
              Get.focusScope.unfocus();
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
      await vocalforlocalService.addOfficial(
          shopName: nameController.text,
          phone: phoneController.text,
          latitude: latitude,
          longitude: longitude,
          userTypeId: selectedType.typeId,
          subTypeName: selectedSubType);
      nameController.clear();
      phoneController.clear();
      latitude = "0";
      longitude = "0";
      isLoad = false;
      selectedType = userTypes.first;
      if (selectedType.subTypeNames.length > 0) {
        selectedSubType = selectedType.subTypeNames.first;
      } else {
        selectedSubType = null;
      }
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserTypes();
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
      body: isLoad
          ? CustomLoading()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                    Text(
                      "Can't find local business, entities or associations near you?\n\nPlease let us know & we will add them here.",
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
                    attachments("Add Location", Icons.location_pin, 1),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField<UserType>(
                        value: selectedType,
                        isExpanded: true,
                        decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            labelText: 'Type',
                            labelStyle:
                                TextStyle(color: Get.theme.primaryColor)),
                        items: userTypes.map((UserType value) {
                          return DropdownMenuItem<UserType>(
                            value: value,
                            child: Text(value.typeName),
                          );
                        }).toList(),
                        onTap: () {
                          Get.focusScope.unfocus();
                        },
                        onChanged: (val) {
                          selectedType = val;
                          if (selectedType.subTypeNames.length > 0) {
                            selectedSubType = selectedType.subTypeNames.first;
                          } else {
                            selectedSubType = null;
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    if (selectedSubType != null)
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonFormField<String>(
                          value: selectedSubType,
                          isExpanded: true,
                          decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              labelText: 'Sub Type',
                              labelStyle:
                                  TextStyle(color: Get.theme.primaryColor)),
                          items: selectedType.subTypeNames.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onTap: () {
                            Get.focusScope.unfocus();
                          },
                          onChanged: (val) {
                            selectedSubType = val;
                            setState(() {});
                          },
                        ),
                      ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomAuthButton(
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
