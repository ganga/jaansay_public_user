import 'dart:async';
import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/message.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/screens/message/message_media_screen.dart';
import 'package:jaansay_public_user/screens/survey/survey_screen.dart';
import 'package:jaansay_public_user/service/message_service.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/misc/custom_loading.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class MessageDetailScreen extends StatefulWidget {
  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  MessageMaster messageMaster;
  List<Message> messages = [];
  Official official;
  bool isCheck = false;
  bool isLoad = true;
  TextEditingController _messageController = TextEditingController();
  MessageService messageService = MessageService();
  ScrollController _scrollController = ScrollController();
  OfficialService officialService = OfficialService();
  List<OfficialDocument> officialDocuments = [];
  bool sendingMessage = false;
  bool isSend = true;
  Timer messageTimer;

  getAllMessages() async {
    await messageService.getAllMessagesUsingOfficialId(
        messages,
        messageMaster?.officialsId?.toString() ??
            official.officialsId.toString());
    officialDocuments.clear();
    await officialService.getOfficialDocuments(
        officialDocuments,
        official?.officialsId?.toString() ??
            messageMaster.officialsId.toString());
    officialDocuments.map((e) {
      if (e.isVerified != 1) {
        isSend = false;
      }
    }).toList();
    messages = messages.reversed.toList();
    isLoad = false;
    setState(() {});
  }

  checkNewMessages() async {
    if (!sendingMessage) {
      List<Message> tempMessages = [];
      await messageService.getAllMessagesUsingOfficialId(
          tempMessages,
          messageMaster?.officialsId?.toString() ??
              official.officialsId.toString());
      tempMessages = tempMessages.reversed.toList();
      if (tempMessages.first.messageId != messages.first.messageId) {
        messages.clear();
        messages = [...tempMessages];
        setState(() {});
      }
    }
  }

  sendMessage() async {
    if (_messageController.text != null &&
        _messageController.text.trim().length > 0) {
      sendingMessage = true;
      String message = _messageController.text.trim();
      GetStorage box = GetStorage();
      final userId = box.read("user_id");
      messages.insert(
        0,
        Message(
          message: message,
          messageId: 0,
          mmId: messageMaster == null ? 0 : messageMaster.mmId,
          surveyId: null,
          updatedAt: DateTime.now(),
          userId: userId,
          type: 0,
          messageType: 0,
        ),
      );
      _messageController.clear();
      setState(() {});
      messageMaster != null
          ? await messageService.sendMessage(
              message, messageMaster.officialsId.toString())
          : await messageService.sendMessage(
              message, official.officialsId.toString());
      sendingMessage = false;
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
                child: CustomNetWorkImage(messageMaster == null
                    ? official.photo
                    : messageMaster.photo)),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "${messageMaster == null ? official.officialsName : messageMaster.officialsName}",
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
                "tel:${messageMaster == null ? official.officialsPhone : messageMaster.officialsPhone}";
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw '${tr("Could not launch")} $url';
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
  void dispose() {
    messageTimer.cancel();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List response = ModalRoute.of(context).settings.arguments;

    if (response[0]) {
      messageMaster = response[1];
    } else {
      official = response[1];
    }

    if (!isCheck) {
      isCheck = true;
      getAllMessages();
      messageTimer = Timer.periodic(Duration(seconds: 3), (timer) {
        checkNewMessages();
      });
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
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (index == messages.length - 1 ||
                              messages[index].updatedAt.day !=
                                  messages[index + 1].updatedAt.day)
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xffD6EAF8),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "${DateFormat('d MMMM y').format(messages[index].updatedAt).toUpperCase()}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                            ),
                          _MessageBubble(
                              messages[index], messageMaster, official),
                          if (messages[index].type == 4)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 16),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  onPressed: () {
                                    Get.to(SurveyScreen(), arguments: [
                                      messages[index].messageId,
                                      messages[index].surveyId
                                    ]);
                                  },
                                  child: Text(
                                    "Start Survey",
                                    style: TextStyle(color: Colors.white),
                                  ).tr(),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                        ],
                      );
                    },
                  ),
                ),
                isSend
                    ? _MessageField(_messageController, () => sendMessage())
                    : Container(
                        color: Colors.black.withAlpha(25),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Text(
                                "Please add the requested documents to send messages to this official.")
                            .tr(),
                      )
              ],
            ),
    );
  }
}

class _MessageBubble extends StatefulWidget {
  final Message message;
  final MessageMaster messageMaster;
  final Official official;

  _MessageBubble(this.message, this.messageMaster, this.official);

  @override
  __MessageBubbleState createState() => __MessageBubbleState();
}

class __MessageBubbleState extends State<_MessageBubble> {
  final GetStorage box = GetStorage();

  VideoPlayerController _controller;
  bool isUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.message.messageType == 2) {
      _controller = VideoPlayerController.network(
        widget.message.message,
      )..initialize().then((_) {
          _controller.pause();
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isUser = widget.message.userId == box.read("user_id");

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (widget.message.messageType != 0) {
          Get.to(MessageMediaScreen(), arguments: [
            widget.message,
            widget.messageMaster,
            widget.official
          ]);
        }
      },
      child: Bubble(
        alignment: isUser ? Alignment.topRight : Alignment.topLeft,
        color: widget.message.type == 4
            ? Theme.of(context).primaryColor
            : Colors.white,
        nip: isUser ? BubbleNip.rightBottom : BubbleNip.leftBottom,
        elevation: 2,
        margin: BubbleEdges.only(
            top: 10, left: 10, bottom: widget.message.type == 4 ? 0 : 5),
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
              minWidth: MediaQuery.of(context).size.width * 0.2),
          child: Stack(
            children: [
              widget.message.messageType == 0
                  ? Padding(
                      padding: EdgeInsets.only(
                          bottom: 5, right: 40, top: 5, left: 5),
                      child: Text(
                        widget.message.message,
                        style: TextStyle(
                            color: widget.message.type == 4
                                ? Colors.white
                                : Colors.black,
                            fontSize: 16),
                        textAlign: TextAlign.start,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                          bottom: 18, right: 0, top: 0, left: 0),
                      child: widget.message.messageType == 1
                          ? Hero(
                              tag: widget.message.messageId.toString(),
                              child: Image.network(
                                widget.message.message,
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 200,
                              alignment: Alignment.center,
                              child: _controller?.value?.initialized ?? false
                                  ? Stack(
                                      children: [
                                        VideoPlayer(_controller),
                                        BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2, sigmaY: 2),
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 60,
                                            )),
                                      ],
                                    )
                                  : CircularProgressIndicator(),
                            ),
                    ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Text(
                  DateFormat('HH:mm').format(widget.message.updatedAt),
                  style: TextStyle(
                      fontSize: 11,
                      color: widget.message.type == 4
                          ? Colors.white
                          : Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageField extends StatelessWidget {
  final TextEditingController _messageController;
  final Function sendMessage;

  _MessageField(this._messageController, this.sendMessage);

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
                      sendMessage();
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
