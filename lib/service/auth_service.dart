import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/user.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class AuthService {
  Dio dio = new Dio();

  Future<bool> loginUser(String phone, String passcode) async {
    try {
      Response response = await dio.post(
        "${ConnUtils.url}publicusers/signInUsingPassword",
        data: {"user_phone": phone, "user_password": passcode},
      );

      if (response.data['success']) {
        User user = User.fromJson(response.data['data']);
        GetStorage box = GetStorage();
        box.write("token", response.data['token']);
        box.write("user_phone", user.userPhone);
        box.write("user_name", user.userName);
        box.write("photo", user.photo);
        box.write("user_id", user.userId);
        box.write("document", user.document);
        box.write("district_id", user.districtId);
        FirebaseMessaging fbm = FirebaseMessaging();
        fbm.subscribeToTopic(box.read("user_id").toString());
        return true;
      } else {
        print("Failed");
        return false;
      }
    } catch (_) {
      print("error here");
      return false;
    }
  }

  Future<bool> checkUser(String phone) async {
    final response =
        await dio.get("${ConnUtils.url}publicusers/checkUser/$phone");
    if (response.data['message'] == "yes") {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateUserPasscode(String phone, String code) async {
    print("$phone,$code");
    try {
      final response = await dio.patch("${ConnUtils.url}publicusers/password",
          data: {"user_phone": phone, "user_password": code});
      print(response.data.toString());
      if (response.data['success']) {
        return await loginUser(phone, code);
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
