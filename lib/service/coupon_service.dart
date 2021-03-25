import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/coupon.dart';
import 'package:jaansay_public_user/service/dio_service.dart';

class CouponService {
  DioService dioService = DioService();
  String userId = GetStorage().read("user_id").toString();

  getCoupons(List<Coupon> coupons) async {
    final response = await dioService.getData("coupon/user/$userId");
    if (response != null) {
      response['data'].map((e) => coupons.add(Coupon.fromJson(e))).toList();
    }
  }
}
