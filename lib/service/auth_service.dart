import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/user.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';

class AuthService {
  Future<bool> loginUser(String phone) async {
    phone = phone.substring(3);

    Dio dio = new Dio();

    Response response = await dio.post(
      "${ConnUtils.url}publicusers/signin",
      data: {"user_phone": phone},
    );

    if (response.data['success']) {
      User user = User.fromMap(response.data['data']);
      GetStorage box = GetStorage();
      box.write("token", response.data['token']);
      box.write("user_phone", user.user_phone);
      box.write("user_name", user.user_phone);
      box.write("photo", user.photo);
      box.write("user_id", user.user_id);
    } else {
      return false;
    }
  }
}
