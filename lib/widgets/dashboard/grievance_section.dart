import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/grievance_provider.dart';
import 'package:jaansay_public_user/screens/grievance/grievance_add_screen.dart';
import 'package:jaansay_public_user/screens/grievance/grievance_list_screen.dart';
import 'package:jaansay_public_user/widgets/dashboard/dash_list.dart';
import 'package:provider/provider.dart';

class GrievanceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final grievanceProvider = Provider.of<GrievanceProvider>(context);

    List<Official> officials = grievanceProvider.dashOfficials;
    if (!grievanceProvider.initDash) {
      grievanceProvider.initDash = true;
      grievanceProvider.getAllDashMasters();
    }

    return DashList(
      officials: officials,
      title: "Grievances",
      isLoad: grievanceProvider.isDashLoad,
      onTapAdd: () {},
      onTap: (index) {
        grievanceProvider.selectedOfficial = officials[index];
        Get.to(() => GrievanceListScreen(), transition: Transition.rightToLeft);
      },
    );
  }
}
