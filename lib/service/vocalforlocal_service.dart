// Package imports:
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:jaansay_public_user/models/misc.dart';
import 'package:jaansay_public_user/service/dio_service.dart';

class VocalForLocalService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  Future<void> addOfficial(
      {String shopName,
      String phone,
      String latitude,
      String longitude,
      int userTypeId,
      String subTypeName}) async {
    await dioService.postData("vocalforlocal", {
      "user_id": userId,
      "shop_name": shopName,
      "phone": phone,
      "lattitude": latitude,
      "longitude": longitude,
      "type_id": userTypeId,
      "sub_type_name": subTypeName
    });
  }

  getTypes(List<UserType> userTypes) async {
    final response = await dioService.getData("utility/types");
    if (response != null) {
      response['data']
          .map(
            (val) => userTypes.add(
              UserType.fromJson(val),
            ),
          )
          .toList();
    }
  }
}
