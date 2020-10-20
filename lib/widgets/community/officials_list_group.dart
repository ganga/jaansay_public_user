import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/community/officials_list_item.dart';

class OfficialsListGroup extends StatelessWidget {
  final String type;
  final List<Official> officials;

  OfficialsListGroup(this.type, this.officials);

  OfficialService officialService = OfficialService();

  List<Official> filteredList = [];

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    filteredList = officialService.getOfficialOfType(type, officials);

    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: _mediaQuery.width * 0.04,
          vertical: _mediaQuery.height * 0.02),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            vertical: 10, horizontal: _mediaQuery.width * 0.03),
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
                    horizontal: 5, vertical: _mediaQuery.height * 0.02),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: _mediaQuery.width * 0.03,
                    mainAxisSpacing: _mediaQuery.height * 0.02),
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
