import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/grievance.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/misc/done_screen.dart';
import 'package:jaansay_public_user/service/grievance_service.dart';

class GrievanceProvider extends ChangeNotifier {
  GrievanceService grievanceService = GrievanceService();

  List<GrievanceMaster> grievanceMasters = [];
  List<GrievanceReply> grievanceReplies = [];
  List<Official> dashOfficials = [];
  List<File> files = [];

  Official selectedOfficial;
  GrievanceMaster selectedGrievanceMaster;

  bool isDashLoad = true, isMasterLoad = true, isReplyLoad = true;
  bool initDash = false, initMaster = false, initReply = false;

  TextEditingController controller = TextEditingController();

  getAllDashMasters() async {
    dashOfficials.clear();
    await grievanceService.getAllDashGrievances(dashOfficials);
    dashOfficials.add(Official());
    isDashLoad = false;
    notifyListeners();
  }

  getAllGrievanceMasters() async {
    grievanceMasters.clear();
    await grievanceService.getAlLGrievancesByOfficialId(
        grievanceMasters, selectedOfficial.officialsId.toString());
    isMasterLoad = false;
    notifyListeners();
  }

  getAllGrievanceReplies() async {
    grievanceReplies.clear();
    await grievanceService.getAlLGrievancesByMasterId(
        grievanceReplies, selectedGrievanceMaster.id.toString());
    isReplyLoad = false;
    notifyListeners();
  }

  addGrievanceMaster() async {
    String message = controller.text.trim();
    if (message.length == 0) {
      Get.rawSnackbar(message: "Please enter your grievance");
    } else {
      Get.close(1);
      isMasterLoad = true;
      notifyListeners();
      await grievanceService.addGrievanceMaster(
          files, message, selectedOfficial.officialsId.toString());
      Get.to(
          DoneScreen(
            onTap: () => Get.close(1),
            title: "Grievance Submitted",
            subTitle:
                "Your grievance has been sent. You will get a response shortly.",
          ),
          transition: Transition.rightToLeft);
      clearData(allData: true);
      initDash = false;
      isDashLoad = true;
      dashOfficials.clear();
      notifyListeners();
    }
  }

  addComment() async {
    String message = controller.text.trim();
    if (message.length == 0) {
      Get.rawSnackbar(message: "Please enter your comment");
    } else {
      Get.close(1);
      isReplyLoad = true;
      controller.clear();
      files.clear();
      notifyListeners();
      await grievanceService.addReply(
          files, message, selectedGrievanceMaster.id.toString());
      Get.rawSnackbar(message: "Your comment has been added.");
      getAllGrievanceReplies();
      notifyListeners();
    }
  }

  notify() {
    notifyListeners();
  }

  clearData({
    allData = false,
  }) {
    controller.clear();

    grievanceReplies.clear();
    files.clear();

    selectedGrievanceMaster = null;

    isReplyLoad = true;
    initReply = false;

    if (allData) {
      grievanceMasters.clear();
      isMasterLoad = true;
      initMaster = false;
    }
  }
}
