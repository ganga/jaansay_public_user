// Package imports:
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:jaansay_public_user/models/keys.dart';
import 'package:jaansay_public_user/service/dio_service.dart';

class KeyService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  getKeysByOfficialIdForUser(List<KeyMaster> keyMasters, int officialId) async {
    final response =
        await dioService.getData("keys/official/$officialId/user/$userId");
    if (response != null) {
      response['data'].map((val) {
        keyMasters.add(KeyMaster.fromJson(val));
      }).toList();
    }
  }

  addKeyAnswer({int kmId, int optionId, String answer}) async {
    await dioService.postData("keys/answer", {
      "user_id": userId,
      "km_id": kmId,
      "kopt_id": optionId,
      "answer": answer
    });
  }
}
