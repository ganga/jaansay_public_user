import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/referral.dart';
import 'package:jaansay_public_user/service/dio_service.dart';
import 'package:jaansay_public_user/utils/misc_utils.dart';

class ReferralService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  getAcceptedReferrals(List<AcceptedReferral> acceptedReferrals) async {
    final response = await dioService.getData("referral/user/$userId");
    if (response != null) {
      response['data'].map((val) {
        acceptedReferrals.add(AcceptedReferral.fromJson(val));
      }).toList();
    }
  }

  getReferralMaster(int officialId) async {
    final response = await dioService.getData("referral/master/$officialId");
    if (response != null) {
      return ReferralMaster.fromJson(response['data'][0]);
    }
    return null;
  }

  getReferralCode(int officialId) async {
    final response = await dioService
        .getData("referral/code/official/$officialId/user/$userId");
    if (response != null) {
      return ReferralCode.fromJson(response['data'][0]);
    }
    return null;
  }

  getReferralCodeDetails(String code) async {
    final response = await dioService.getData("referral/codedetail/$code");
    if (response != null) {
      return ReferralCode.fromJson(response['data'][0]);
    }
    return null;
  }

  addReferralCode(int rmId) async {
    String referralCode = MiscUtils.getRandomId(12);
    String referralLink = await createShareLink(referralCode.toString());

    await dioService.postData("referral/code", {
      "rc_code": referralCode,
      "rm_id": rmId.toString(),
      "user_id": userId,
      "rc_url": referralLink,
      "created_at": DateTime.now().toString()
    });
  }

  Future<String> createShareLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://jaansay.page.link',
      link: Uri.parse('https://www.jaansay.com/referral?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.dev.jaansay_public_user',
      ),
    );
    final dynamicUrl = await parameters.buildShortLink();
    return dynamicUrl.shortUrl.toString();
  }
}
