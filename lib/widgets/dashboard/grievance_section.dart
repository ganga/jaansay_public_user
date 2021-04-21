import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/grievance_provider.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/grievance/grievance_list_screen.dart';
import 'package:jaansay_public_user/screens/misc/search_screen.dart';
import 'package:jaansay_public_user/widgets/dashboard/dash_list.dart';
import 'package:provider/provider.dart';

class GrievanceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OfficialProfileProvider officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context, listen: false);
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
      onTapAdd: () {
        officialProfileProvider.clearData();
        Get.to(
            () => SearchScreen(
                  description:
                      "Search officiais and businesses and send them your queries. You might have to upload documents for some officials for user verification.",
                  iconData: Icons.message_outlined,
                ),
            transition: Transition.rightToLeft);
      },
      onTap: (index) {
        grievanceProvider.clearData(allData: true);
        grievanceProvider.selectedOfficial = officials[index];
        Get.to(() => GrievanceListScreen(), transition: Transition.rightToLeft);
      },
    );
  }
}
