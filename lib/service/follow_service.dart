import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/service/dio_service.dart';
import 'package:jaansay_public_user/service/notification_service.dart';

class FollowService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  Future<bool> followUser(int officialId) async {
    final response = await dioService.patchData("follow", {
      "is_follow": "1",
      "official_id": officialId.toString(),
      "user_id": userId.toString()
    });
    if (response != null) {
      NotificationService notificationService = NotificationService();
      await notificationService.sendNotificationToUser(
          "New Follower",
          "$userId has started following you.",
          officialId.toString(),
          {"type": "follow"});
    }

    return true;
  }

  Future<bool> rejectFollow(int officialId) async {
    await dioService.deleteData("follow/$userId/$officialId");

    return true;
  }
}
