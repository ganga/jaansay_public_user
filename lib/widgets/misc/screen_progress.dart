import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/utils/login_controller.dart';

class ScreenProgress extends StatelessWidget {
  final LoginController c = Get.find();

  Widget _buildColumn(String title, Function ticks) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Obx(() => ticks()),
        Text(title),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildColumn("About", tick1),
        line(_mediaQuery),
        _buildColumn("Location", tick2),
        line(_mediaQuery),
        _buildColumn("Status", tick3),
        line(_mediaQuery),
        _buildColumn("Finish", tick4),
      ],
    );
  }

  Widget tick(bool isChecked) {
    return isChecked
        ? Icon(
            Icons.check_circle,
            color: Get.theme.primaryColor,
          )
        : Icon(
            Icons.radio_button_unchecked,
            color: Get.theme.primaryColor,
          );
  }

  Widget tick1() {
    return c.index.value > 0
        ? tick(
            true,
          )
        : tick(
            false,
          );
  }

  Widget tick2() {
    return c.index.value > 1
        ? tick(
            true,
          )
        : tick(
            false,
          );
  }

  Widget tick3() {
    return c.index.value > 2
        ? tick(
            true,
          )
        : tick(
            false,
          );
  }

  Widget tick4() {
    return c.index.value > 3
        ? tick(
            true,
          )
        : tick(
            false,
          );
  }

  Widget spacer() {
    return Container(
      width: 5.0,
    );
  }

  Widget line(Size mediaQuery) {
    return Expanded(
      child: Container(
        color: Get.theme.primaryColor,
        height: 5.0,
      ),
    );
  }
}
