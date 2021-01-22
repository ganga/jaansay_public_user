import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/message.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class MessageService {
  Future<void> getMessageMasters(List<MessageMaster> messageMasters) async {
    try {
      Dio dio = new Dio();
      GetStorage box = GetStorage();
      final userId = box.read("user_id");

      Response response = await dio.get(
        "${ConnUtils.url}messages/users/$userId/type/0",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
          },
        ),
      );
      if (response.data['success']) {
        response.data['data'].map((val) {
          messageMasters.add(MessageMaster.fromJson(val));
        }).toList();
        return;
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  Future<void> getAllMessages(List<Message> messages, String messageId) async {
    try {
      Dio dio = new Dio();
      GetStorage box = GetStorage();

      Response response = await dio.get(
        "${ConnUtils.url}messages/allmessages/grievance/$messageId/type/0",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
          },
        ),
      );
      if (response.data['success']) {
        response.data['data'].map((val) {
          messages.add(Message.fromJson(val));
        }).toList();
        return;
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  Future<void> getAllMessagesUsingOfficialId(
      List<Message> messages, String officialId) async {
    try {
      Dio dio = new Dio();
      GetStorage box = GetStorage();

      Response response = await dio.get(
        "${ConnUtils.url}messages/allmessages/official/$officialId/user/${box.read("user_id")}/type/1",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
          },
        ),
      );
      if (response.data['success']) {
        response.data['data'].map((val) {
          messages.add(Message.fromJson(val));
        }).toList();
        return;
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  Future<bool> sendMessage(String message, String officialId) async {
    try {
      Dio dio = new Dio();
      GetStorage box = GetStorage();
      final userId = box.read("user_id");

      Response response = await dio.post(
        "${ConnUtils.url}messages/addmessage",
        data: {
          "message": message,
          "official_id": officialId,
          "user_id": userId.toString(),
          "sender_id": userId.toString(),
          "type": "0",
          "message_type": "0",
          "updated_at": DateTime.now().toString(),
        },
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
          },
        ),
      );
      if (response.data['success']) {
        await dio.post(
          "https://fcm.googleapis.com/fcm/send",
          data: {
            "notification": {
              "title": box.read("user_name"),
              "body": message,
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "icon": "http://jaansay.com/logo.png"
            },
            "to": "/topics/official_test_001"
          },
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader:
                  "key=AAAAvyUrLIs:APA91bE8YAhAlWSGKVxOQnj1747vxLecE4ABRSh2ZpatGjp00rCLiQLUMaT6iyiijDyR5RLmiWxZeZ2-SdkGCSRK9NV0ZI_6AFVWMSGr7E3jk4dGEOfJ4sxmyWibiOA_msRIBVB2I1te",
            },
          ),
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
  //
  // Future<bool> sendMessageUsingOfficialId(
  //     String message, String officialId) async {
  //   try {
  //     Dio dio = new Dio();
  //     GetStorage box = GetStorage();
  //     final userId = box.read("user_id");
  //
  //     Response response = await dio.post(
  //       "${ConnUtils.url}messages/addmessage",
  //       data: {
  //         "message": message,
  //         "official_id": officialId.toString(),
  //         "user_id": userId.toString(),
  //         "sender_id": userId.toString(),
  //         "type": "0",
  //         "message_type": "0",
  //         "updated_at": DateTime.now().toString()
  //       },
  //       options: Options(
  //         headers: {
  //           HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
  //         },
  //       ),
  //     );
  //     if (response.data['success']) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
}
