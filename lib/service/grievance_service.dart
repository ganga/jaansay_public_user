import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/grievance.dart';
import 'package:jaansay_public_user/service/dio_service.dart';
import 'package:jaansay_public_user/service/notification_service.dart';

class GrievanceService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  getGrievanceMasters(List<GrievanceMaster> grievanceMasters) async {
    final response = await dioService.getData("messages/users/$userId/type/3");

    if (response != null) {
      response['data'].map((val) {
        grievanceMasters.add(GrievanceMaster.fromJson(val));
      }).toList();
    }
  }

  getAllGrievances(List<Grievance> grievances, String officialId) async {
    final response = await dioService.getData(
        "messages/allmessages/official/$officialId/user/$userId/type/3");
    if (response != null) {
      response['data'].map((val) {
        grievances.add(Grievance.fromJson(val));
      }).toList();
      return;
    }
  }

  Future<bool> sendGrievance(String message, String officialId) async {
    final response = await dioService.postData("messages/addmessage", {
      "message": message,
      "official_id": officialId.toString(),
      "user_id": userId.toString(),
      "sender_id": userId.toString(),
      "type": "3",
      "message_type": "0",
      "updated_at": DateTime.now().toString(),
    });
    if (response != null) {
      NotificationService notificationService = NotificationService();
      await notificationService.sendNotificationToUser(
          GetStorage().read("user_name"),
          message,
          officialId.toString(),
          {"type": "message"});
      return true;
    }
    return false;
  }
}
