import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/models/message.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/widgets/misc/custom_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class MessageMediaScreen extends StatefulWidget {
  @override
  _MessageMediaScreenState createState() => _MessageMediaScreenState();
}

class _MessageMediaScreenState extends State<MessageMediaScreen> {
  MessageMaster messageMaster;
  ChewieController chewieController;
  Message message;
  Official official;
  bool isCheck = false;

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

  VideoPlayerController _controller;

  @override
  void dispose() {
    // TODO: implement dispose
    if (_controller != null) {
      chewieController.dispose();
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List response = ModalRoute.of(context).settings.arguments;

    message = response[0];
    messageMaster = response[1];
    official = response[2];

    if (!isCheck) {
      isCheck = true;
      if (message.messageType == 2) {
        _controller = VideoPlayerController.network(
          message.message,
        )..initialize().then((_) {
            _controller.play();
            chewieController = ChewieController(
              videoPlayerController: _controller,
              autoPlay: true,
              looping: true,
            );
            setState(() {});
          });
      }
    }

    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.black,
      body: message.messageType == 1
          ? Hero(
              tag: message.messageId.toString(),
              child: PhotoView(
                imageProvider: NetworkImage(
                  message.message,
                ),
              ),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: _controller.value.initialized
                  ? Stack(
                      children: [
                        AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Chewie(controller: chewieController)),
                      ],
                    )
                  : CircularProgressIndicator(),
            ),
    );
  }
}
