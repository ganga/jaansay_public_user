import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/utils/search_utils.dart';
import 'package:jaansay_public_user/widgets/misc/official_tile.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchScreen extends StatelessWidget {
  SearchUtils searchUtils = SearchUtils();
  var _officials = [].obs;

  searchOfficials(String val) async {
    if (val.length > 2) {
      _officials.clear();
      _officials.value = await searchUtils.searchUsers(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          title: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: tr("Enter name")),
            onChanged: (val) {
              searchOfficials(val);
            },
          ),
          actions: [
            InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {},
              child: Hero(
                tag: "search_icon",
                child: Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  child: Icon(
                    Icons.search,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Obx(
          () => ListView.builder(
            itemBuilder: (context, index) {
              return OfficialTile(_officials[index]);
            },
            itemCount: _officials.length,
          ),
        ));
  }
}
