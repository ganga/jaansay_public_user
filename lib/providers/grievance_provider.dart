import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/grievance.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/grievance_service.dart';

class GrievanceProvider extends ChangeNotifier {
  GrievanceService grievanceService = GrievanceService();

  List<GrievanceMaster> grievanceMasters = [];
  List<Official> dashOfficials = [];
  List<File> files = [];

  Official selectedOfficial;

  bool isDashLoad = true, isMasterLoad = true;
  bool initDash = false, initMaster = false;

  TextEditingController controller = TextEditingController();

  getAllDashMasters() async {
    await grievanceService.getAllDashGrievances(dashOfficials);
    dashOfficials.add(Official());
    isDashLoad = false;
    notifyListeners();
  }

  getAllGrievanceMasters() async {
    await grievanceService.getAlLGrievancesByOfficialId(
        grievanceMasters, selectedOfficial.officialsId.toString());
    isMasterLoad = false;
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
      Get.rawSnackbar(
          message:
              "Your grievance has been sent. We will notify you when there are any updates.");
      controller.clear();
      files.clear();
      grievanceMasters.clear();
      initMaster = false;
      notifyListeners();
    }
  }

  notify() {
    notifyListeners();
  }
}
