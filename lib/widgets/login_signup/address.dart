import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';

class Address extends StatelessWidget {
  Address({Key key}) : super(key: key);
  final LoginController c = Get.find();
  List<String> spinnerItems = [
    'Punjab National Bank',
    'Union Bank of India	',
    'Bank of Baroda',
    'Punjab & Sind Bank',
    'Reserve Bank of India',
    'Canara Bank',
    'Department of financial services'
  ];
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
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        _customTextField("Enter your postal code", "Pincode"),
        DropdownButtonFormField(
          key: ValueKey('organization'),
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            hintText: 'Select the Panchayat',
            labelText: 'Panchayat',
            icon: Icon(Icons.ac_unit),
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
