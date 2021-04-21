import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/message.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/message/mesage_detail_screen.dart';
import 'package:jaansay_public_user/screens/misc/search_screen.dart';
import 'package:jaansay_public_user/service/message_service.dart';
import 'package:jaansay_public_user/widgets/dashboard/dash_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class MessageSection extends StatefulWidget {
  @override
  _MessageSectionState createState() => _MessageSectionState();
}

class _MessageSectionState extends State<MessageSection> {
  bool isLoad = true;
  List<MessageMaster> _messageMasters = [];
  List<Official> officials = [];
  MessageService messageService = MessageService();

  getMessageMasters() async {
    _messageMasters.clear();
    await messageService.getMessageMasters(_messageMasters);
    _messageMasters.removeWhere((element) {
      return (element.message == null || element.officialsId == 7777777);
    });
    _messageMasters.insert(
        0,
        MessageMaster(
          message: tr("Have any feedback for us?"),
          officialsId: 7777777,
          officialsName: tr("JaanSay"),
          photo: "http://jaansay.com/media/officials/jaansay_official.png",
          officialsPhone: "9980793399",
          messageType: 0,
        ));
    _messageMasters
        .map(
          (e) => officials.add(
            Official(
              officialsName: e.officialsName,
              photo: e.photo,
              officialDisplayPhone: e.officialDisplayPhone,
            ),
          ),
        )
        .toList();
    officials.add(Official());
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessageMasters();
  }

  @override
  Widget build(BuildContext context) {
    OfficialProfileProvider officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context, listen: false);

    return DashList(
      officials: officials,
      title: "Messages",
      isLoad: isLoad,
      onTapAdd: () {
        officialProfileProvider.clearData();
        Get.to(
            () => SearchScreen(
                  description:
                      "Search officiais and businesses and message them your queries.",
                  iconData: Icons.message_outlined,
                ),
            transition: Transition.rightToLeft);
      },
      onTap: (index) {
        Get.to(
            () => MessageDetailScreen(
                  messageMaster: _messageMasters[index],
                ),
            transition: Transition.rightToLeft);
      },
    );
  }
}
