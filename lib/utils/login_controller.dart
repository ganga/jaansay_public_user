import 'dart:io';

import 'package:get/get.dart';

class LoginController extends GetxController {
  var index = 0.obs;
  File photo;
  String name;
  String password;

  updateProgress(int val) {
    index(val);
  }
}
