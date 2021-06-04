// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:jaansay_public_user/widgets/general/custom_button.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:jaansay_public_user/models/catalog.dart';
import 'package:jaansay_public_user/providers/catalog_provider.dart';
import 'package:jaansay_public_user/widgets/misc/location_picker.dart';
import 'package:easy_localization/easy_localization.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  String latitude = "0", longitude = "0";

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
              Get.to(LocationPicker(), arguments: updateLocation);
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
                        ? (label)
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

  textWidget(TextEditingController controller, String label, bool isNumber) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: tr(label)),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }

  stateDropdown() {
    return Container(
      child: DropdownButtonFormField<String>(
        value: "Karnataka",
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'State',
        ),
        items: ["Karnataka"].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (val) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogProvider =
        Provider.of<CatalogProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Add Delivery Address",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ).tr(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    textWidget(nameController, "Name", false),
                    textWidget(addressController, "Address", false),
                    textWidget(cityController, "City", false),
                    stateDropdown(),
                    textWidget(pincodeController, "Pin Code", true),
                    SizedBox(
                      height: 16,
                    ),
                    attachments("Add Location", Icons.location_pin, 1),
                  ],
                ),
              ),
            ),
          ),
          BottomButton(
            onTap: () {
              String name = nameController.text;
              String address = addressController.text;
              String city = cityController.text;
              String pincode = pincodeController.text;
              if (name.length > 0 &&
                  address.length > 0 &&
                  city.length > 0 &&
                  pincode.length > 0 &&
                  latitude != "0" &&
                  longitude != "0") {
                Get.close(1);
                catalogProvider.addUserAddress(
                  UserAddress(
                      name: name,
                      address: address,
                      city: city,
                      pincode: pincode,
                      state: "Karnataka",
                      latitude: double.parse(latitude),
                      longitude: double.parse(longitude)),
                );
              } else {
                Get.rawSnackbar(message: "Please enter all the details");
              }
            },
            text: "Add Address",
          )
        ],
      ),
    );
  }
}
