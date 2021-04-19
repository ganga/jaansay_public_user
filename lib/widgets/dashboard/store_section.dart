import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/catalog_provider.dart';
import 'package:jaansay_public_user/screens/catalog/category_screen.dart';
import 'package:jaansay_public_user/service/catalog_service.dart';
import 'package:jaansay_public_user/widgets/dashboard/dash_list.dart';
import 'package:provider/provider.dart';

class StoreSection extends StatefulWidget {
  @override
  _StoreSectionState createState() => _StoreSectionState();
}

class _StoreSectionState extends State<StoreSection> {
  bool isLoad = true;
  List<Official> officials = [];
  CatalogService catalogService = CatalogService();

  getDashOfficials() async {
    await catalogService.getAllDashOfficials(officials);
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDashOfficials();
  }

  @override
  Widget build(BuildContext context) {
    final catalogProvider =
        Provider.of<CatalogProvider>(context, listen: false);

    return DashList(
      officials: officials,
      title: "Shops",
      isLoad: isLoad,
      onTap: (index) {
        catalogProvider.clearData(allData: true);
        catalogProvider.selectedOfficial = officials[index];
        Get.to(() => CategoryScreen(), transition: Transition.rightToLeft);
      },
    );
  }
}
