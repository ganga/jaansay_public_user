import 'package:flutter/material.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_feed_provider.dart';
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

  getOfficialById(
      int officialId, OfficialFeedProvider officialFeedProvider) async {
    official = await officialService.getOfficialById(officialId);
    if (official.isFollow == 1) {
      officialFeedProvider.getFeedData(official);
    }
    isProfileLoad = false;
    notifyListeners();
  }

  followOfficial({OfficialFeedProvider officialFeedProvider, int index}) async {
    if (officialFeedProvider != null) {
      officialFeedProvider.getFeedData(official);
    }

    official.isFollow = 1;
    notifyListeners();

    await followService.followUser(official.officialsId);
  }
}
