import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedFilter extends StatefulWidget {
  FeedFilter({
    Key key,
  }) : super(key: key);

  @override
  _FeedFilterState createState() => _FeedFilterState();
}

class _FeedFilterState extends State<FeedFilter> {
  var curIndex = 0.obs;
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
            curIndex(index);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: curIndex.value == index
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
                () => Text(titleList[curIndex.value]),
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
