import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonUtil {
  static Widget widgetBuilderWithDropDown( {BuildContext context,
      AsyncSnapshot<Widget> snapshot,
    String dropdownValue,
    var onDropdownValueChange,
    var buildList
  }) {
    if(!snapshot.hasData) { // not loaded
      return  CircularProgressIndicator( color: Get.theme.primaryColor,);
    } else if (snapshot.hasError) {
      return const Text("Error");
    } else {
      return Column(children: [
        Column(children: [
          DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward, color: Get.theme.primaryColor),
            elevation: 16,
            style: TextStyle(color: Get.theme.primaryColor),
            underline: Container(
              height: 2,
              color: Get.theme.primaryColor,
            ),
            onChanged: onDropdownValueChange,
            items: buildList(),
          )
        ]),
        snapshot.data,
      ]);
    }
  }
}