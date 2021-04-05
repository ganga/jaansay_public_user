import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/service/dio_service.dart';

class VocalForLocalService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  Future<void> addStore({
    String shopName,
    String phone,
    String latitude,
    String longitude,
  }) async {
    await dioService.postData("vocalforlocal", {
      "user_id": userId,
      "shop_name": shopName,
      "phone": phone,
      "lattitude": latitude,
      "longitude": longitude
    });
  }
}
