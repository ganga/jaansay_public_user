import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  LocationPicker({Key key}) : super(key: key);

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng userPosition = LatLng(13.331781, 74.747334);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onTap: (val) async {
              userPosition = LatLng(val.latitude, val.longitude);
              setState(() {});
            },
            markers: {
              Marker(
                markerId: MarkerId("marker"),
                position: userPosition,
                draggable: true,
              ),
            },
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition:
                CameraPosition(target: LatLng(13.331781, 74.747334), zoom: 18),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: Get.height * 0.85,
            left: Get.width * 0.35,
            child: RaisedButton(
              onPressed: () {},
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 30,
              ),
              child: Text(
                "Select",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              color: Get.theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
