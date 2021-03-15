import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/widgets/community/officials_list_item.dart';
import 'package:provider/provider.dart';

class OfficialsListGroup extends StatelessWidget {
  final String type;

  OfficialsListGroup(this.type);

  @override
  Widget build(BuildContext context) {
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context);

    List<Official> filteredList =
        officialProfileProvider.getOfficialsOfType(type);

    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: Get.width * 0.04, vertical: Get.height * 0.02),
      child: Container(
        width: double.infinity,
        padding:
            EdgeInsets.symmetric(vertical: 10, horizontal: Get.width * 0.03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type),
            Divider(
              thickness: 1,
              color: Colors.black54,
            ),
            Container(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredList.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                    horizontal: 5, vertical: Get.height * 0.02),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: Get.width * 0.03,
                    mainAxisSpacing: Get.height * 0.02),
                itemBuilder: (context, index) {
                  return BusinessListItem(filteredList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
