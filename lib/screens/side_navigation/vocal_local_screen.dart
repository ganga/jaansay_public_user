import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jaansay_public_user/widgets/misc/location_picker.dart';

class VocalLocalScreen extends StatelessWidget {
  VocalLocalScreen({Key key}) : super(key: key);
  Completer<GoogleMapController> _controller = Completer();
  LatLng userPosition = LatLng(13.331781, 74.747334);

  Widget _customTextField(String hint, String label) {
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
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
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
              child: Hero(
                tag: "mainlogo",
                child: Image.asset(
                  "assets/images/localshop.png",
                  height: Get.width * 0.5,
                  width: Get.width * 0.5,
                ),
              ),
            ),
            _customTextField("Enter owner name", "Owner Name"),
            _customTextField("Enter Business name", "Business Name"),
            _customTextField("Enter phone number", "Phone"),
            _customTextField("Enter the brief description", "Description"),
            _getMap(userPosition),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(8),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 15),
                color: Theme.of(context).primaryColor,
                onPressed: () {},
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
