// Package imports:
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:jaansay_public_user/models/message.dart';
import 'package:jaansay_public_user/service/dio_service.dart';
import 'package:jaansay_public_user/service/notification_service.dart';

class MessageService {
  String userId = GetStorage().read("user_id").toString();
  DioService dioService = DioService();

  Future<void> getMessageMasters(List<MessageMaster> messageMasters) async {
    final response = await dioService.getData("messages/users/$userId/type/0");
    if (response != null) {
      response['data'].map((val) {
        messageMasters.add(MessageMaster.fromJson(val));
      }).toList();
    }
  }

  Future<void> getAllMessages(List<Message> messages, String messageId) async {
    final response = await dioService
        .getData("messages/allmessages/grievance/$messageId/type/0");

    if (response != null) {
      response['data'].map((val) {
        messages.add(Message.fromJson(val));
      }).toList();
    }
  }

  Future<void> getAllMessagesUsingOfficialId(
      List<Message> messages, String officialId) async {
    final response = await dioService.getData(
        "messages/allmessages/official/$officialId/user/$userId/type/1");
    if (response != null) {
      response['data'].map((val) {
        messages.add(Message.fromJson(val));
      }).toList();
    }
  }

  Future<bool> sendMessage(String message, String officialId) async {
    final response = await dioService.postData("messages/addmessage", {
      "message": message,
      "official_id": officialId,
      "user_id": userId.toString(),
      "sender_id": userId.toString(),
      "type": "0",
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
    } else {
      return false;
    }
  }
}
