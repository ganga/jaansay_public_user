import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FeedPageController extends GetxController {
  var index = 0.obs;

  updateIndex(int val, PageController controller) {
    index(val);
    controller.animateToPage(index.value,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }
}
