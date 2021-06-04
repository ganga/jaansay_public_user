// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/feed_provider.dart';
import 'package:jaansay_public_user/service/follow_service.dart';
import 'package:jaansay_public_user/service/official_service.dart';

class OfficialProfileProvider with ChangeNotifier {
  bool initProfile = false;

  bool isProfileLoad = true;

  OfficialService officialService = OfficialService();
  FollowService followService = FollowService();

  Official official;

  clearData() {
    initProfile = false;
    isProfileLoad = true;
    official = null;
  }

  getOfficialById(int officialId, FeedProvider feedProvider) async {
    official = await officialService.getOfficialById(officialId);
    if (official.isFollow == 1) {
      feedProvider.loadBusinessFeeds(official);
    }
    isProfileLoad = false;
    notifyListeners();
  }

  followOfficial({FeedProvider feedProvider, int index}) async {
    if (feedProvider != null) {
      feedProvider.loadBusinessFeeds(official);
    }

    official.isFollow = 1;
    notifyListeners();

    await followService.followUser(official.officialsId);
  }
}
