import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';
import 'package:dio/dio.dart';

class Address extends StatelessWidget {
  Address({Key key}) : super(key: key);
  final LoginController c = Get.find();
  var _pinCode = "".obs;
  List<String> spinnerItems = [
    'Punjab National Bank',
    'Union Bank of India	',
    'Bank of Baroda',
    'Punjab & Sind Bank',
    'Reserve Bank of India',
    'Canara Bank',
    'Department of financial services'
  ];

  Future getPanchayat() async {
    Response response;
    Dio dio = new Dio();
    response = await dio
        .get("http://143.110.181.107:3000/api/panchayat/" + _pinCode.value);
    print(response.data.toString());
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
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (int.parse(value) > 99999) {
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
        onChanged: (String data) {},
        items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        _customTextField("Enter your postal code", "Pincode"),
        _dropDown(),
        Container(
          height: _mediaQuery.height * 0.07,
          width: double.infinity,
          margin: EdgeInsets.all(8),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              c.index(2);
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
