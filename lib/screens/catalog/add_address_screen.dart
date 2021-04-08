import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Add Delivery Address",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ),
      ),
    );
  }
}
