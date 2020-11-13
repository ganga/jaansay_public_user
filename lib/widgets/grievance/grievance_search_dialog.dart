import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/utils/search_utils.dart';
import 'package:jaansay_public_user/widgets/grievance/grievance_user_tile.dart';
import 'package:easy_localization/easy_localization.dart';

class GrievanceSearchDialog extends StatelessWidget {
  final Function updateUser;

  GrievanceSearchDialog(this.updateUser);

  SearchUtils searchUtils = SearchUtils();
  var _officials = [].obs;

  searchOfficials(String val) async {
    if (val.length > 2) {
      _officials.clear();
      _officials.value = await searchUtils.searchUsers(val);
    }
  }

  _searchField(double height, double width, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.01, vertical: height * 0.02),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.05)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  autofocus: true,
                  onChanged: (val) {
                    searchOfficials(val);
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration.collapsed(
                      hintText: "${tr("Enter user name")}"),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor,
              height: double.infinity,
              width: 50,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Container(
      width: _mediaQuery.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _searchField(_mediaQuery.height, _mediaQuery.width, context),
          Obx(() => Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return GrievanceUserTile(
                        _officials[index], true, updateUser);
                  },
                  itemCount: _officials.length,
                ),
              ))
        ],
      ),
    );
  }
}
