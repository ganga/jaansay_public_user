import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/message.dart';
import 'package:jaansay_public_user/screens/message/mesage_detail_screen.dart';
import 'package:jaansay_public_user/service/message_service.dart';
import 'package:jaansay_public_user/widgets/loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_divider.dart';
import 'package:jaansay_public_user/widgets/misc/custom_error_widget.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserMessageScreen extends StatefulWidget {
  @override
  _UserMessageScreenState createState() => _UserMessageScreenState();
}

class _UserMessageScreenState extends State<UserMessageScreen> {
  bool isLoad = true;
  List<MessageMaster> _messageMasters = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  getMessageMasters() async {
    _messageMasters.clear();
    MessageService messageService = MessageService();
    await messageService.getMessageMasters(_messageMasters);
    _messageMasters.removeWhere((element) {
      return element.message == null;
    });
    _refreshController.refreshCompleted();
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: isLoad
            ? Loading()
            : _messageMasters.length == 0
                ? CustomErrorWidget(
                    iconData: MdiIcons.messageAlertOutline,
                    title: "No messages found",
                  )
                : SmartRefresher(
                    enablePullDown: true,
                    header: ClassicHeader(),
                    onRefresh: () => getMessageMasters(),
                    controller: _refreshController,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      itemCount: _messageMasters.length,
                      itemBuilder: (context, index) {
                        return _MessageTile(_messageMasters[index]);
                      },
                    ),
                  ),
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  final MessageMaster messageMaster;

  _MessageTile(this.messageMaster);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            Get.to(MessageDetailScreen(),
                arguments: [true, messageMaster],
                transition: Transition.rightToLeft);
          },
          child: Container(
            padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: Get.width * 0.05,
                right: Get.width * 0.05),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: CustomNetWorkImage(messageMaster.photo),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${messageMaster.officialsName}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      Text(
                        "+91 ${messageMaster.officialsPhone}",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 13),
                      ),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                "${messageMaster.message ?? ''}",
                                style: TextStyle(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: CustomDivider()),
      ],
    );
  }
}
