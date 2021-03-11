import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/widgets/misc/official_tile.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context);

    if (!isCheck) {
      isCheck = true;
      officialProfileProvider.clearOfficials();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: TextField(
          autofocus: true,
          decoration: InputDecoration.collapsed(hintText: tr("Enter name")),
          onChanged: (val) {
            //searchOfficials(val);
            officialProfileProvider.searchOfficial(val);
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
      body: ListView.builder(
        itemBuilder: (context, index) {
          return OfficialTile(officialProfileProvider.officials[index]);
        },
        itemCount: officialProfileProvider.officials.length,
      ),
    );
  }
}
