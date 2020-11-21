import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/panchayat.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';
import 'package:dio/dio.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jaansay_public_user/widgets/login_signup/custom_auth_button.dart';

class Address extends StatefulWidget {
  Address({Key key}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final LoginController c = Get.find();

  var _pinCode = "".obs;

  String panchayat = "";

  int check = 0;

  List<String> spinnerItems = [];
  List<Panchayat> panchayatList = [];

  TextEditingController pincodeController = TextEditingController();

  Future getPanchayat() async {
    Response response;
    Dio dio = new Dio();
    try {
      check = 1;
      setState(() {});
      response = await dio
          .get("http://jaansay.com:3000/api/panchayat/" + _pinCode.value);
      if (response.data["success"]) {
        response.data["data"].map((val) {
          panchayatList.add(Panchayat(
            panchayatId: val["panchayat_id"].toString(),
            panchayatName: val["panchayat_name"],
          ));
          spinnerItems.add(val["panchayat_name"]);
        }).toList();
      } else {
        Get.rawSnackbar(
            title: "${tr("Error")}",
            message:
                "${tr("Oops! Service currently unavailable in this pin-code")}",
            backgroundColor: Get.theme.primaryColor);
      }
      check = 0;
      setState(() {});
    } catch (e) {
      check = 0;
      setState(() {});
      Get.rawSnackbar(
          message: "${tr("Oops! Something went wrong")}",
          backgroundColor: Get.theme.primaryColor);
    }
  }

  Widget _customTextField(String hint, String label) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: TextField(
        controller: pincodeController,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (value.length == 6) {
            print(value.length);
            _pinCode(value.toString());
            getPanchayat();
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: tr(label),
          hintText: tr(hint),
        ),
      ),
    );
  }

  Widget _dropDown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: DropdownButtonFormField(
        key: ValueKey('organization'),
        icon: Icon(Icons.arrow_drop_down),
        decoration: InputDecoration(
          hintText: '${tr("Select the Panchayat")}',
          labelText: '${tr("Panchayat")}',
          border: InputBorder.none,
        ),
        validator: (String data) {
          if (data.isEmpty) return tr("Please select your panchayat");
          return null;
        },
        onChanged: (String data) {
          Get.focusScope.unfocus();
          panchayat = data;
        },
        items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  sendData() {
    if (_pinCode.value == "" || panchayat == "") {
      Get.rawSnackbar(
        message: "Please fill the fields",
      );
    } else {
      GetStorage box = GetStorage();
      print(panchayat);
      print(spinnerItems.length);
      var index = spinnerItems.indexOf(panchayat);
      panchayat = panchayatList[index].panchayatId;
      box.write("register_pincode", _pinCode.value);
      box.write("register_panchayat", panchayat.toString());
      c.index(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _customTextField("Enter your postal code", "Pincode"),
        check == 1 ? Loading() : _dropDown(),
        CustomAuthButton(
          title: "Continue",
          onTap: () {
            Get.focusScope.unfocus();

            sendData();
          },
        )
      ],
    );
  }
}
