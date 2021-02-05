import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jaansay_public_user/constants/constants.dart';

class NotificationService {
  Dio dio = new Dio();
  String serverCode = Constants.notificationServerCode;

  Future sendNotificationToUser(
    String title,
    String message,
    String userId,
    Map data,
  ) async {
    await dio.post(
      "https://fcm.googleapis.com/fcm/send",
      data: {
        "notification": {
          "title": title,
          "body": message,
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "icon": "http://jaansay.com/logo.png"
        },
        "to": "/topics/$userId",
        "data": data
      },
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: serverCode,
        },
      ),
    );
    return;
  }
}
