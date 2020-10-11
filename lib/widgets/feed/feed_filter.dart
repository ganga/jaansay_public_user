import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaansay_public_user/utils/feed_page_controller.dart';

class FeedFilter extends StatefulWidget {
  FeedFilter({
    Key key,
    @required this.controller,
  }) : super(
          key: key,
        );
  final PageController controller;

  @override
  _FeedFilterState createState() => _FeedFilterState();
}

class _FeedFilterState extends State<FeedFilter> {
  final FeedPageController _feedPageController = Get.find();
  List<String> titleList = [
    "All",
    "Public",
    "Bussiness",
    "Entities",
    "Associations"
  ];
  Widget getBottomCircle(int index) {
    return Obx(() => InkWell(
          onTap: () {
            _feedPageController.updateIndex(index, widget.controller);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _feedPageController.index.value == index
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            height: 10,
            width: 10,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 3,
            child: Align(
              alignment: Alignment.center,
              child: Obx(
                () => Text(titleList[_feedPageController.index.value]),
              ),
            ),
          ),
          Flexible(
            flex: 7,
            fit: FlexFit.tight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getBottomCircle(0),
                getBottomCircle(1),
                getBottomCircle(2),
                getBottomCircle(3),
                getBottomCircle(4),
              ],
            ),
          )
        ],
      ),
    );
  }
}
