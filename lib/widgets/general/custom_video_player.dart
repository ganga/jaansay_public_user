// import 'package:flutter/material.dart';
// import 'package:jaansay_public_user/widgets/feed/feed_card.dart';
// import 'package:jaansay_public_user/widgets/feed/feed_list_top.dart';

// class CustomVideoPlayer extends StatelessWidget {
//   const CustomVideoPlayer({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final mediaquery = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("demo"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 100,
//               child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 1000,
//                   itemBuilder: (_, index) {
//                     return FeedListTop(mediaQuery: mediaquery);
//                   }),
//             ),
//             Container(
//               height: 1000,
//               child: ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: 1000,
//                   itemBuilder: (_, index) {
//                     return FeedCard([feedDetail[0]]);
//                   }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
