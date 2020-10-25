import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jaansay_public_user/service/vocalforlocal_service.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/misc/location_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class VocalLocalScreen extends StatefulWidget {
  VocalLocalScreen({Key key}) : super(key: key);

  @override
  _VocalLocalScreenState createState() => _VocalLocalScreenState();
}

class _VocalLocalScreenState extends State<VocalLocalScreen> {
  LatLng userPosition = LatLng(13.331781, 74.747334);

  String latitude = "0", longitude = "0";
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isLoad = false;

  Widget _customTextField(
      String hint, String label, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }

  Widget _getMap(LatLng userPosition) {
    return InkWell(
      onTap: () {
        Get.to(LocationPicker());
      },
      child: Container(
        height: Get.height * 0.3,
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: Get.height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Choose location",
                    style: TextStyle(),
                  ),
                  Icon(Icons.location_on)
                ],
              ),
            ),
            Expanded(
              child: GoogleMap(
                markers: {
                  Marker(
                    markerId: MarkerId("marker"),
                    position: userPosition,
                  ),
                },
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: LatLng(13.331781, 74.747334), zoom: 18),
              ),
            ),
          ],
        ),
      ),
    );
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
                        ? label
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
      return;
    } else {
      isLoad = true;
      setState(() {});
      VocalforlocalService vocalforlocalService = VocalforlocalService();
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
          title: Text("Successfull!!!"),
          content: Text("Your request has been sent."),
          actions: [
            FlatButton(
                onPressed: () {
                  Get.close(0);
                },
                child: Text("Okay"))
          ],
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Vocal4Local"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/localshop.png",
                height: Get.width * 0.5,
                width: Get.width * 0.5,
              ),
            ),
            _customTextField(
              "Enter Business name",
              "Business Name",
              nameController,
            ),
            _customTextField(
              "Enter phone number",
              "Phone",
              phoneController,
            ),
            Text(
              "Add Location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 8,
            ),
            attachments("Add Location", Icons.location_pin, 1),
            SizedBox(
              height: 16,
            ),
            isLoad
                ? Loading()
                : Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(8),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        sendData();
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
