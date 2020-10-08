// import 'package:http/http.dart' as http;
// import 'package:jaansay_public_user/models/feed.dart';
// import 'package:jaansay_public_user/models/user.dart';
// import 'url_utility.dart';

// class FeedUtility {
//    List<Feed> _feeds = [];
//   Future<void> deleteFeed(String id) async {
//     final response =
//         await http.post('${UrlUtility.mainUrl}deleteFeed.php', body: {
//       'feed_id': id,
//     });
//     return;
//   }
//   List<Map<String, dynamic>> getFeed(
//       FeedResources feedResources, User users, Categories categories) {
//     List<Map<String, dynamic>> _feedList = [];
//     _feeds.map((e) {
//       if (categories.getSelectedList().contains(e.categoryId)) {
//         _feedList.add({
//           'feedId': e.feedId,
//           'feedDescription': e.feedDescription,
//           'time': e.feedTime,
//           'feedType': e.feedType,
//           'feedRes': feedResources.getFeedResource(e.feedId),
//           'userName': "users.getFacultyName(e.userId)",
//           'userId': e.userId,
//           'userProfile': "faculties.getFacultyImage(e.facultyId)",
//           'categoryName': categories.getCategoryName(e.categoryId)
//         });
//       }
//     }).toList();
//     _feedList.sort((a, b) {
//       return DateTime.parse(b['time']).compareTo(DateTime.parse(a['time']));
//     });

//     return _feedList;
//   }
// }
