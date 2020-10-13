import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/misc/custom_divider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int curIndex = 0;

  profileTile(double height, width) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.05, horizontal: width * 0.08),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Image.network(
                "https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cg_face%2Cq_auto:good%2Cw_300/MTE1ODA0OTcxOTg4MDU5NjYx/raavan---uk-film-premiere-red-carpet-arrivals.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Amitabh Bachchan",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            "+91 8310854573",
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 13),
          ),
        ],
      ),
    );
  }

  drawerItem(
    String title,
    IconData iconData,
    Function onTap,
    int index,
  ) {
    return ListTile(
      tileColor: curIndex == index
          ? Theme.of(context).primaryColor.withOpacity(0.05)
          : Colors.transparent,
      title: Text(
        "$title",
        style: TextStyle(
            color: curIndex == index
                ? Theme.of(context).primaryColor
                : Colors.grey),
      ),
      leading: Icon(
        iconData,
        color: curIndex == index ? Theme.of(context).primaryColor : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Column(
      children: [
        profileTile(_mediaQuery.height, _mediaQuery.width),
        CustomDivider(),
        drawerItem("Home", MdiIcons.home, () {}, 0),
        drawerItem("Feedback", Icons.feedback, () {}, 1),
        drawerItem("Vocal for Local", Icons.record_voice_over, () {}, 2),
        drawerItem("Share", MdiIcons.share, () {}, 3),
        drawerItem("About", MdiIcons.information, () {}, 4),
      ],
    );
  }
}
