import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderConfirmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.white,
        title: Text(
          "Confirm Orders",
          style: TextStyle(
            color: Get.theme.primaryColor,
          ),
        ),
      ),
    );
  }
}
