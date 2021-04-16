import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';

class LocationPicker extends StatefulWidget {
  LocationPicker({Key key}) : super(key: key);

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng userPosition = LatLng(13.352972, 74.864027);
  var isCheck = false;
  bool isLoad = true;
  Function updateLocation;

  setLocation() async {
    final position = await Geolocator.getCurrentPosition();
    userPosition = LatLng(position.latitude, position.longitude);
    isLoad = false;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isCheck) {
      isCheck = true;
      updateLocation = ModalRoute.of(context).settings.arguments;
      setLocation();
    }

    return Scaffold(
      body: isLoad
          ? CustomLoading()
          : Stack(
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
                      CameraPosition(target: userPosition, zoom: 18),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        updateLocation(userPosition.latitude.toString(),
                            userPosition.longitude.toString());
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Select Location",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ).tr(),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
