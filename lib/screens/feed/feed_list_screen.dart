import 'package:flutter/material.dart';
import 'package:jaansay_public_user/widgets/feed/feed_list.dart';

class FeedListScreen extends StatefulWidget {
  FeedListScreen({Key key}) : super(key: key);

  @override
  _FeedListScreenState createState() => _FeedListScreenState();
}

class _FeedListScreenState extends State<FeedListScreen> {
  // final FeedPageController _feedPageController = Get.put(FeedPageController());
  // final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: FeedList()),
          /*Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (val) {
                _feedPageController.updateIndex(val, controller);
              },
              children: [
                FeedList(),
                FeedList(),
                FeedList(),
                FeedList(),
                FeedList(),
              ],
            ),
          ),
          FeedFilter(
            controller: controller,
          ),*/
        ],
      ),
    );
  }
}
