import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/grievance/grievance_user_tile.dart';

class GrievanceSearchDialog extends StatefulWidget {
  final Function updateUser;

  GrievanceSearchDialog(this.updateUser);

  @override
  _GrievanceSearchDialogState createState() => _GrievanceSearchDialogState();
}

class _GrievanceSearchDialogState extends State<GrievanceSearchDialog> {
  OfficialService officialService = OfficialService();

  List<Official> _officials = [];

  searchOfficials(String val) async {
    if (val.length > 2) {
      _officials.clear();
      await officialService.searchOfficials(val, _officials);
      _officials.removeWhere(
          (element) => (element.isPrivate == 1 && element.isFollow != 1));
      setState(() {});
    }
  }

  _searchField(double height, double width, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.02),
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
      width: _mediaQuery.width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _searchField(_mediaQuery.height, _mediaQuery.width, context),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return GrievanceUserTile(
                    _officials[index], true, widget.updateUser);
              },
              itemCount: _officials.length,
            ),
          )
        ],
      ),
    );
  }
}
