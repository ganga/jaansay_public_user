// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/profile_full_screen.dart';
import 'package:jaansay_public_user/service/follow_service.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class SearchScreen extends StatefulWidget {
  final String title;
  final String description;
  final IconData iconData;

  SearchScreen({this.title, this.description, this.iconData});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  OfficialService officialService = OfficialService();
  FollowService followService = FollowService();
  List<Official> officials = [];
  bool isSearching = false;
  bool isLoad = false;

  searchOfficial(String val) async {
    if (val.length > 2 && !isSearching) {
      isSearching = true;
      isLoad = true;
      officials.clear();
      await officialService.searchOfficials(val, officials);
      officials.removeWhere(
          (element) => (element.isPrivate == 1 && element.isFollow != 1));
      isLoad = false;
      isSearching = false;

      setState(() {});
    } else if (!isSearching) {
      officials.clear();
      setState(() {});
    }
  }

  followOfficial(Official official) async {
    officials.map((e) {
      if (e.officialsId == official.officialsId) {
        e.isFollow = 1;
      }
    }).toList();
    setState(() {});
    await followService.followUser(official.officialsId);
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
          decoration: InputDecoration.collapsed(hintText: tr("Enter name")),
          controller: searchController,
          onChanged: (val) {
            searchOfficial(val);
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
      body: officials.length == 0
          ? CustomErrorWidget(
              iconData: searchController.text.length > 2
                  ? MdiIcons.textSearch
                  : widget.iconData,
              title: searchController.text.length > 2
                  ? "No officials found"
                  : widget.title,
              description:
                  searchController.text.length > 2 ? null : widget.description,
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return _OfficialTile(officials[index], followOfficial);
              },
              itemCount: officials.length,
            ),
    );
  }
}

class _OfficialTile extends StatelessWidget {
  final Official official;
  final Function followFunction;

  _OfficialTile(this.official, this.followFunction);

  @override
  Widget build(BuildContext context) {
    OfficialProfileProvider officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context);

    return Material(
      color: Colors.white.withOpacity(0.8),
      child: InkWell(
        onTap: () {
          officialProfileProvider.clearData();

          Get.close(1);
          Get.to(
              () => ProfileFullScreen(
                    official.officialsId,
                  ),
              transition: Transition.rightToLeft);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(child: CustomNetWorkImage(official.photo)),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${official.officialsName}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "#${official.businesstypeName}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 8,
              ),
              if (official.isPrivate == 0)
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: official.isFollow == 0
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                          width: 0.5),
                      color: official.isFollow == 0
                          ? Theme.of(context).primaryColor
                          : Colors.black.withOpacity(0.01)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        if (official.isFollow == 0) {
                          followFunction(official);
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              official.isFollow == 0
                                  ? "${tr("Follow")}"
                                  : "${tr("Following")}",
                              style: TextStyle(
                                  color: official.isFollow == 0
                                      ? Colors.white
                                      : Colors.black),
                            ).tr(),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
