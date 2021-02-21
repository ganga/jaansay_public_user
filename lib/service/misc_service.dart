import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/service/dio_service.dart';

class MiscService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  Future<void> getAllCount(Map countData, List<Map> districtMap) async {
    final response = await dioService.getData("utility/getallcount");
    if (response != null) {
      countData["user"] = response['data'][1][0]['totalUsers'].toString();
      countData["business"] =
          response['data'][2][0]['totalBusiness'].toString();
      countData["association"] =
          response['data'][3][0]['totalAssociations'].toString();
      countData["entity"] = response['data'][4][0]['totalEntities'].toString();
      response['data'][0].map((e) {
        districtMap.add(e);
      }).toList();
    }
  }

  Future<void> getAllCountDistrict(
      Map countData, List<Map> districtMap, String districtId) async {
    final response =
        await dioService.getData("utility/getallcount/$districtId");

    if (response != null) {
      countData["user"] = response['data'][0][0]['totalUsers'].toString();
      countData["business"] =
          response['data'][1][0]['totalBusiness'].toString();
      countData["association"] =
          response['data'][2][0]['totalAssociations'].toString();
      countData["entity"] = response['data'][3][0]['totalEntities'].toString();
    }
  }
}
