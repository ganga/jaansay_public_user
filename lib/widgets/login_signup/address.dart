import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/panchayat.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';
import 'package:dio/dio.dart';
import 'package:jaansay_public_user/widgets/loading.dart';

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
            title: "Error",
            message: "Oops!! Pincode is incorrect",
            backgroundColor: Get.theme.primaryColor);
      }
      check = 0;
      setState(() {});
      print(response.data.toString());
    } catch (e) {
      check = 0;
      setState(() {});
      Get.rawSnackbar(
          title: "Error",
          message: "Oops!! Something went wrong",
          backgroundColor: Get.theme.primaryColor);
    }
  }

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
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }

  Widget _dropDown() {
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
      child: DropdownButtonFormField(
        key: ValueKey('organization'),
        icon: Icon(Icons.arrow_drop_down),
        decoration: InputDecoration(
          hintText: 'Select the Panchayat',
          labelText: 'Panchayat',
          border: InputBorder.none,
        ),
        validator: (String data) {
          if (data.isEmpty) return 'Please select one panchayat';
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
          title: "Note",
          message: "Please fill the fields",
          backgroundColor: Get.theme.primaryColor);
    } else {
      GetStorage box = GetStorage();
      var index = spinnerItems.indexOf(panchayat);
      panchayat = panchayatList[index].panchayatId;
      box.write("register_pincode", _pinCode.value);
      box.write("register_panchayat", panchayat.toString());
      c.index(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        _customTextField("Enter your postal code", "Pincode"),
        check == 1 ? Loading() : _dropDown(),
        Container(
          height: _mediaQuery.height * 0.07,
          width: double.infinity,
          margin: EdgeInsets.all(8),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Get.focusScope.unfocus();

              sendData();
            },
            child: Text(
              "Continue",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
