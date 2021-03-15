import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/constants/constants.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_feed_provider.dart';
import 'package:jaansay_public_user/providers/user_feed_provider.dart';
import 'package:jaansay_public_user/service/follow_service.dart';
import 'package:jaansay_public_user/service/official_service.dart';

class OfficialProfileProvider with ChangeNotifier {
  bool initOfficials = false;
  bool initProfile = false;

  bool isListLoad = true;
  bool isProfileLoad = true;

  List<Official> officials = [];
  List<String> officialTypes = [];
  bool isSearching = false;

  int selectedOfficialIndex;

  OfficialService officialService = OfficialService();
  FollowService followService = FollowService();

  clearData({bool allData = false}) {
    initProfile = false;
    isProfileLoad = true;

    if (allData) {
      officials.clear();
      officialTypes.clear();
      isSearching = false;
      initOfficials = false;
      selectedOfficialIndex = null;
      isListLoad = true;
    }
  }

  getData(String type, String districtId) async {
    isListLoad = true;
    officials.clear();
    officialTypes.clear();
    officials = await officialService.getAllOfficialsType(type, districtId);
    officials.removeWhere((element) => element.isPrivate == 1);
    officialTypes = getOfficialTypes();
    isListLoad = false;
    notifyListeners();
  }

  getOfficialById(
      String officialId, OfficialFeedProvider officialFeedProvider) async {
    Official tempOfficial = await officialService.getOfficialById(officialId);
    officials.add(tempOfficial);
    selectedOfficialIndex = 0;
    if (officials[selectedOfficialIndex].isFollow == 1) {
      officialFeedProvider.getFeedData(officials[selectedOfficialIndex]);
    }
    isProfileLoad = false;
    notifyListeners();
  }

  searchOfficial(String val) async {
    if (val.length > 2 && !isSearching) {
      isSearching = true;
      isListLoad = true;
      officials.clear();
      await officialService.searchOfficials(val, officials);
      officials.removeWhere(
          (element) => (element.isPrivate == 1 && element.isFollow != 1));
      isListLoad = false;
      isSearching = false;

      notifyListeners();
    } else if (!isSearching) {
      officials.clear();
      notifyListeners();
    }
  }

  followOfficial({OfficialFeedProvider officialFeedProvider, int index}) async {
    if (index != null) {
      selectedOfficialIndex = index;
    }

    if (officialFeedProvider != null) {
      officialFeedProvider.getFeedData(officials[selectedOfficialIndex]);
    }

    officials[selectedOfficialIndex].isFollow = 1;
    notifyListeners();

    await followService
        .followUser(officials[selectedOfficialIndex].officialsId);
  }

  List<String> getOfficialTypes() {
    List<String> tempOfficialTypes = [];

    officials.map((e) {
      if (!tempOfficialTypes.contains(e.businesstypeName)) {
        tempOfficialTypes.add(e.businesstypeName);
      }
    }).toString();

    tempOfficialTypes.sort((a, b) => a.compareTo(b));
    return tempOfficialTypes;
  }

  List<Official> getOfficialsOfType(String type) {
    List<Official> tempOfficial = [];

    officials.map((e) {
      if (e.businesstypeName == type) {
        tempOfficial.add(e);
      }
    }).toString();
    return tempOfficial;
  }

  selectOfficialIndex(Official official) {
    selectedOfficialIndex = officials.indexOf(official);
  }
}
