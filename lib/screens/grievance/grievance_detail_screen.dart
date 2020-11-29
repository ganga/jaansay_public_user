import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:jaansay_public_user/models/grievance.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/service/grievance_service.dart';
import 'package:jaansay_public_user/widgets/misc/custom_loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class GrievanceDetailScreen extends StatefulWidget {
  @override
  _GrievanceDetailScreenState createState() => _GrievanceDetailScreenState();
}

class _GrievanceDetailScreenState extends State<GrievanceDetailScreen> {
  GrievanceMaster grievanceMaster;
  List<Grievance> grievances = [];
  Official official;
  bool isCheck = false;
  bool isLoad = true;
  TextEditingController _messageController = TextEditingController();
  GrievanceService grievanceService = GrievanceService();
  ScrollController _scrollController = ScrollController();

  getAllGrievances() async {
    grievanceMaster != null
        ? await grievanceService.getAllGrievances(
            grievances, grievanceMaster.gmmId.toString())
        : await grievanceService.getAllGrievancesUsingOfficialId(
            grievances, official.officialsId.toString());
    grievances = grievances.reversed.toList();
    isLoad = false;
    setState(() {});
  }

  sendGrievance() async {
    if (_messageController.text != null &&
        _messageController.text.trim().length > 0) {
      String message = _messageController.text.trim();
      GetStorage box = GetStorage();
      final userId = box.read("user_id");
      grievances.insert(
        0,
        Grievance(
            message: message,
            messageId: 0,
            gmmId: grievanceMaster == null ? 0 : grievanceMaster.gmmId,
            updatedAt: DateTime.now(),
            userId: userId),
      );
      _messageController.clear();
      setState(() {});
      grievanceMaster == null
          ? await grievanceService.sendMessageUsingOfficialId(
              message, official.officialsId.toString())
          : await grievanceService.sendMessage(message, grievanceMaster);
    }
  }

  appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      backgroundColor: Colors.white,
      titleSpacing: 0,
      leadingWidth: 50,
      title: Row(
        children: [
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
                child: CustomNetWorkImage(grievanceMaster == null
                    ? official.photo
                    : grievanceMaster.photo)),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "${grievanceMaster == null ? official.officialsName : grievanceMaster.officialsName}",
            style: TextStyle(
              color: Get.theme.primaryColor,
            ),
          ),
        ],
      ),
      actions: [
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () async {
            final url =
                "tel:${grievanceMaster == null ? official.officialsPhone : grievanceMaster.officialsPhone}";
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Icon(
              Icons.call,
              size: 28,
              color: Get.theme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List response = ModalRoute.of(context).settings.arguments;

    if (response[0]) {
      grievanceMaster = response[1];
    } else {
      official = response[1];
    }
    if (!isCheck) {
      isCheck = true;
      getAllGrievances();
    }

    return Scaffold(
      backgroundColor: Colors.deepOrange.withOpacity(0.05),
      appBar: appBar(),
      body: isLoad
          ? CustomLoading("Please wait")
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemCount: grievances.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (index == grievances.length - 1 ||
                              grievances[index]
                                      .updatedAt
                                      .difference(
                                          grievances[index + 1].updatedAt)
                                      .inDays >
                                  0)
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xffD6EAF8),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "${DateFormat('d MMMM y').format(grievances[index].updatedAt).toUpperCase()}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                            ),
                          _MessageBubble(grievances[index]),
                        ],
                      );
                    },
                  ),
                ),
                _MessageField(_messageController, () => sendGrievance())
              ],
            ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Grievance grievance;

  _MessageBubble(this.grievance);

  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    bool isUser = grievance.userId == box.read("user_id");

    return Bubble(
      alignment: isUser ? Alignment.topRight : Alignment.topLeft,
      color: Colors.white,
      nip: isUser ? BubbleNip.rightBottom : BubbleNip.leftBottom,
      elevation: 2,
      margin: BubbleEdges.only(top: 10, left: 10, bottom: 5),
      child: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
            minWidth: MediaQuery.of(context).size.width * 0.2),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 5, right: 40, top: 5, left: 5),
              child: Text(
                grievance.message,
                style: TextStyle(color: Colors.black, fontSize: 16),
                textAlign: TextAlign.start,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Text(
                DateFormat('HH:mm').format(grievance.updatedAt),
                style: TextStyle(fontSize: 11, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MessageField extends StatelessWidget {
  final TextEditingController _messageController;
  final Function sendGrievance;

  _MessageField(this._messageController, this.sendGrievance);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(60)),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration.collapsed(
                  hintText: "Enter a message",
                ),
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 4,
                maxLength: 500,
                buildCounter: (BuildContext context,
                        {int currentLength, int maxLength, bool isFocused}) =>
                    null,
              ),
            ),
          ),
          Container(
              height: 45,
              width: 45,
              margin: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Material(
                  color: Theme.of(context).primaryColor,
                  child: InkWell(
                    onTap: () {
                      sendGrievance();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 7, top: 10, bottom: 10),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
