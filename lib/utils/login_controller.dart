import 'package:get/get.dart';

class LoginController extends GetxController {
  var index = 0.obs;
  updateProgress(int val) {
    index(val);
  }
}
