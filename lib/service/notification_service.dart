import 'dart:io';

import 'package:dio/dio.dart';

class NotificationService {
  Dio dio = new Dio();
  String serverCode =
      "key=AAAAvyUrLIs:APA91bE8YAhAlWSGKVxOQnj1747vxLecE4ABRSh2ZpatGjp00rCLiQLUMaT6iyiijDyR5RLmiWxZeZ2-SdkGCSRK9NV0ZI_6AFVWMSGr7E3jk4dGEOfJ4sxmyWibiOA_msRIBVB2I1te";

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
