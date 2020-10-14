// ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   shrinkWrap: true,
//                   physics: ClampingScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     return FeedListTop(mediaQuery: _mediaQuery);
//                   },
//                   itemCount: 3,
//                 )
//  Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Expanded(
//           child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: 123,
//               itemBuilder: (BuildContext context, int index) {
//                 return  index == 0 ? ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   shrinkWrap: true,
//                   physics: ClampingScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     return FeedListTop(mediaQuery: _mediaQuery);
//                   },
//                   itemCount: 3,
//                 ) : FeedCard(feedDetail[0]);
//               }),
//         )
//       ],
//     ),
