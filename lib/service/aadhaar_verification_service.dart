// aadhaar-verification/verify-aadhaar

import 'dio_service.dart';

class AadhaarVerificationService {
  DioService dioService = DioService();

  Future<String> verifyAadhaar(String aadhaar) async {
    Map reqObject = new Map();
    reqObject["id"] = aadhaar;
    final response =   await dioService.postData("aadhaar-verification/verify-aadhaar", reqObject);
    if (response['success']) {
      return response['data']['clientId'];
    }
    return null;
  }

  Future<bool> submitOtp(String clientId, String otp) async {
    Map reqObject = new Map();
    reqObject["clientId"] = clientId;
    reqObject["otp"] = otp;
    final response =   await dioService.postData("aadhaar-verification/submit-aadhaar-otp", reqObject);
    return response['success'];
  }
}